import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => MicrophoneTestBloc(),
        child: MicrophoneTestPage(),
      ),
    );
  }
}

class MicrophoneTestPage extends StatelessWidget {
  const MicrophoneTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Microphone Test")),
      body: BlocBuilder<MicrophoneTestBloc, MicrophoneTestState>(
        builder: (context, state) {
          String statusMessage = '';
          double currentDecibels = 0.0;
          bool testFailed = false;
          String recognizedWords = '';

          if (state is MicrophoneTestRecordingState) {
            currentDecibels = state.currentDecibels;
            statusMessage = state.statusMessage;
            recognizedWords = state.recognizedWords;
          } else if (state is MicrophoneTestSuccessState) {
            statusMessage = state.statusMessage;
            recognizedWords = state.recognizedWords;
          } else if (state is MicrophoneTestFailureState) {
            statusMessage = state.statusMessage;
            testFailed = true;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Current Decibels: ${currentDecibels.toStringAsFixed(2)} dB",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(
                    value: currentDecibels > 0 ? currentDecibels / 100 : 0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 10,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (state is MicrophoneTestRecordingState) {
                      context
                          .read<MicrophoneTestBloc>()
                          .add(StopRecordingEvent());
                    } else {
                      context
                          .read<MicrophoneTestBloc>()
                          .add(StartRecordingEvent());
                    }
                  },
                  child: Text(
                      state is MicrophoneTestRecordingState ? "Stop" : "Start"),
                ),
                SizedBox(height: 20),
                Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 18,
                    color: testFailed ? Colors.red : Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                if (recognizedWords.isNotEmpty)
                  Text(
                    "Recognized Words: $recognizedWords",
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MicrophoneTestBloc
    extends Bloc<MicrophoneTestEvent, MicrophoneTestState> {
  FlutterSoundRecorder? _recorder;
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  double currentDecibels = 0.0;
  String recognizedWords = '';

  MicrophoneTestBloc() : super(MicrophoneTestInitialState()) {
    on<StartRecordingEvent>(_startRecording);
    on<StopRecordingEvent>(_stopRecording);
  }

  Future<void> _startRecording(
      StartRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        emit(MicrophoneTestFailureState(
            statusMessage: 'Microphone permission denied.'));
        return;
      }

      // ✅ Proper disposal before re-initializing
      if (_recorder != null) {
        await _recorder!.closeRecorder();
        _recorder = null;
      }

      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();

      bool available = await _speechToText.initialize();
      if (!available) {
        emit(MicrophoneTestFailureState(
            statusMessage: 'Speech recognition not available.'));
        return;
      }

      // ✅ Stop any previous speech recognition session
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }

      // ✅ Reset values on new start
      currentDecibels = 0.0;
      recognizedWords = '';

      emit(MicrophoneTestRecordingState(
        currentDecibels: currentDecibels,
        statusMessage: 'Recording...',
        recognizedWords: recognizedWords,
      ));

      await _recorder!.startRecorder(
        toFile: 'test.aac',
        codec: Codec.aacMP4,
      );

      await _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));

      _recorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          currentDecibels = event.decibels!;
          if (!emit.isDone) {
            emit(MicrophoneTestRecordingState(
              currentDecibels: currentDecibels,
              statusMessage: 'Recording...',
              recognizedWords: recognizedWords,
            ));
          }
        }
      });

      // ✅ Start speech recognition after stopping any previous session
      await Future.delayed(
          Duration(milliseconds: 500)); // Small delay to avoid conflicts

      _speechToText.listen(onResult: (result) {
        recognizedWords = result.recognizedWords;
        if (!emit.isDone) {
          emit(MicrophoneTestRecordingState(
            currentDecibels: currentDecibels,
            statusMessage: 'Recording...',
            recognizedWords: recognizedWords,
          ));
        }
      });

      await Future.delayed(Duration(seconds: 20));

      if (!emit.isDone) {
        if (recognizedWords.split(' ').length > 5) {
          emit(MicrophoneTestSuccessState(
              statusMessage: 'Test Successful!',
              recognizedWords: recognizedWords));
        } else {
          emit(MicrophoneTestFailureState(
              statusMessage:
                  'Microphone Test Failed: Insufficient words recognized.'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
      }
    }
  }

  Future<void> _stopRecording(
      StopRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    try {
      if (_recorder != null) {
        await _recorder!.stopRecorder();
        await _recorder!.closeRecorder();
        _recorder = null; // ✅ Dispose after stopping
      }

      _speechToText.stop();

      if (!emit.isDone) {
        if (recognizedWords.split(' ').length > 5) {
          emit(MicrophoneTestSuccessState(
              statusMessage: 'Test Successful!',
              recognizedWords: recognizedWords));
        } else {
          emit(MicrophoneTestFailureState(
              statusMessage:
                  'Microphone Test Failed: Insufficient words recognized.'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
      }
    }
  }
}

/// Events
abstract class MicrophoneTestEvent {}

class StartRecordingEvent extends MicrophoneTestEvent {}

class StopRecordingEvent extends MicrophoneTestEvent {}

/// States
abstract class MicrophoneTestState {}

class MicrophoneTestInitialState extends MicrophoneTestState {}

class MicrophoneTestRecordingState extends MicrophoneTestState {
  final double currentDecibels;
  final String statusMessage;
  final String recognizedWords;

  MicrophoneTestRecordingState({
    required this.currentDecibels,
    required this.statusMessage,
    required this.recognizedWords,
  });
}

class MicrophoneTestSuccessState extends MicrophoneTestState {
  final String statusMessage;
  final String recognizedWords;

  MicrophoneTestSuccessState({
    required this.statusMessage,
    required this.recognizedWords,
  });
}

class MicrophoneTestFailureState extends MicrophoneTestState {
  final String statusMessage;

  MicrophoneTestFailureState({required this.statusMessage});
}

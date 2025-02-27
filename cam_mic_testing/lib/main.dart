import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

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

          if (state is MicrophoneTestRecordingState) {
            currentDecibels = state.currentDecibels;
            statusMessage = state.statusMessage;
          } else if (state is MicrophoneTestSuccessState) {
            statusMessage = state.statusMessage;
          } else if (state is MicrophoneTestFailureState) {
            statusMessage = state.statusMessage;
            testFailed = true;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Current Decibels: ${currentDecibels.toStringAsFixed(2)} dB",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // LinearProgressIndicator showing the waveform
              SizedBox(
                width: 300,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(100),
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
                  state is MicrophoneTestRecordingState ? "Stop" : "Start",
                ),
              ),
              SizedBox(height: 20),
              Text(
                statusMessage,
                style: TextStyle(
                  fontSize: 18,
                  color: testFailed ? Colors.red : Colors.green,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Events
abstract class MicrophoneTestEvent {}

class StartRecordingEvent extends MicrophoneTestEvent {}

class StopRecordingEvent extends MicrophoneTestEvent {}

// States
abstract class MicrophoneTestState {}

class MicrophoneTestInitialState extends MicrophoneTestState {}

class MicrophoneTestRecordingState extends MicrophoneTestState {
  final double currentDecibels;
  final String statusMessage;

  MicrophoneTestRecordingState({
    required this.currentDecibels,
    required this.statusMessage,
  });
}

class MicrophoneTestSuccessState extends MicrophoneTestState {
  final String statusMessage;

  MicrophoneTestSuccessState({required this.statusMessage});
}

class MicrophoneTestFailureState extends MicrophoneTestState {
  final String statusMessage;

  MicrophoneTestFailureState({required this.statusMessage});
}

// BLoC
class MicrophoneTestBloc
    extends Bloc<MicrophoneTestEvent, MicrophoneTestState> {
  FlutterSoundRecorder? _recorder;
  double currentDecibels = 0.0;

  MicrophoneTestBloc() : super(MicrophoneTestInitialState()) {
    on<StartRecordingEvent>(_startRecording);
    on<StopRecordingEvent>(_stopRecording);
  }

  Future<void> _startRecording(
      StartRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    try {
      // Request microphone permission
      var status = await Permission.microphone.request();

      if (status != PermissionStatus.granted) {
        emit(MicrophoneTestFailureState(
            statusMessage: 'Microphone permission denied. No sound detected.'));
        return;
      }

      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();

      emit(MicrophoneTestRecordingState(
        currentDecibels: 0.0,
        statusMessage: 'Recording...',
      ));

      await _recorder!.startRecorder(
        toFile: 'test.aac',
        codec: Codec.aacMP4,
      );

      await _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));

      _recorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          currentDecibels = event.decibels!;
          emit(MicrophoneTestRecordingState(
            currentDecibels: currentDecibels,
            statusMessage: 'Recording...',
          ));
        }
      });

      // Check for microphone input after 5 seconds
      await Future.delayed(Duration(seconds: 5));

      if (currentDecibels <= 10.0) {
        emit(MicrophoneTestFailureState(
            statusMessage: 'Microphone Test Failed: No sound detected.'));
      } else {
        emit(MicrophoneTestSuccessState(statusMessage: 'Test Successful!'));
      }
    } catch (e) {
      emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
    }
  }

  Future<void> _stopRecording(
      StopRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    await _recorder!.stopRecorder();
    _recorder!.closeRecorder();

    if (currentDecibels > 10.0) {
      emit(MicrophoneTestSuccessState(statusMessage: 'Test Successful!'));
    } else {
      emit(MicrophoneTestFailureState(
          statusMessage: 'Microphone Test Failed: No sound detected.'));
    }
  }
}

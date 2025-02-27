import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

/// Entry point of the application
void main() {
  runApp(MyApp());
}

/// The main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Disables the debug banner
      home: BlocProvider(
        /// Provides the MicrophoneTestBloc to the widget tree
        create: (_) => MicrophoneTestBloc(),
        child: MicrophoneTestPage(),
      ),
    );
  }
}

/// The UI page for testing the microphone
class MicrophoneTestPage extends StatelessWidget {
  const MicrophoneTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Microphone Test")),

      /// Sets the app bar title
      body: BlocBuilder<MicrophoneTestBloc, MicrophoneTestState>(
        /// Rebuilds UI based on state changes from the BLoC
        builder: (context, state) {
          String statusMessage = '';
          double currentDecibels = 0.0;
          bool testFailed = false;

          /// Determine the UI message and decibels based on the current state
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
              /// Displays the current decibel level
              Text(
                "Current Decibels: ${currentDecibels.toStringAsFixed(2)} dB",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              /// Progress bar representing the microphone input level
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

              /// Start/Stop button for recording
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

              /// Displays the test result message
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

class MicrophoneTestBloc
    extends Bloc<MicrophoneTestEvent, MicrophoneTestState> {
  /// FlutterSoundRecorder instance to handle audio recording.

  FlutterSoundRecorder? _recorder;

  /// Stores the current decibel level.

  double currentDecibels = 0.0;

  MicrophoneTestBloc() : super(MicrophoneTestInitialState()) {
    /// Listens for StartRecordingEvent and calls `_startRecording`.

    on<StartRecordingEvent>(_startRecording);

    /// Listens for StopRecordingEvent and calls `_stopRecording`.

    on<StopRecordingEvent>(_stopRecording);
  }

  /// Starts recording and updates decibel levels.

  Future<void> _startRecording(
      StartRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    try {
      /// Request microphone permission from the user.
      var status = await Permission.microphone.request();

      /// If permission is denied, emit a failure state and return.
      if (status != PermissionStatus.granted) {
        emit(MicrophoneTestFailureState(
            statusMessage: 'Microphone permission denied. No sound detected.'));
        return;
      }

      /// Initialize the recorder.
      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();

      /// Emit state indicating that recording has started.

      emit(MicrophoneTestRecordingState(
        currentDecibels: 0.0,
        statusMessage: 'Recording...',
      ));

      /// Start recording to a temporary file in AAC format.

      await _recorder!.startRecorder(
        toFile: 'test.aac',
        codec: Codec.aacMP4,
      );

      /// Set the duration for microphone input updates.

      await _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));

      /// Listen for audio level updates.

      _recorder!.onProgress!.listen((event) {
        /// If decibel data is available, update `currentDecibels`.

        if (event.decibels != null) {
          currentDecibels = event.decibels!;

          /// Ensure `emit` is still valid before updating state.

          if (!emit.isDone) {
            emit(MicrophoneTestRecordingState(
              currentDecibels: currentDecibels,
              statusMessage: 'Recording...',
            ));
          }
        }
      });

      // Wait for 5 seconds to analyze microphone input
      await Future.delayed(Duration(seconds: 5));

      /// Ensure `emit` is still active before sending the final state.

      if (!emit.isDone) {
        if (currentDecibels <= 10.0) {
          emit(MicrophoneTestFailureState(
              statusMessage: 'Microphone Test Failed: No sound detected.'));
        } else {
          emit(MicrophoneTestSuccessState(statusMessage: 'Test Successful!'));
        }
      }
    } catch (e) {
      /// Catch any errors and emit a failure state.

      if (!emit.isDone) {
        emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
      }
    }
  }

  /// Stops recording and determines if the test was successful.

  Future<void> _stopRecording(
      StopRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    try {
      /// Stop and close the recorder safely.

      if (_recorder != null) {
        await _recorder!.stopRecorder();
        await _recorder!.closeRecorder();
      }

      /// Ensure `emit` is still active before updating state.
      if (!emit.isDone) {
        /// If the decibel level was sufficient, test is successful.
        if (currentDecibels > 10.0) {
          emit(MicrophoneTestSuccessState(statusMessage: 'Test Successful!'));
        } else {
          emit(MicrophoneTestFailureState(
              statusMessage: 'Microphone Test Failed: No sound detected.'));
        }
      }
    } catch (e) {
      /// Catch any errors and emit a failure state.

      if (!emit.isDone) {
        emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
      }
    }
  }
}

/// Abstract base class for microphone test events.
abstract class MicrophoneTestEvent {}

/// Event to start the microphone recording.
class StartRecordingEvent extends MicrophoneTestEvent {}

/// Event to stop the microphone recording.
class StopRecordingEvent extends MicrophoneTestEvent {}

/// Abstract base class for microphone test states.
abstract class MicrophoneTestState {}

/// Initial state before any action is taken.
class MicrophoneTestInitialState extends MicrophoneTestState {}

/// State indicating that recording is in progress.
class MicrophoneTestRecordingState extends MicrophoneTestState {
  /// Current decibel level.
  final double currentDecibels;

  /// Status message for UI updates.
  final String statusMessage;

  /// Constructor to initialize state with decibel level and message.
  MicrophoneTestRecordingState({
    required this.currentDecibels,
    required this.statusMessage,
  });
}

/// State indicating that the microphone test was successful.
class MicrophoneTestSuccessState extends MicrophoneTestState {
  /// Status message to display success.
  final String statusMessage;

  /// Constructor to initialize state with success message.
  MicrophoneTestSuccessState({required this.statusMessage});
}

/// State indicating that the microphone test failed.
class MicrophoneTestFailureState extends MicrophoneTestState {
  /// Status message to display failure.
  final String statusMessage;

  /// Constructor to initialize state with failure message.
  MicrophoneTestFailureState({required this.statusMessage});
}

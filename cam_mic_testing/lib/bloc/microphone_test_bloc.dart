// microphone_test_bloc.dart
import 'dart:async';
import 'package:cam_mic_testing/bloc/microphone_test_event.dart';
import 'package:cam_mic_testing/bloc/microphone_test_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class MicrophoneTestBloc
    extends Bloc<MicrophoneTestEvent, MicrophoneTestState> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  double currentDecibels = 0.0;

  MicrophoneTestBloc() : super(MicrophoneTestInitialState()) {
    on<StartRecordingEvent>(_startRecording);
    on<StopRecordingEvent>(_stopRecording);
  }

  Future<void> _startRecording(
      StartRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    try {
      await Permission.microphone.request();
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

      _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));

      _recorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          currentDecibels = event.decibels!;
          emit(MicrophoneTestRecordingState(
            currentDecibels: currentDecibels,
            statusMessage: 'Recording...',
          ));
        }
      });

      // Check for microphone input after 5 seconds to determine success
      Future.delayed(Duration(seconds: 5), () {
        if (currentDecibels <= 0.0) {
          emit(MicrophoneTestFailureState(
              statusMessage: 'Microphone Test Failed: No sound detected.'));
        } else if (!_isRecording) {
          emit(MicrophoneTestSuccessState(statusMessage: 'Test Successful!'));
        }
      });
    } catch (e) {
      emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
    }
  }

  Future<void> _stopRecording(
      StopRecordingEvent event, Emitter<MicrophoneTestState> emit) async {
    await _recorder!.stopRecorder();
    _recorder!.closeRecorder();

    if (currentDecibels > 0.0) {
      emit(MicrophoneTestSuccessState(statusMessage: 'Test Successful!'));
    } else {
      emit(MicrophoneTestFailureState(
          statusMessage: 'Microphone Test Failed: No sound detected.'));
    }
  }
}

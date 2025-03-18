import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:record/record.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webrtc/modules/testing_screen/presentation/bloc/mic_testing_bloc/mic_testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/mic_testing_bloc/mic_testing_state.dart';
import 'package:webrtc/util/test_session_data.dart';

class MicrophoneTestBloc
    extends Bloc<MicrophoneTestEvent, MicrophoneTestState> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final AudioRecorder _audioRecorder = AudioRecorder();
  List<String> availableMicrophones = [];
  String recognizedWords = '';
  String statusMessage = '';
  bool isTestFailed = false;
  String selectedMicrophone = '';

  MicrophoneTestBloc() : super(MicrophoneTestInitialState()) {
    on<StartRecordingEvent>(_startRecording);
    on<StopRecordingEvent>(_stopRecording);
    on<LoadMicrophonesEvent>(_loadMicrophones);
    on<SelectMicrophoneEvent>(_selectMicrophone);
  }

  Future<void> _loadMicrophones(
      LoadMicrophonesEvent event, Emitter<MicrophoneTestState> emit) async {
    // Request permission
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      emit(MicrophoneTestFailureState(
          statusMessage: 'Microphone permission denied.'));
      return;
    }
    if (kIsWeb) {
      // For Web
      final devices =
          await html.window.navigator.mediaDevices?.enumerateDevices();
      if (devices != null) {
        availableMicrophones = devices
            .where((device) => device.kind == "audioinput")
            .map((device) => device.label.toString())
            .toList();
        log(availableMicrophones.toString());
      }
    } else {
      // For Mobile/Desktop (using a recorder package like `audio_recorder`)
      List<InputDevice> devices = await _audioRecorder.listInputDevices();
      availableMicrophones = devices.map((device) => device.label).toList();
      log(availableMicrophones.toString());
    }
    selectedMicrophone = availableMicrophones.first;
    emit(MicrophoneListLoadedState(
      microphones: availableMicrophones,
      selectedMicrophone: availableMicrophones.isNotEmpty
          ? availableMicrophones.first
          : null, // Select first if available
    ));
  }

  void _selectMicrophone(
      SelectMicrophoneEvent event, Emitter<MicrophoneTestState> emit) {
    selectedMicrophone = event.selectedMicrophone;
    emit(MicrophoneListLoadedState(
        microphones: availableMicrophones,
        selectedMicrophone: event.selectedMicrophone));
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
      recognizedWords = '';

      emit(MicrophoneTestRecordingState(
          statusMessage: 'Recording...',
          microphones: availableMicrophones,
          recognizedWords: recognizedWords,
          selectedMicrophone: selectedMicrophone));

      // ✅ Start speech recognition after stopping any previous session
      await Future.delayed(
          const Duration(milliseconds: 500)); // Small delay to avoid conflicts

      _speechToText.listen(onResult: (result) {
        recognizedWords = result.recognizedWords;

        if (!emit.isDone) {
          emit(MicrophoneTestRecordingState(
              statusMessage: 'Recording...',
              selectedMicrophone: selectedMicrophone,
              recognizedWords: recognizedWords,
              microphones: availableMicrophones));
        }
      });
      await Future.delayed(const Duration(seconds: 12));
      String statusMessage;

      if (!emit.isDone) {
        if (recognizedWords.split(' ').length > 5) {
          await TestSessionData.storeTestSessionData(
              isCameraTest: TestSessionData.isCameraTest,
              isMicTest: true,
              isSpeakerTest: TestSessionData.isSpeakerTest);

          statusMessage = 'Microphone is working accurately';
          isTestFailed = false;
        } else {
          isTestFailed = true;

          statusMessage =
              'Microphone Test Failed: Insufficient words recognized.';
        }

        // ✅ Emit a combined state with both dropdown & status message
        emit(MicrophoneTestStoppedState(
          isTestFailed: isTestFailed,
          microphones: availableMicrophones,
          selectedMicrophone: selectedMicrophone,
          statusMessage: statusMessage,
        ));
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
      _speechToText.stop();

      if (recognizedWords.split(' ').length > 5) {
        await TestSessionData.storeTestSessionData(
            isCameraTest: TestSessionData.isCameraTest,
            isMicTest: true,
            isSpeakerTest: TestSessionData.isSpeakerTest);
        statusMessage = 'Microphone is working accurately';
        isTestFailed = false;
      } else {
        isTestFailed = true;
        statusMessage =
            'Microphone Test Failed: Insufficient words recognized.';
      }

      // ✅ Emit a combined state with both dropdown & status message
      emit(MicrophoneTestStoppedState(
        isTestFailed: isTestFailed,
        microphones: availableMicrophones,
        selectedMicrophone: selectedMicrophone,
        statusMessage: statusMessage,
      ));
    } catch (e) {
      emit(MicrophoneTestFailureState(statusMessage: 'Error: $e'));
    }
  }
}

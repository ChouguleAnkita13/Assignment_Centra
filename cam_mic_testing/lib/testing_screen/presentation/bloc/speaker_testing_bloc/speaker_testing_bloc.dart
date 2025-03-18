import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webrtc/modules/testing_screen/presentation/bloc/speaker_testing_bloc/speaker_testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/speaker_testing_bloc/speaker_testing_state.dart';
import 'dart:html' as html;

import 'package:webrtc/util/test_session_data.dart';

// Bloc Logic// Bloc Logic
class SpeakerBloc extends Bloc<SpeakerEvent, SpeakerState> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  List<String> availableMicrophones = [];

  String selectedMicrophone = '';
  final AudioRecorder _audioRecorder = AudioRecorder();

  final String _testMessage = "Hello Olivia, all the best for your interview";

  SpeakerBloc() : super(SpeakerState()) {
    on<TestSpeaker>(_onTestSpeaker);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<LoadMicrophonesEvent>(_loadMicrophones);
    on<SelectMicrophoneEvent>(_selectMicrophone);
  }
  Future<void> _loadMicrophones(
      LoadMicrophonesEvent event, Emitter<SpeakerState> emit) async {
    // Request permission
    var status = await Permission.microphone.request();
    bool permissionGranted = (status == PermissionStatus.granted);

    if (!permissionGranted) {
      // If permission is denied, update the state with permission status
      emit(state.copyWith(microphonePermissionGranted: false));
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
      List<InputDevice> devices = await _audioRecorder.listInputDevices();
      availableMicrophones = devices.map((device) => device.label).toList();
      log(availableMicrophones.toString());
    }

    selectedMicrophone =
        availableMicrophones.isNotEmpty ? availableMicrophones.first : '';

    emit(state.copyWith(
      availableMicrophones: availableMicrophones,
      selectedMicrophone: selectedMicrophone,
      microphonePermissionGranted: permissionGranted,
    ));
  }

  void _selectMicrophone(
      SelectMicrophoneEvent event, Emitter<SpeakerState> emit) {
    selectedMicrophone = event.selectedMicrophone;
    // Emit new state with loaded microphones
    emit(state.copyWith(
      availableMicrophones: availableMicrophones,
      selectedMicrophone: selectedMicrophone,
    ));
  }

  // Inside the SpeakerBloc

  Future<void> _onTestSpeaker(
      TestSpeaker event, Emitter<SpeakerState> emit) async {
    emit(state.copyWith(
        isTesting: true,
        testSuccessful: false,
        testAttempted: true,
        testCompleted: false));

    // Ensure asynchronous operations are awaited properly
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.8);
    await _flutterTts.speak(_testMessage);

    await Future.delayed(const Duration(seconds: 6));

    // After the async operation completes, emit the next state
    emit(state.copyWith(isTesting: false, testCompleted: true));
  }

  Future<void> _onStartListening(
      StartListening event, Emitter<SpeakerState> emit) async {
    emit(state.copyWith(
      testSuccessful: null,
      recognizedText: '',
      isListening: true, // Start listening
    ));

    if (_speechToText.isListening) {
      await _speechToText.stop();
      emit(state.copyWith(isListening: false, recognizedText: ""));
    }

    bool available = await _speechToText.initialize();
    await Future.delayed(const Duration(milliseconds: 200));

    if (available) {
      await _speechToText.listen(
        onResult: (result) async {
          if (!emit.isDone) {
            final recognizedText = result.recognizedWords.toLowerCase();

            const String targetPhrase = "all the best for your interview";

            bool testSuccessful = recognizedText.contains(targetPhrase);
            if (testSuccessful) {
              await TestSessionData.storeTestSessionData(
                  isCameraTest: TestSessionData.isCameraTest,
                  isMicTest: TestSessionData.isMicTest,
                  isSpeakerTest: true);
              emit(state.copyWith(
                testSuccessful: testSuccessful,
                isListening: false,
                recognizedText: recognizedText,
                testCompleted: true,
              ));
            } else {
              emit(state.copyWith(
                testSuccessful: testSuccessful,
                isListening: true,
                recognizedText: recognizedText,
                testCompleted: true,
              ));
            }
          }
        },
      );

      await Future.delayed(const Duration(seconds: 10), () {
        add(StopListening());
      });
    } else {
      emit(state.copyWith(isListening: false));
    }
  }

  Future<void> _onStopListening(
      StopListening event, Emitter<SpeakerState> emit) async {
    await _speechToText.stop();
    emit(state.copyWith(isListening: false));
  }
}

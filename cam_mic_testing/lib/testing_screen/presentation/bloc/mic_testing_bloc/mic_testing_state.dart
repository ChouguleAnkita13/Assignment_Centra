abstract class MicrophoneTestState {}

class MicrophoneTestInitialState extends MicrophoneTestState {}

class MicrophoneTestRecordingState extends MicrophoneTestState {
  final String statusMessage;
  final List<String> microphones;
  final String? selectedMicrophone;
  final String recognizedWords;

  MicrophoneTestRecordingState(
      {required this.statusMessage,
      required this.microphones,
      required this.recognizedWords,
      this.selectedMicrophone});
}

class MicrophoneTestSuccessState extends MicrophoneTestState {
  final String statusMessage;
  MicrophoneTestSuccessState({required this.statusMessage});
}

class MicrophoneTestFailureState extends MicrophoneTestState {
  final String statusMessage;
  MicrophoneTestFailureState({required this.statusMessage});
}

class MicrophoneListLoadedState extends MicrophoneTestState {
  final List<String> microphones;
  final String? selectedMicrophone;

  MicrophoneListLoadedState(
      {required this.microphones, this.selectedMicrophone});
}

class MicrophoneTestStoppedState extends MicrophoneTestState {
  final List<String> microphones;
  final String? selectedMicrophone;
  final String statusMessage;
  final bool isTestFailed;

  MicrophoneTestStoppedState({
    required this.isTestFailed,
    required this.microphones,
    required this.selectedMicrophone,
    required this.statusMessage,
  });
}

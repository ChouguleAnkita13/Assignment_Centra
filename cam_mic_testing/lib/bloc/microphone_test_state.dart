// states.dart
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

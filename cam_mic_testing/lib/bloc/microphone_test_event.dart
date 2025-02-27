// events.dart
abstract class MicrophoneTestEvent {}

class StartRecordingEvent extends MicrophoneTestEvent {}

class StopRecordingEvent extends MicrophoneTestEvent {}

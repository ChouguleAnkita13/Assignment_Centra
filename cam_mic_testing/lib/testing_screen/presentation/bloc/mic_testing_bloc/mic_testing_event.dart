/// Events
abstract class MicrophoneTestEvent {}

class StartRecordingEvent extends MicrophoneTestEvent {}

class StopRecordingEvent extends MicrophoneTestEvent {}

class LoadMicrophonesEvent extends MicrophoneTestEvent {}

class SelectMicrophoneEvent extends MicrophoneTestEvent {
  final String selectedMicrophone;
  SelectMicrophoneEvent(this.selectedMicrophone);
}

// Bloc Events
abstract class SpeakerEvent {}

class TestSpeaker extends SpeakerEvent {}

class StartListening extends SpeakerEvent {}

class StopListening extends SpeakerEvent {}

class LoadMicrophonesEvent extends SpeakerEvent {}

class SelectMicrophoneEvent extends SpeakerEvent {
  final String selectedMicrophone;
  SelectMicrophoneEvent(this.selectedMicrophone);
}

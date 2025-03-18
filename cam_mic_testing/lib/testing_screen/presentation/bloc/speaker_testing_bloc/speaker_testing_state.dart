class SpeakerState {
  final bool isTesting;
  final bool testSuccessful;
  final bool isListening;
  final String recognizedText;
  final bool testCompleted;
  final bool testAttempted;
  final List<String> availableMicrophones;
  final String selectedMicrophone;
  final bool isTestFailed;
  final bool microphonePermissionGranted; // Add this line to track permission

  SpeakerState({
    this.isTesting = false,
    this.testSuccessful = false,
    this.isListening = false,
    this.recognizedText = "",
    this.testCompleted = false,
    this.testAttempted = false,
    this.isTestFailed = false,
    this.availableMicrophones = const [],
    this.selectedMicrophone = '',
    this.microphonePermissionGranted = false, // Default to false
  });

  SpeakerState copyWith({
    bool? isTesting,
    bool? testSuccessful,
    bool? isListening,
    String? recognizedText,
    bool? testCompleted,
    bool? testAttempted,
    bool? isTestFailed,
    List<String>? availableMicrophones,
    String? selectedMicrophone,
    bool? microphonePermissionGranted, // Add this to allow changes
  }) {
    return SpeakerState(
      isTesting: isTesting ?? this.isTesting,
      testSuccessful: testSuccessful ?? this.testSuccessful,
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      testCompleted: testCompleted ?? this.testCompleted,
      testAttempted: testAttempted ?? this.testAttempted,
      isTestFailed: isTestFailed ?? this.isTestFailed,
      availableMicrophones: availableMicrophones ?? this.availableMicrophones,
      selectedMicrophone: selectedMicrophone ?? this.selectedMicrophone,
      microphonePermissionGranted: microphonePermissionGranted ??
          this.microphonePermissionGranted, // Copy the permission state
    );
  }
}

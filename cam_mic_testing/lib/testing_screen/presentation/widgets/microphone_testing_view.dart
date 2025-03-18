import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/mic_testing_bloc/mic_testing_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/mic_testing_bloc/mic_testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/mic_testing_bloc/mic_testing_state.dart';
import 'package:webrtc/util/theme/colors.dart';
import 'package:webrtc/util/theme/text_styles.dart';

import 'package:webrtc/util/ui_helpers.dart';

class MicrophoneTestingView extends StatelessWidget {
  const MicrophoneTestingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => MicrophoneTestBloc()..add(LoadMicrophonesEvent()),
      child: BlocBuilder<MicrophoneTestBloc, MicrophoneTestState>(
          builder: (context, state) {
        String statusMessage = '';
        bool testFailed = false;
        bool isRecording = false;
        String? selectedMicrophone;
        String recognizedWords = '';
        List<String> microphones = [];

        if (state is MicrophoneTestRecordingState) {
          statusMessage = state.statusMessage;
          microphones = state.microphones;
          selectedMicrophone = state.selectedMicrophone;
          recognizedWords = state.recognizedWords;
          isRecording = true;
        } else if (state is MicrophoneTestStoppedState) {
          testFailed = state.isTestFailed;
          statusMessage = state.statusMessage;
          microphones = state.microphones;
          selectedMicrophone = state.selectedMicrophone;
          isRecording = false;
        } else if (state is MicrophoneListLoadedState) {
          microphones = state.microphones;
          selectedMicrophone = state.selectedMicrophone;
        } else if (state is MicrophoneTestFailureState) {
          statusMessage = state.statusMessage;
          testFailed = true;
        }

        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.mic,
                        size: 30, color: theme.colorScheme.onTertiary),
                    UIHelpers.horizontalSpaceSmall,
                    Expanded(
                      child: Text(
                        "Test your Microphone",
                        style: CustomTextStyle.normal
                            .copyWith(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpaceSmall,
                Text(
                  "Choose or change Mic preference as per your comfort",
                  style: CustomTextStyle.hint.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w200),
                ),
                UIHelpers.verticalSpaceTinySmall,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.onSurface),
                    color: theme.colorScheme.onPrimary,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMicrophone,
                      onChanged: isRecording
                          ? null
                          : (value) {
                              if (value != null) {
                                context
                                    .read<MicrophoneTestBloc>()
                                    .add(SelectMicrophoneEvent(value));
                              }
                            },
                      items: microphones.isNotEmpty
                          ? microphones
                              .map((mic) => DropdownMenuItem(
                                    value: mic,
                                    child: SizedBox(
                                        width: UIHelpers.screenWidthPercentage(
                                            context,
                                            percentage: 0.17),
                                        child: Text(mic)),
                                  ))
                              .toList()
                          : [
                              const DropdownMenuItem(
                                value: null,
                                child: Text("No Microphones Found"),
                              ),
                            ],
                    ),
                  ),
                ),
                UIHelpers.verticalSpaceTinySmall,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onTertiary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                      state is MicrophoneTestRecordingState
                          ? "Stop"
                          : "Test Microphone",
                      style: CustomTextStyle.hint
                          .copyWith(color: CustomColors.white)),
                ),
                const SizedBox(height: 10),
                if (recognizedWords.isNotEmpty) ...[
                  Text(
                    recognizedWords,
                    style: CustomTextStyle.hint.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
                Text(
                  statusMessage,
                  style: CustomTextStyle.hint.copyWith(
                    color: testFailed ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 15),
                _buildTip(
                    "Use a Quiet Environment",
                    "Avoid background noise for clear voice detection.",
                    context),
                _buildTip(
                    "Speak at a Normal Volume",
                    "Ensure your voice is neither too loud nor too soft.",
                    context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTip(String title, String description, context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: theme.colorScheme.primaryFixedDim, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: CustomTextStyle.hint
                    .copyWith(color: theme.colorScheme.onSurface),
                children: [
                  TextSpan(
                      text: "$title:\n",
                      style: CustomTextStyle.small
                          .copyWith(color: theme.colorScheme.onSurface)),
                  TextSpan(
                    text: description,
                    style: CustomTextStyle.small.copyWith(
                      color: CustomColors.gray.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

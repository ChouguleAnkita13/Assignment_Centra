import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/speaker_testing_bloc/speaker_testing_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/speaker_testing_bloc/speaker_testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/speaker_testing_bloc/speaker_testing_state.dart';
import 'package:webrtc/util/theme/colors.dart';
import 'package:webrtc/util/theme/text_styles.dart';
import 'package:webrtc/util/ui_helpers.dart';

class SpeakerTestingView extends StatelessWidget {
  const SpeakerTestingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => SpeakerBloc()..add(LoadMicrophonesEvent()),
      child: BlocBuilder<SpeakerBloc, SpeakerState>(builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.speaker,
                        size: 30, color: theme.colorScheme.onTertiary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Test your Speaker",
                        style: CustomTextStyle.normal
                            .copyWith(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Choose or change speaker preference as per your comfort",
                  style: CustomTextStyle.hint.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.onSurface),
                    color: theme.colorScheme.onPrimary,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: state.selectedMicrophone.isEmpty
                          ? null
                          : state.selectedMicrophone,
                      onChanged: state.isListening
                          ? null
                          : (value) {
                              if (value != null) {
                                context
                                    .read<SpeakerBloc>()
                                    .add(SelectMicrophoneEvent(value));
                              }
                            },
                      items: state.availableMicrophones.isNotEmpty
                          ? state.availableMicrophones
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
                const SizedBox(height: 15),

                /// Test Speaker Button
                ElevatedButton(
                  onPressed: state.isTesting
                      ? null
                      : () => context.read<SpeakerBloc>().add(TestSpeaker()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onTertiary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    state.isTesting ? "Testing..." : "Test Speaker",
                    style: CustomTextStyle.hint
                        .copyWith(color: CustomColors.white),
                  ),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: state.microphonePermissionGranted &&
                          !state.isListening &&
                          state.testCompleted
                      ? () => context.read<SpeakerBloc>().add(StartListening())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onTertiary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    state.isListening ? "Listening..." : "Start Listening",
                    style: CustomTextStyle.hint
                        .copyWith(color: CustomColors.white),
                  ),
                ),
                const SizedBox(height: 10),

                if (!state.microphonePermissionGranted) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "Microphone permission denied. Please enable the permission.",
                          style:
                              CustomTextStyle.hint.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
                if (state.recognizedText.isNotEmpty && !state.testSuccessful)
                  Text(
                    "Recognized: ${state.recognizedText}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                if (state.testSuccessful) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.graphic_eq,
                          color: Colors.green, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "Hello Olivia, all the best for your interview",
                          style: CustomTextStyle.hint
                              .copyWith(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, color: Colors.green, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "Speaker is working accurately",
                          style: CustomTextStyle.hint
                              .copyWith(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],

                if (state.testAttempted &&
                    !state.testSuccessful &&
                    !state.isListening &&
                    state.recognizedText.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "Speaker test failed. Please try again.",
                          style:
                              CustomTextStyle.hint.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 15),
                _buildTip(
                    "Use Clear & Functional Speakers",
                    "Ensure your speakers or external audio device are in good condition.",
                    context),
                _buildTip(
                    "Ensure No Audio Interference",
                    "Close other apps (like music or video players) that may interfere with the sound.",
                    context),
                // const Spacer(),
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
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/camera_testing_bloc/camera_testing_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/camera_testing_bloc/camera_testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/camera_testing_bloc/camera_testing_state.dart';
import 'package:webrtc/util/common_widgets/custom_button.dart';
import 'package:webrtc/util/theme/colors.dart';
import 'package:webrtc/util/theme/text_styles.dart';
import 'package:webrtc/util/ui_helpers.dart';

class CameraTestScreen extends StatelessWidget {
  final int selectedTabIndex;
  const CameraTestScreen({super.key, required, required this.selectedTabIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: BlocBuilder<CameraBloc, CameraState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: UIHelpers.screenHeightPercentage(context, percentage: 1),
                height:
                    UIHelpers.screenHeightPercentage(context, percentage: 0.5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: state is CameraSuccess
                    ? RTCVideoView(
                        state.renderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      )
                    : Center(
                        child: Text(
                          "No Camera Preview",
                          style: CustomTextStyle.hint
                              .copyWith(color: theme.colorScheme.onSurface),
                        ),
                      ),
              ),
              UIHelpers.verticalSpaceMedium,
              selectedTabIndex == 0
                  ? Column(
                      children: [
                        Text(
                          state is CameraLoading
                              ? "📷 Camera Initializing..."
                              : state is CameraSuccess
                                  ? "✅ Camera Test Successful!"
                                  : state is CameraFailure
                                      ? "❌ Camera Test Failed!"
                                      : "Click Start to test the camera",
                          style: CustomTextStyle.hint.copyWith(
                            color: state is CameraSuccess
                                ? Colors.green
                                : (state is CameraLoading
                                    ? Colors.orange
                                    : Colors.red),
                          ),
                        ),
                        UIHelpers.verticalSpaceMedium,
                        GestureDetector(
                          onTap:
                              state is CameraLoading || state is CameraSuccess
                                  ? null
                                  : () {
                                      BlocProvider.of<CameraBloc>(context)
                                          .add(InitializeCamera());
                                    },
                          child: CustomButton(
                              bgColor: theme.colorScheme.onTertiary,
                              textColor: CustomColors.white,
                              text: "Start Camera Test"),
                        )
                      ],
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}

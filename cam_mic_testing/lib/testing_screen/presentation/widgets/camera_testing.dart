import 'package:flutter/material.dart';
import 'package:webrtc/util/theme/colors.dart';
import 'package:webrtc/util/theme/text_styles.dart';
import 'package:webrtc/util/ui_helpers.dart';

class CameraTestingView extends StatelessWidget {
  const CameraTestingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: UIHelpers.screenWidthPercentage(context, percentage: 3),
      height: UIHelpers.screenHeightPercentage(context, percentage: 0.57),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.videocam_outlined,
                size: 40,
                color: theme.colorScheme.onTertiary,
              ),
              Text(
                "Test Your Camera",
                style: CustomTextStyle.normal
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
          UIHelpers.verticalSpaceRegular,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/camera1.png', width: 100, height: 100),
              UIHelpers.horizontalSpaceRegular,
              Image.asset('assets/images/camera2.png', width: 100, height: 100),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Use a Well-Lit Environment",
                style: CustomTextStyle.small
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              Text(
                "Sit in a well-lit room; avoid strong backlight",
                style: CustomTextStyle.small.copyWith(
                  color: CustomColors.gray.shade700,
                ),
              ),
            ],
          ),
          UIHelpers.verticalSpaceMedium,
          Row(
            children: [
              Image.asset('assets/images/camera3.png', width: 100, height: 100),
              UIHelpers.horizontalSpaceRegular,
              Image.asset('assets/images/camera4.png', width: 100, height: 100),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Position the Camera at Eye Level:",
                style: CustomTextStyle.small
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              Text(
                "Keep your camera at a natural angle for a professional look",
                style: CustomTextStyle.small.copyWith(
                  color: CustomColors.gray.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

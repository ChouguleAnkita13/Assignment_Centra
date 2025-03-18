import 'package:flutter/material.dart';
import 'package:webrtc/modules/testing_screen/presentation/view/testing_screen_desktop_view.dart';
import 'package:webrtc/modules/testing_screen/presentation/view/testing_screen_mobile_view.dart';
import 'package:webrtc/responsive.dart';

class TestingScreen extends StatelessWidget {
  const TestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
          mobile: TestingScreenMobileView(),
          tablet: TestingScreenDesktopView(),
          desktop: TestingScreenDesktopView()),
    );
  }
}

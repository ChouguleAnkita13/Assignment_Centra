import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/camera_testing_bloc/camera_testing_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/testing_bloc/testing_bloc.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/testing_bloc/testing_event.dart';
import 'package:webrtc/modules/testing_screen/presentation/bloc/testing_bloc/testing_state.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/camera_testing.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/camera_testing_widget.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/microphone_testing_view.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/speaker_testing_view.dart';
import 'package:webrtc/util/common_widgets/control_guide.dart';
import 'package:webrtc/util/common_widgets/custom_appbar/appbar.dart';
import 'package:webrtc/util/test_session_data.dart';
import 'package:webrtc/util/theme/colors.dart';
import 'package:webrtc/util/theme/text_styles.dart';
import 'package:webrtc/util/ui_helpers.dart';

class TestingScreenDesktopView extends StatefulWidget {
  const TestingScreenDesktopView({super.key});

  @override
  TestingScreenDesktopViewState createState() =>
      TestingScreenDesktopViewState();
}

class TestingScreenDesktopViewState extends State<TestingScreenDesktopView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => TestingScreenBloc(),
      child: BlocListener<TestingScreenBloc, TestingScreenState>(
        listener: (context, state) {
          _tabController.animateTo(state.selectedTabIndex);
        },
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: CustomAppBar.customAppBar(context, 30),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildTabSection(screenWidth),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("To move on to the interview, finish the three steps.",
            style: CustomTextStyle.normal
                .copyWith(color: theme.colorScheme.onSurface)),
        InkWell(
          onTap: () async {
            try {
              await launchUrl(
                Uri.parse("https://centralogic.net/contact-us/"),
                mode: LaunchMode.externalApplication,
              );
            } catch (e) {}
          },
          child: Text(
            'Help & Support',
            style: CustomTextStyle.normal1.copyWith(
              color: CustomColors.bluePrimary.shade600,
              decoration: TextDecoration.underline,
              decorationColor: CustomColors.bluePrimary.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection(double screenWidth) {
    return BlocBuilder<TestingScreenBloc, TestingScreenState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildTabBar(context, state.selectedTabIndex, screenWidth),
            const SizedBox(height: 10),
            _buildContent(screenWidth, state.selectedTabIndex),
          ],
        );
      },
    );
  }

  Widget _buildTabBar(
      BuildContext context, int selectedIndex, double screenWidth) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      width: screenWidth * 0.94,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBar(
          controller: _tabController,
          tabs: [
            _buildCustomTab('Camera Testing', 0, selectedIndex),
            _buildCustomTab('Microphone Testing', 1, selectedIndex),
            _buildCustomTab('Speaker Testing', 2, selectedIndex),
          ],
          labelColor: theme.colorScheme.onSurface,
          unselectedLabelColor: theme.colorScheme.onSurface,
          indicatorColor: Colors.transparent,
          dividerHeight: 0,
          isScrollable: false,
        ),
      ),
    );
  }

  Widget _buildCustomTab(String text, int index, int selectedIndex) {
    final theme = Theme.of(context);
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(
            color: selectedIndex == index
                ? theme.colorScheme.onTertiary
                : Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        text,
        style:
            CustomTextStyle.small.copyWith(color: theme.colorScheme.onSurface),
      )),
    );
  }

  Widget _buildContent(double screenWidth, int selectedTabIndex) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTestingPanel(screenWidth, selectedTabIndex),
          UIHelpers.horizontalSpaceRegular,
          Expanded(
            child: BlocProvider(
              create: (context) => CameraBloc(),
              child: CameraTestScreen(selectedTabIndex: selectedTabIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingPanel(double screenWidth, int selectedTabIndex) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(66, 248, 245, 245),
              blurRadius: 1,
              offset: Offset(1, 1)),
        ],
      ),
      height: 500,
      width: screenWidth * 0.3,
      child: IndexedStack(
        index: selectedTabIndex,
        children: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [CameraTestingView(), CustomTextButton()]),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child:
                Column(children: [MicrophoneTestingView(), CustomTextButton()]),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [SpeakerTestingView(), CustomTextButton()]),
          ),
        ],
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          final bloc = context.read<TestingScreenBloc>();
          bloc.add(TabCompleted(bloc.state.selectedTabIndex));

          if (bloc.state.selectedTabIndex == 0 &&
              TestSessionData.isCameraTest) {
            bloc.add(TabChanged((bloc.state.selectedTabIndex + 1) % 3));
          } else if (bloc.state.selectedTabIndex == 1 &&
              TestSessionData.isMicTest) {
            bloc.add(TabChanged((bloc.state.selectedTabIndex + 1) % 3));
          } else if (bloc.state.selectedTabIndex == 2 &&
              TestSessionData.isSpeakerTest &&
              TestSessionData.isMicTest &&
              TestSessionData.isCameraTest) {
            ControlGuide.controlGuideDialog(context);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Continue",
                style: CustomTextStyle.small.copyWith(
                    color: CustomColors.bluePrimary.shade600,
                    fontWeight: FontWeight.w500)),
            Icon(Icons.arrow_forward, color: CustomColors.bluePrimary.shade600),
          ],
        ),
      ),
    );
  }
}

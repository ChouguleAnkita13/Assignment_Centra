import 'package:flutter/material.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/camera_testing.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/microphone_testing_view.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/speaker_testing_view.dart';
import 'package:webrtc/util/theme/text_styles.dart';

class TestingScreenMobileView extends StatefulWidget {
  const TestingScreenMobileView({super.key});

  @override
  _TestingScreenMobileViewState createState() =>
      _TestingScreenMobileViewState();
}

class _TestingScreenMobileViewState extends State<TestingScreenMobileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'InterviewAgent',
          style: CustomTextStyle.subheadingH5,
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To move on to the interview, finish the three steps.",
                style: CustomTextStyle.subheadingH7,
              ),
              const SizedBox(height: 15),
              TabBar(
                controller: _tabController,
                tabs: [
                  _buildCustomTab('Camera Testing', Icons.camera_alt),
                  _buildCustomTab('Microphone Testing', Icons.mic),
                  _buildCustomTab('Speaker Testing', Icons.volume_up),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTestingView(const CameraTestingView()),
                    _buildTestingView(const MicrophoneTestingView()),
                    _buildTestingView(const SpeakerTestingView()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTab(String text, IconData icon) {
    return Tab(
      icon: Icon(icon),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildTestingView(Widget testingWidget) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(child: testingWidget),
        ],
      ),
    );
  }
}

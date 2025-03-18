import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webrtc/modules/join_meet_screen/presentation/pages/join_meet_screen.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/camera_testing.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/microphone_testing_view.dart';
import 'package:webrtc/modules/testing_screen/presentation/widgets/speaker_testing_view.dart';
import 'package:webrtc/util/theme/text_styles.dart';
import 'package:webrtc/util/ui_helpers.dart';

class TestingScreenView extends StatefulWidget {
  const TestingScreenView({super.key});

  @override
  _TestingScreenViewState createState() => _TestingScreenViewState();
}

class _TestingScreenViewState extends State<TestingScreenView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'InterviewAgent',
          style: CustomTextStyle.subheadingH5,
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Container(
            width: screenWidth * 0.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To move on to the interview, finish the three steps.",
                      style: CustomTextStyle.subheadingH7,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          final launched = await launchUrl(
                            Uri.parse("https://centralogic.net/contact-us/"),
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {}
                      },
                      child: const Text(
                        'Help & Support',
                        style: TextStyle(
                          color: Color(0xFF4C55D7),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF4C55D7),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                DefaultTabController(
                  length: 3,
                  initialIndex: _selectedTabIndex,
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      child: Column(
                        children: [
                          Container(
                            alignment: const Alignment(0.1, 0.1),
                            width: screenWidth * 0.94,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 1,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TabBar(
                                tabAlignment: TabAlignment.center,
                                onTap: (index) {
                                  setState(() {
                                    _selectedTabIndex = index;
                                  });
                                },
                                tabs: [
                                  _buildCustomTab('Camera Testing', 0),
                                  _buildCustomTab('Microphone Testing', 1),
                                  _buildCustomTab('Speaker Testing', 2),
                                ],
                                labelColor: Colors.black,
                                dividerHeight: 0,
                                unselectedLabelColor: Colors.black,
                                indicatorColor: Colors.transparent,
                                isScrollable: false,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.black12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(66, 248, 245, 245),
                                        blurRadius: 1,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  height: 500,
                                  width: screenWidth * 0.3,
                                  child: const TabBarView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            CameraTestingView(),
                                            text_button()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            MicrophoneTestingView(),
                                            text_button()
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            SpeakerTestingView(),
                                            text_button()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                UIHelpers.horizontalSpaceRegular,
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.white),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 1,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    height: 500,
                                    child: const Column(
                                      children: [],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTab(String text, int index) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedTabIndex == index ? Colors.black : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
    );
  }
}

class text_button extends StatelessWidget {
  const text_button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onHover: (value) {
          false;
        },
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return const JoinMeetScreen();
            },
          ));
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Continue",
              style: TextStyle(color: Color(0xFF4C55D7)),
            ),
            Icon(
              Icons.arrow_forward,
              color: Color(0xFF4C55D7),
            )
          ],
        ));
  }
}

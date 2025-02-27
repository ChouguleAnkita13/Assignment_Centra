import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MicrophoneTestPage(),
    );
  }
}

class MicrophoneTestPage extends StatefulWidget {
  const MicrophoneTestPage({super.key});

  @override
  State<MicrophoneTestPage> createState() => _MicrophoneTestPageState();
}

class _MicrophoneTestPageState extends State<MicrophoneTestPage> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  double currentDecibels = 0.0;
  String statusMessage = '';
  bool testFailed = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder!.openRecorder();
  }

  void _startRecording() async {
    try {
      setState(() {
        _isRecording = true;
        currentDecibels = 0.0;
        statusMessage = 'Recording...';
        testFailed = false;
      });

      await _recorder!.startRecorder(
        toFile: 'test.aac', // Changed to AAC for compatibility
        codec: Codec.aacMP4, // More compatible codec
      );

      _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));

      _recorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          setState(() {
            currentDecibels = event.decibels!;
          });
        }
      });

      // Check for microphone input after 5 seconds to determine success
      Future.delayed(Duration(seconds: 5), () {
        if (currentDecibels <= 0.0) {
          // If no sound is detected within 5 seconds, mark the test as failed
          setState(() {
            testFailed = true;
            statusMessage = 'Microphone Test Failed: No sound detected.';
          });
        } else if (!_isRecording) {
          setState(() {
            statusMessage = 'Test Successful!';
          });
        }
      });
    } catch (e) {
      setState(() {
        testFailed = true;
        statusMessage = 'Error: $e';
      });
    }
  }

  void _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    // If recording was successful, display the success message
    if (!testFailed && currentDecibels > 0.0) {
      setState(() {
        statusMessage = 'Test Successful!';
      });
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Microphone Test")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Current Decibels: ${currentDecibels.toStringAsFixed(2)} dB",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // LinearProgressIndicator showing the waveform
          SizedBox(
            width: 300,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(100),
              value: currentDecibels > 0
                  ? currentDecibels / 100
                  : 0, // Normalized decibels to 0-1 range
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 10, // Height of the progress indicator
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            child: Text(_isRecording ? "Stop" : "Start"),
          ),
          SizedBox(height: 20),
          Text(
            statusMessage,
            style: TextStyle(
                fontSize: 18, color: testFailed ? Colors.red : Colors.green),
          ),
        ],
      ),
    );
  }
}

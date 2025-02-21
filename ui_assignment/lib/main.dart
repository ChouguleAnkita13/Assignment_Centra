import 'package:flutter/material.dart';
import 'package:ui_assignment/modules/job_details/presentation/pages/job_details_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: JobDetailsPage());
  }
}

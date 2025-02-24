import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/desktop/job_details_desktop.dart';
import 'package:ui_assignment/modules/job_application/presentation/view/mobileview/job_details_mobile.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraint) {
      final width = contraint.minWidth;

      ///1536
      log(width.toString());
      return width < 1200 ? JobDetailsMobile() : JobDetailsDesktop();
    });
  }
}

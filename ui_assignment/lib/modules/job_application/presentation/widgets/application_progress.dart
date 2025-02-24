import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ApplicationProgress extends StatelessWidget {
  const ApplicationProgress({
    super.key,
    required this.pageNo,
    required this.pageName,
  });
  final int pageNo;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          // animation: true,
          lineWidth: 8.0,
          percent: 0.25 * pageNo,
          center: Text(
            "$pageNo",
            style: GoogleFonts.inter(
                color: Color.fromRGBO(1, 60, 110, 1),
                fontSize: 32,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: Color.fromRGBO(203, 229, 251, 1),
          progressColor: Color.fromRGBO(1, 60, 110, 1),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            pageName,
            style: GoogleFonts.inter(
                color: Color.fromRGBO(64, 64, 64, 1),
                fontSize: 28,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

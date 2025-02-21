import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.img, required this.title});
  final String img;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
              color: Color.fromRGBO(203, 229, 251, 1),
              borderRadius: BorderRadius.circular(5)),
          child: Image.asset(img),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
              color: Color.fromRGBO(64, 64, 64, 1),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

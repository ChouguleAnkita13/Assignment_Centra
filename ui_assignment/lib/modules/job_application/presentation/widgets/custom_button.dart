import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color.fromRGBO(1, 60, 110, 1),
          borderRadius: BorderRadius.circular(100)),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

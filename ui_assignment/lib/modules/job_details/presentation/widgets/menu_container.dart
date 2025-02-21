import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({
    super.key,
    required this.text,
    required this.isSelected,
  });
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      alignment: isSelected ? Alignment.center : Alignment.centerLeft,
      decoration: isSelected
          ? BoxDecoration(
              color: Color.fromRGBO(203, 229, 251, 1),
              border: Border.all(color: Color.fromRGBO(1, 60, 110, 1)),
              borderRadius: BorderRadius.circular(5))
          : BoxDecoration(),
      child: Text(
        text,
        style: GoogleFonts.poppins(
            color: isSelected
                ? Color.fromRGBO(1, 60, 110, 1)
                : Color.fromRGBO(64, 64, 64, 1),
            fontSize: 16,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}

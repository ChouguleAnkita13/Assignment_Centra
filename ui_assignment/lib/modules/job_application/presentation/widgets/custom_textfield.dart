import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
              color: Color.fromRGBO(64, 64, 64, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            cursorColor: Color.fromRGBO(157, 156, 156, 1),
            decoration: InputDecoration(
                fillColor: Color.fromRGBO(203, 229, 251, 1),
                filled: true,
                hintText: title.contains("1")
                    ? "Insert"
                    : "Insert ${title.toLowerCase()}",
                hintStyle: GoogleFonts.inter(
                    color: Color.fromRGBO(157, 156, 156, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(232, 232, 232, 1))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(232, 232, 232, 1)))),
          ),
        ),
      ],
    );
  }
}

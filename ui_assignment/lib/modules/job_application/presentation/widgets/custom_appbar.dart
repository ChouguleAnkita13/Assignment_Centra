import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbar {
  static PreferredSizeWidget customAppbar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios)),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      surfaceTintColor: Color.fromRGBO(255, 255, 255, 1),
      title: Text(
        "UI Designer, Application",
        style: GoogleFonts.inter(
            color: Color.fromRGBO(64, 64, 64, 1),
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

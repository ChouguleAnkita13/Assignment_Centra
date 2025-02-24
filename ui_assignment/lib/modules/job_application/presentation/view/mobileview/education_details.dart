import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/application_progress.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_appbar.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_button.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_textfield.dart';

class EducationDetails extends StatelessWidget {
  const EducationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppbar.customAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ApplicationProgress(pageNo: 2, pageName: "Educational Details"),
            SizedBox(height: 10),
            _highestEduDropdown(context),
            _showAllStages(context),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                context.push("/tech-skills");
              },
              child: CustomButton(title: "Next"),
            ),
          ],
        ),
      ),
    );
  }
}

///HIGHEST QUALIFICATION
Widget _highestEduDropdown(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Highest Qualification",
        style: GoogleFonts.inter(
            color: Color.fromRGBO(64, 64, 64, 1),
            fontSize: 14,
            fontWeight: FontWeight.w400),
      ),
      SizedBox(
        height: 3,
      ),
      Container(
        height: 49,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(203, 229, 251, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: "Select",
            padding: const EdgeInsets.symmetric(horizontal: 12),
            dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
            icon: const Icon(Icons.arrow_drop_down_outlined,
                size: 35, color: Color.fromRGBO(101, 101, 101, 1)),
            isExpanded: true,
            onChanged: (String? newValue) {},
            items: [
              "Select",
              "Graduation",
              "Post Graduation",
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(157, 156, 156, 1),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

///ALL STAGES
Widget _showAllStages(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height / 2.5,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Insert marks obtained at each stage",
          style: GoogleFonts.inter(
              color: Color.fromRGBO(64, 64, 64, 1),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 150, child: CustomTextfield(title: "10 th Standard")),
            _radioButton()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 150, child: CustomTextfield(title: "12 th Standard")),
            _radioButton()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 150, child: CustomTextfield(title: "Graduation")),
            _radioButton()
          ],
        ),
      ],
    ),
  );
}

///RADIO BUTTONS
Widget _radioButton() {
  return Row(
    children: [
      Radio<String>(
        value: "Percentage",
        groupValue: "Percentage",
        activeColor: const Color.fromRGBO(1, 60, 110, 1),
        onChanged: (value) {},
      ),
      Text(
        "Percentage",
        style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color.fromRGBO(94, 94, 94, 1)),
      ),
      SizedBox(
        width: 10,
      ),
      Radio<String>(
        value: "CGPA",
        groupValue: "Percentage",
        activeColor: const Color.fromARGB(1, 60, 110, 1),
        onChanged: (value) {},
      ),
      Text(
        "CGPA",
        style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color.fromRGBO(94, 94, 94, 1)),
      ),
    ],
  );
}

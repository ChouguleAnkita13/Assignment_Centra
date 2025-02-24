import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/application_progress.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_appbar.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_button.dart';

class TechnicalSkills extends StatelessWidget {
  const TechnicalSkills({super.key});

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
            ApplicationProgress(pageNo: 3, pageName: "Technical Skills"),
            SizedBox(height: 10),
            _requiredSkills(context),
            _additionalSkills(),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                context.push("/upload-resume");
              },
              child: CustomButton(title: "Next"),
            ),
          ],
        ),
      ),
    );
  }
}

///REQUIRED SKILLS
Widget _requiredSkills(BuildContext context) {
  List skillList = [
    "Figma Tool",
    "HTML, CSS",
    "Adobe XD",
    "Typography",
    "Ilustrator",
    "Design System"
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Required Skills",
        style: GoogleFonts.inter(
            color: Color.fromRGBO(64, 64, 64, 1),
            fontSize: 16,
            fontWeight: FontWeight.w400),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color.fromRGBO(232, 232, 232, 1))),
        child: Wrap(
          spacing: 20,
          runSpacing: 15,
          children: List.generate(skillList.length,
              (index) => _skillContainer(skillList[index], index)),
        ),
      )
    ],
  );
}

///SINGLE SKILL CONTAINER
Widget _skillContainer(String skill, int index) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color:
              index % 2 != 1 ? Colors.white : Color.fromRGBO(203, 229, 251, 1),
          border: Border.all(color: Color.fromRGBO(1, 60, 110, 1))),
      child: Text(
        skill,
        style: GoogleFonts.ubuntu(
            color: Color.fromRGBO(1, 60, 110, 1),
            fontSize: 14,
            fontWeight: FontWeight.w400),
      ));
}

///ADDITIONAL SKILLS
Widget _additionalSkills() {
  return SizedBox(
    height: 140,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Additional Skills",
          style: GoogleFonts.inter(
              color: Color.fromRGBO(64, 64, 64, 1),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 320, child: _textfield()),
            _addSkillsContainer(true)
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 280, child: _textfield()),
            _addSkillsContainer(false)
          ],
        ),
      ],
    ),
  );
}

///ADD ICON CONTAINER WHICH IS BESIDE THE ADDITIONAL SKILLS TEXTFIELD
Widget _addSkillsContainer(bool isAdd) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Color.fromRGBO(203, 229, 251, 1),
    ),
    child: Row(
      children: [
        Icon(Icons.add, color: Color.fromRGBO(1, 60, 110, 1)),
        !isAdd ? SizedBox(width: 10) : SizedBox(),
        !isAdd
            ? Icon(Icons.delete_outline_outlined,
                color: Color.fromRGBO(1, 60, 110, 1))
            : SizedBox()
      ],
    ),
  );
}

///ADD SKILLS TEXTFIELD
Widget _textfield() {
  return SizedBox(
    height: 40,
    child: TextFormField(
      cursorColor: Color.fromRGBO(157, 156, 156, 1),
      decoration: InputDecoration(
          fillColor: Color.fromRGBO(203, 229, 251, 1),
          filled: true,
          hintText: "Insert",
          hintStyle: GoogleFonts.inter(
              color: Color.fromRGBO(157, 156, 156, 1),
              fontSize: 16,
              fontWeight: FontWeight.w400),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color.fromRGBO(232, 232, 232, 1))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color.fromRGBO(232, 232, 232, 1)))),
    ),
  );
}

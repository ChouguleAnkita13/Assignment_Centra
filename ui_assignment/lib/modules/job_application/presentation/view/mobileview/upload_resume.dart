import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/application_progress.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_appbar.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadResume extends StatelessWidget {
  const UploadResume({super.key});

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
            ApplicationProgress(pageNo: 4, pageName: "Upload Resume"),
            SizedBox(height: 10),
            _chooseFileContainer(context),
            _uploadedFileContainer(true),
            _uploadedFileContainer(false),
            _uploadedFileContainer(true),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => _dialogBox(context));
              },
              child: CustomButton(title: "Apply"),
            ),
          ],
        ),
      ),
    );
  }
}

///CHOOSE FILE CONTAINER
Widget _chooseFileContainer(BuildContext context) {
  return Column(
    children: [
      DottedBorder(
        color: Color.fromRGBO(1, 60, 110, 1),
        radius: Radius.circular(8),
        dashPattern: [15, 8],
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              color: Color.fromRGBO(203, 229, 251, 1),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.plagiarism_outlined,
                  size: 160, color: Color.fromRGBO(1, 60, 110, 1)),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Drop your files here or ",
                  style: GoogleFonts.ubuntu(
                      color: Color.fromRGBO(64, 64, 64, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
                TextSpan(
                  text: "choose file",
                  style: GoogleFonts.ubuntu(
                      decoration: TextDecoration.underline,
                      color: Color.fromRGBO(64, 64, 64, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )
              ]))
            ],
          ),
        ),
      ),
      SizedBox(height: 5),
      _fileConfig()
    ],
  );
}

///FILE CONFIGRATION
Widget _fileConfig() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Files supported : Pdf.",
        style: GoogleFonts.ubuntu(
            color: Color.fromRGBO(125, 131, 148, 1),
            fontSize: 14,
            fontWeight: FontWeight.w300),
      ),
      Text(
        "Max. Size : 150 MB",
        style: GoogleFonts.ubuntu(
            color: Color.fromRGBO(125, 131, 148, 1),
            fontSize: 14,
            fontWeight: FontWeight.w300),
      ),
    ],
  );
}

///DIALOG BOX
Widget _dialogBox(BuildContext context) {
  return AlertDialog(
    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
    icon: CircleAvatar(
      radius: 35,
      backgroundColor: Color.fromRGBO(203, 229, 251, 1),
      child: Icon(Icons.check, color: Color.fromRGBO(1, 60, 110, 1), size: 50),
    ),
    title: Text(
      "Congratulations!",
      style: GoogleFonts.mulish(
          color: Color.fromRGBO(50, 63, 75, 1),
          fontSize: 20,
          fontWeight: FontWeight.w700),
    ),
    content: Text(
      "You have successfully applied for the post of UI Designer at CentraLogic.",
      textAlign: TextAlign.center,
      style: GoogleFonts.mulish(
          color: Color.fromRGBO(64, 64, 64, 1),
          fontSize: 16,
          fontWeight: FontWeight.w600),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
    actions: [
      GestureDetector(
          onTap: () {
            context.go("/job-details-mobile");
          },
          child: CustomButton(title: "Okay"))
    ],
  );
}

///UPLOADED FILE CONTAINER
Widget _uploadedFileContainer(bool isUploaded) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Color.fromRGBO(125, 131, 148, 0.5),
      ),
    ),
    child: ListTile(
      leading: Icon(
        Icons.picture_as_pdf_outlined,
        size: 30,
        color: Color.fromRGBO(1, 60, 110, 1),
      ),
      title: Text(
        "File name.pdf",
        style: GoogleFonts.ubuntu(
            color: Color.fromRGBO(125, 131, 148, 1),
            fontSize: 16,
            fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        isUploaded ? "32 MB" : "Failed to upload",
        style: GoogleFonts.ubuntu(
            color: isUploaded ? Color.fromRGBO(125, 131, 148, 1) : Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.w400),
      ),
      trailing: Icon(
        isUploaded ? Icons.delete_outline_rounded : Icons.restart_alt,
        size: 30,
        color: Color.fromRGBO(1, 60, 110, 1),
      ),
    ),
  );
}

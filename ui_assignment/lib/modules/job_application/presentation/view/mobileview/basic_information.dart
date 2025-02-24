import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/application_progress.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_appbar.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_button.dart';
import 'package:ui_assignment/modules/job_application/presentation/widgets/custom_textfield.dart';

class BasicInformation extends StatelessWidget {
  const BasicInformation({super.key});

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
            ApplicationProgress(pageNo: 1, pageName: "Basic Information"),
            SizedBox(height: 10),
            CustomTextfield(title: "First Name"),
            CustomTextfield(title: "Last Name"),
            CustomTextfield(title: "Mobile Number"),
            CustomTextfield(title: "Email-id"),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                context.pushNamed("edu-details");
              },
              child: CustomButton(title: "Next"),
            ),
          ],
        ),
      ),
    );
  }
}

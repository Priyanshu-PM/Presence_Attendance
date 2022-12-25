import 'package:flutter/material.dart';
import 'register_page.dart';
import 'widgets/custom_checkbox.dart';
import 'widgets/primary_button_main.dart';
import 'widgets/continue_institute_button.dart';
import 'widgets/continue_faculty_button.dart';
import 'widgets/continue_student_button.dart';
import 'theme.dart';
import 'package:firebase_core/firebase_core.dart';

class Selection_page extends StatefulWidget {
  const Selection_page({Key? key}) : super(key: key);

  @override
  _Selection_page createState() => _Selection_page();
}

class _Selection_page extends State<Selection_page> {
  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 36,
                  ),
                   new Image.asset(
                    'assets/images/student.png',
                    width: 300,
                    height: 100,
                  ),
                  new CustomStudentButton(
                    buttonColor: primaryBlue,
                    textValue: 'Continue as a Student',
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  new Image.asset(
                    'assets/images/teacher.png',
                    width: 300,
                    height: 100,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  CustomFacultyButton(
                    buttonColor: primaryBlue,
                    textValue: 'Continue as a Faculty',
                    textColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  new Image.asset(
                    'assets/images/institute.png',
                    width: 300,
                    height: 100,
                  ),
                  CustomInstituteButton(
                    buttonColor: primaryBlue,
                  textValue: 'Continue as a Institute',
                    textColor: Colors.white,
                ),
                  
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ));
    ;
  }
}

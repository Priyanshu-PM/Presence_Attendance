import 'package:flutter/material.dart';
import 'package:presence/register_page.dart';
import 'package:presence/widgets/custom_checkbox.dart';
import 'package:presence/widgets/primary_button_main.dart';
import 'theme.dart';
import 'package:presence/widgets/forget_log_fact.dart';

class LoginPage4 extends StatefulWidget {
  @override
  _LoginPage4State createState() => _LoginPage4State();
}

class _LoginPage4State extends State<LoginPage4> {
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 37,
                  ),
                  new Image.asset(
                    'assets/images/name.png',
                    width: 300,
                    height: 100,
                  ),
                  SizedBox(
                    height: 37,
                  ),
                  Text(
                    'Verification mail sent',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 999,
                    height: 4,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                    'Your password reset link has been sent to your email. Click on the provided link to reset the password',
                    style: heading2.copyWith(color: textBlack),
                  ),
              SizedBox(
                height: 34,
              ),
              new CustomStudentButton(
                buttonColor: primaryBlue,
                textValue: 'Return to login page',
                textColor: Colors.white,
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

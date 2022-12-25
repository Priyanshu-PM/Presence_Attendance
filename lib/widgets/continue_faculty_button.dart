import 'package:flutter/material.dart';
import 'package:presence/Faculty_login.dart';
import 'package:presence/theme.dart';

class CustomFacultyButton extends StatelessWidget {
  final Color buttonColor;
  final String textValue;
  final Color textColor;

  // ignore: use_key_in_widget_constructors
  const CustomFacultyButton({required this.buttonColor, required this.textValue, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14.0),
      elevation: 0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Faculty_login()));
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                textValue,
                style: heading5.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

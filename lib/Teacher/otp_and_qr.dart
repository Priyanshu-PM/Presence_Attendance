// import 'dart:html';

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:presence/Institute/faculty_list.dart';
import 'package:presence/Student/qrscanner.dart';
import 'package:presence/Teacher/qrgenerator.dart';
import 'package:presence/theme.dart';
import "package:presence/Teacher/Functions_teacher.dart";
import '../register/ins_add_courses.dart';
import 'package:flutter/material.dart';

class listcart extends StatefulWidget {
  const listcart({
    Key? key,
  }) : super(key: key);
  @override
  State<listcart> createState() => _listcartState();
}

// ignore: prefer_typing_uninitialized_variables
class _listcartState extends State<listcart> {
  @override
  Widget build(BuildContext context) {
    String groupValue = teachercourselist[0];
    String temp = "";
    return AlertDialog(
      title: Text("select course"),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
            itemCount: teachercourselist.length,
            itemBuilder: (context, index) {
              return listselectcart(
                  press: () {}, sub: teachercourselist[index]);
            }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
          child: Text("cancel"),
        )
      ],
    );
  }
}

class listselectcart extends StatefulWidget {
  const listselectcart({
    Key? key,
    required this.press,
    required this.sub,
  }) : super(key: key);

  final String sub;
  final VoidCallback press;

  @override
  State<listselectcart> createState() => _listselectcartState();
}

class _listselectcartState extends State<listselectcart> {
  final coursecommentcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Do you want to proceed with " + widget.sub),
                actions: [
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Add description"),
                                content: TextFormField(
                                  controller: coursecommentcontroller,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) =>
                                      coursecommentcontroller.text = value!,
                                  decoration: InputDecoration(
                                    hintText: 'Lecture Comment',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        SchedulerBinding.instance!
                                            .addPostFrameCallback((_) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      qrgenerator(
                                                          Course: widget.sub, desc: "Lecture/Practical",)));
                                        });
                                      },
                                      child: Text("Skip")),
                                  TextButton(
                                      onPressed: () {
                                        SchedulerBinding.instance!
                                            .addPostFrameCallback((_) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      qrgenerator(
                                                          Course: widget.sub, desc: coursecommentcontroller.text.toString(),)));});
                                      },
                                      child: Text("Submit"))
                                ],
                              );
                            });
                      },
                      child: Text("Yes")),
                  TextButton(
                      onPressed: () {
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text("No"))
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/subject1.png'),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

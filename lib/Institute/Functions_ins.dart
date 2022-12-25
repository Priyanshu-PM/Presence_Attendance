// ignore: non_constant_identifier_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/Selection_page.dart';
// ignore: camel_case_types
class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;
   final String document;
  final List<dynamic> courses;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false,
    this.document="",
    required this.courses
  });
}
List<Chat> teacherinfolist = [];
Future<void> get_all_teachers()async {
  teacherinfolist.clear();
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot ds = await FirebaseFirestore.instance.collection("user_institute").doc(user!.uid).get();
  String inscode = ds.get("code");
  QuerySnapshot qs = await FirebaseFirestore.instance.collection("user_teacher").get();
  for(int i = 0;i<qs.size;i++){
    try {
     if(qs.docs[i]["accept"]==true){
        if(qs.docs[i]["inscode"] == inscode){
      teacherinfolist.add(Chat(name: qs.docs[i]["name"], document:qs.docs[i].id.toString(), courses: qs.docs[i]["course_title"],image: "assets/images/teacher.png"));
     }
    }
    print(teacherinfolist);
    } catch (e) {
      print(e);
      continue;
    }
  }
}

List<Chat> studentinfolist = [];
Future<void> get_all_students()async {
  studentinfolist.clear();
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot ds = await FirebaseFirestore.instance.collection("user_institute").doc(user!.uid).get();
  String inscode = ds.get("code");
  QuerySnapshot qs = await FirebaseFirestore.instance.collection("user_student").get();
  for(int i = 0;i<qs.size;i++){
    try {
       if(qs.docs[i]["accept"]==true){
      if(qs.docs[i]["inscode"] == inscode){
      studentinfolist.add(Chat(name: qs.docs[i]["name"], courses: qs.docs[i]["course_title"], document: qs.docs[i].id.toString(),image: "assets/images/student.png"));
    }}
    } catch (e) {
      print(e);
      continue;
    }
  }
}
// ignore: non_constant_identifier_names
String name = '';
String insid = "";
String phone = "";
String dept = "";
String emailins = "";
Future<void> getdetails() async {
  try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("institute").doc(user!.uid).get();
      name = ds.get("name");
      insid = ds.get("code");
      phone = ds.get("contact");
      dept = ds.get("dept");
      emailins = user.email!;
      print("got details");
    } catch (e) {
    }
}
Future<void> checkglobalinternet() async {
  bool hasinternet = await InternetConnectionChecker().hasConnection;
  final text = hasinternet ? "Connected" : "No internet";
   hasinternetglobal = hasinternet;
  final alertcolor = hasinternet ? Colors.green : Colors.red;
  showSimpleNotification(
    Row(children: [
      hasinternet ? Icon(Icons.check_outlined ,color: alertcolor,) :Icon(Icons.cancel_outlined,color: alertcolor,),
      SizedBox(width: 5),
      Text(text,style: TextStyle(color: Colors.black),)
    ]),
    position: NotificationPosition.bottom,
    background: Color.fromRGBO(119, 198, 217, 0.7),
    duration: hasinternet?Duration(seconds: 3 ): Duration(seconds: 3)
  );
}
bool hasinternetglobal = false;
Future<void> checkonlyinternet() async {
  bool hasinternet = await InternetConnectionChecker().hasConnection;
  final text = hasinternet ? "Connected" : "No internet";
  hasinternetglobal = hasinternet;
  final alertcolor = hasinternet ? Colors.green : Colors.red;
  // showSimpleNotification(
  //   Row(children: [
  //     hasinternet ? Icon(Icons.check_outlined ,color: alertcolor,) :Icon(Icons.cancel_outlined,color: alertcolor,),
  //     SizedBox(width: 5),
  //     Text(text,style: TextStyle(color: Colors.black),)
  //   ]),
  //   position: NotificationPosition.bottom,
  //   background: Color.fromRGBO(119, 198, 217, 0.7),
  //   duration: hasinternet?Duration(seconds: 3 ): Duration(seconds: 3)
  // );
}
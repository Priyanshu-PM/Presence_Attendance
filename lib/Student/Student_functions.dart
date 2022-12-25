 // ignore: file_names
 // ignore: file_names
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/Institute/navigationDrawer.dart';

List<dynamic> studentcourselist = [];
  List<int> courseattendlist = [];
  List<int> CourseTotallist =[];
  List<int> Displayval = [];
class Chat_s {
  final String name, lastMessage, stat;
  final bool isActive;
  final int val;

  Chat_s({
    this.name = '',
    this.lastMessage = 'Classes Attended 15/30',
    this.stat = '',
    this.isActive = false,
    required this.val,
  });
}
List<Chat_s> mysubwiseattendlist = [];
String name = '';
String insid = "";
String phone = "";
String email = "";
Future<void> getdetails() async {
  try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection("user_student").doc(user!.uid).get();
      email = user.email!;
      name = ds.get("name");
      insid = ds.get("inscode");
      phone = ds.get("contact");
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
// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/Teacher/teacherhome.dart';

class TeacherDashboardCart {
  final String name, lastMessage, stat;
  final bool isActive;
  final double val;

  TeacherDashboardCart({
    this.name = '',
    this.lastMessage = 'Classes Attended 25/30',
    this.stat = '',
    this.isActive = false,
    required this.val,
  });
}

List<dynamic> teachercourselist = [];
List<int> courseattendlist = [];
List<int> CourseTotallist = [];
List<TeacherDashboardCart> T_DASH_LIST = [];
// Future<bool> FetchAverageAttendanceofstudent()async {
//   T_DASH_LIST.clear();
//   teachercourselist.clear();
//   courseattendlist.clear();
//   CourseTotallist.clear();
//    User? user = FirebaseAuth.instance.currentUser;
//   DocumentSnapshot ds = await FirebaseFirestore.instance.collection("user_teacher").doc(user!.uid).get();
//   String inscode = ds.get("inscode");
//   teachercourselist = ds.get("course_title");
//   List<bool> templist = [];
//   int count = 0;
//   int temp = 0;
//   QuerySnapshot qs = await FirebaseFirestore.instance.collection("institute").get();
//   for(int i = 0;i<qs.size;i++){
//     try {
//       if(qs.docs[i]["code"] == inscode){
//         String docstr = qs.docs[i].id;
//         for(int x = 0;x<teachercourselist.length;x++){
//           QuerySnapshot qs1 = await FirebaseFirestore.instance.collection("institute").doc(docstr).collection(teachercourselist[x]).get();
//           DocumentSnapshot df = await FirebaseFirestore.instance.collection("institute").doc(docstr).collection(teachercourselist[x]).doc("courseinfo").get();

//           for(int n =0;n<qs1.size;n++){
//             count = 0;
//             temp = 0;
//             try {
//               templist = qs1.docs[n]["attend"];

//               for(int c =0;c<templist.length;c++){
//                 if(templist[c] == true){
//                   count = count +1;
//                 }
//               }
//             } catch (e) {
//               print("no data found");
//               count = 0;
//               temp = 0;
//             }
//             temp =  templist.length - 1;
//           }
//           int temp2 = templist.length -1;
//           T_DASH_LIST.add(TeacherDashboardCart(val: (count/temp)*100, name: teachercourselist[x],stat:"$count/$temp2" ));

//         }
//       }
//     } catch (e) {

//     }
//   }
//   print(T_DASH_LIST);
//   return true;
// }

String name = '';
String insid = "";
String phone = "";
String email = "";
Future<void> getdetails() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    email = user.email!;
    name = ds.get("name");
    insid = ds.get("inscode");
    phone = ds.get("contact");
    print("got details");
  } catch (e) {}
}

Future<void> checkglobalinternet() async {
  bool hasinternet = await InternetConnectionChecker().hasConnection;
  final text = hasinternet ? "Connected" : "No internet";
  hasinternetglobal = hasinternet;
  final alertcolor = hasinternet ? Colors.green : Colors.red;
  showSimpleNotification(
      Row(children: [
        hasinternet
            ? Icon(
                Icons.check_outlined,
                color: alertcolor,
              )
            : Icon(
                Icons.cancel_outlined,
                color: alertcolor,
              ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        )
      ]),
      position: NotificationPosition.bottom,
      background: Color.fromRGBO(119, 198, 217, 0.7),
      duration: hasinternet ? Duration(seconds: 3) : Duration(seconds: 3));
}

bool hasinternetglobal = true;
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

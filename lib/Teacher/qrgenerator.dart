import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presence/Teacher/attended_students.dart';
import 'package:presence/Teacher/teacher_dashboard.dart';
import 'package:presence/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qrgenerator extends StatefulWidget {
  // const qrgenerator({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCi8Mt0qh4bpLl_sNFs6ZUW-LCOqm9ryb4',
          appId: '1:267084318059:web:3af05c13deb7bb79f4782e',
          messagingSenderId: '267084318059',
          projectId: 'presence-d332b'));
  final controller = TextEditingController();

  qrgenerator({Key? key, required this.Course,required this.desc}) : super(key: key);
  final String Course;
  final String desc;
  @override
  _qrgenerator createState() => _qrgenerator();
}

class _qrgenerator extends State<qrgenerator> {
  late String code;
  String codestring = "";
  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    code = randomString;
    final qrcodedata = widget.Course + "@" + code;
    return qrcodedata;
  }
  Future<void> generateqr(String codedata) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    String inscode = ds.get("inscode");
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
        for (int i = 0; i < qs.size; i++){
          try {
            if(qs.docs[i]["code"] == inscode){
              DocumentSnapshot subdetails = await FirebaseFirestore.instance.collection("institute").doc(qs.docs[i].id).collection(widget.Course).doc("courseinfo").get();
              QuerySnapshot qstemp = await FirebaseFirestore.instance.collection("institute").doc(qs.docs[i].id).collection(widget.Course).get();
              int length = qstemp.size;
              List<dynamic> stdlist = subdetails.get("student_list");
              List<bool> stdattendlist =new List<bool>.filled(stdlist.length, false);
              await FirebaseFirestore.instance.
                                    collection("institute").doc(qs.docs[i].id).collection(widget.Course).doc()
                                    .set({
                                      'accept':true,
                                      'attend':stdattendlist,
                                      'qrstr': codedata,
                                      'timestp':DateTime.now(),
                                      'total_students':stdlist,
                                      'desc':widget.desc+" ["+length.toString()+"]"
                                });                                                      
            }
          } catch (e) {
          }
        }
      
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codestring = generateRandomString(6);
    generateqr(code);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
            title: Text("Generated QR code for the lecture"),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0),
                  child: Column(
                    children: [
                      QrImage(
                        embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size.square(400), color: Colors.black),
                        // data: generateRandomString(6),
                        data: codestring,
                        version: QrVersions.auto,
                        size: 300.0,
                        padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        widget.Course,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Attendance code",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        codestring,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Future.delayed(Duration.zero, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          attended_stud(subname: widget.Course, qr: code,)));
                            });
                          },
                          child: const Text("Stop Attendance")),
                          SizedBox(height: 30,),
                    ],
                  )),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/Institute/Functions_ins.dart';
import 'package:presence/Institute/institute_dashboard.dart';

// import '../Selection_page.dart';
import '../theme.dart';

// ignore: camel_case_types
class institute extends StatefulWidget {
  const institute({Key? key}) : super(key: key);

  @override
  State<institute> createState() => _instituteState();
}

late String mycode = "not init";

class _instituteState extends State<institute> {
  // void getcode() async{
  //   DocumentSnapshot qs = await FirebaseFirestore.instance.collection("institute").doc(user!.uid).get();
  //   mycode = qs.get("code");
  //   print(qs.get('code').toString());
  // }
  // void donothing(){
  //   getcode();
  // }
  String inscodestr = "institute code ";
Future<void> checkinternet() async {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkinternet();
    getdetails();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    //donothing();
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    //donothing();
    return WillPopScope(
        child: Scaffold(
            body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("inside stream");
              return MyApp(); //Center(
              //   child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const Text("Institute login dashboard"),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(inscodestr),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text(mycode),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Material(
              //           borderRadius: BorderRadius.circular(14.0),
              //           elevation: 0,
              //           child: Container(
              //             height: 56,
              //             decoration: BoxDecoration(
              //               color: Colors.blue,
              //               borderRadius: BorderRadius.circular(14.0),
              //             ),
              //             child: Center(
              //               child: Material(
              //                 color: Colors.transparent,
              //                 child: InkWell(
              //                   onTap: () async {
              //                     try {
              //                       await FirebaseAuth.instance.signOut();
              //                       print("logout successful");
              //                       //SchedulerBinding.instance!.addPostFrameCallback((_) {
              //                       Future.delayed(Duration.zero, () {
              //                         Navigator.popUntil(
              //                             context,
              //                             ModalRoute.withName(Navigator.defaultRouteName));
              //                       });

              //                       // });
              //                     } on FirebaseAuthException catch (exp) {
              //                       // ignore: avoid_print
              //                       print("error... Invalid login $exp");
              //                       // ignore: avoid_print
              //                       print("email entered = ");
              //                     } catch (exp) {
              //                       // ignore: avoid_print
              //                       print("error- $exp");
              //                     }
              //                   },
              //                   borderRadius: BorderRadius.circular(14.0),
              //                   child: Center(
              //                     child: Text(
              //                       "Logout",
              //                       style:
              //                           heading5.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 30,
              //         ),
              //         Material(
              //           borderRadius: BorderRadius.circular(14.0),
              //           elevation: 0,
              //           child: Container(
              //             height: 56,
              //             decoration: BoxDecoration(
              //               color: Colors.blue,
              //               borderRadius: BorderRadius.circular(14.0),
              //             ),
              //             child: Center(
              //               child: Material(
              //                 color: Colors.transparent,
              //                 child: InkWell(
              //                   onTap: () async {
              //                     try {
              //                       User? user =
              //                           FirebaseAuth.instance.currentUser;
              //                       await FirebaseFirestore.instance
              //                           .collection("user_institute")
              //                           .doc(user!.uid)
              //                           .delete();
              //                       await FirebaseFirestore.instance
              //                           .collection("institute")
              //                           .doc(user.uid)
              //                           .delete();
              //                       print("logout successful");
              //                       await FirebaseAuth.instance.currentUser!
              //                           .delete();

              //                       //SchedulerBinding.instance!.addPostFrameCallback((_) {
              //                      Future.delayed(Duration.zero, () {
              //                         Navigator.popUntil(
              //                             context,
              //                             ModalRoute.withName(
              //                                 Navigator.defaultRouteName));
              //                       });
              //                       // });
              //                     } on FirebaseAuthException catch (exp) {
              //                       // ignore: avoid_print
              //                       print("error... Invalid login $exp");
              //                       // ignore: avoid_print
              //                       print("email entered = ");
              //                     } catch (exp) {
              //                       // ignore: avoid_print
              //                       print("error- $exp");
              //                     }
              //                   },
              //                   borderRadius: BorderRadius.circular(14.0),
              //                   child: Center(
              //                     child: Text(
              //                       "Delete user with data",
              //                       style:
              //                           heading5.copyWith(color: Colors.white),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         )
              //       ]),
              // );
            }
            if (snapshot.hasError) {
              print("snapshot has error");
              print(snapshot);
            }
            return const Center(child: Text("something happened"));
          },
        )),
        onWillPop: () async => willpop(context));
  }
}

Future<bool> willpop(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Exit Presence"),
          content: Text("Do you want to exit presence ?"),
          actions: [
            TextButton(
                onPressed: () async {
                  SystemNavigator.pop();
                },
                child: Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No")),
          ],
        );
      });

  return true;
}

class ensureinitinstitute extends StatelessWidget {
  ensureinitinstitute({Key? key}) : super(key: key);
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("institute")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mycode = snapshot.data!.get("code");
            print(mycode);
            return institute();
          } else {
            return Scaffold(
              body: Center(
                child: Text("something happened"),
              ),
            );
          }
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/Selection_page.dart';
import 'package:presence/Student/Student_functions.dart';
import 'package:presence/Teacher/otp_and_qr.dart';
import 'package:presence/Student/student_dahboard.dart';
import 'package:presence/main.dart';

import '../theme.dart';

// ignore: camel_case_types
class student extends StatefulWidget {
  const student({Key? key}) : super(key: key);

  @override
  State<student> createState() => _studentState();
}

class _studentState extends State<student> {
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
  // Future<void> _logout() async {
  //   try {
  //     WidgetsBinding.instance!.addPostFrameCallback((_) {
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (_) => Selection_page()));
  //     });
  //     print("logout successful");
  //     main();
  //   } on FirebaseAuthException catch (exp) {
  //     // ignore: avoid_print
  //     print("error... Invalid login $exp");
  //     // ignore: avoid_print
  //     print("email entered = ");
  //   } catch (exp) {
  //     // ignore: avoid_print
  //     print("error- $exp");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      //your code goes here
    });
    return WillPopScope(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("user_student")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("data found");
                int i = 0;
                int length = snapshot.data!.size;

                try {
                  for (i = 0; i < length; i++) {
                    if (snapshot.data!.docs[i]["uid"] ==
                            FirebaseAuth.instance.currentUser!.uid &&
                        snapshot.data!.docs[i]["accept"] == true) {
                      return MyStudentApp();
                      Scaffold(
                          //   appBar: AppBar(
                          //     title: const Text("student login"),
                          //   ),
                          //   body: StreamBuilder(
                          //     stream: FirebaseAuth.instance.authStateChanges(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.hasData) {
                          //         return Center(
                          //           child: Column(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 const Text("student login dashboard"),
                          //                 Material(
                          //                   borderRadius: BorderRadius.circular(14.0),
                          //                   elevation: 0,
                          //                   child: Container(
                          //                     height: 56,
                          //                     decoration: BoxDecoration(
                          //                       color: Colors.blue,
                          //                       borderRadius: BorderRadius.circular(14.0),
                          //                     ),
                          //                     child: Center(
                          //                       child: Material(
                          //                         color: Colors.transparent,
                          //                         child: InkWell(
                          //                           onTap: () async {
                          //                             try {
                          //                               await FirebaseAuth.instance
                          //                                   .signOut();
                          //                               print("logout successful");
                          //                               //SchedulerBinding.instance!.addPostFrameCallback((_) {
                          //                               Future.delayed(Duration.zero, () {
                          //                                 Navigator.popUntil(
                          //                                     context,
                          //                                     ModalRoute.withName(Navigator
                          //                                         .defaultRouteName));
                          //                               });
                          //                               // });
                          //                             } on FirebaseAuthException catch (exp) {
                          //                               // ignore: avoid_print
                          //                               print(
                          //                                   "error... Invalid login $exp");
                          //                               // ignore: avoid_print
                          //                               print("email entered = ");
                          //                             } catch (exp) {
                          //                               // ignore: avoid_print
                          //                               print("error- $exp");
                          //                             }
                          //                           },
                          //                           borderRadius:
                          //                               BorderRadius.circular(14.0),
                          //                           child: Center(
                          //                             child: Text(
                          //                               "Logout",
                          //                               style: heading5.copyWith(
                          //                                   color: Colors.white),
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 SizedBox(
                          //                   height: 30,
                          //                 ),
                          //                 Material(
                          //                   borderRadius: BorderRadius.circular(14.0),
                          //                   elevation: 0,
                          //                   child: Container(
                          //                     height: 56,
                          //                     decoration: BoxDecoration(
                          //                       color: Colors.blue,
                          //                       borderRadius: BorderRadius.circular(14.0),
                          //                     ),
                          //                     child: Center(
                          //                       child: Material(
                          //                         color: Colors.transparent,
                          //                         child: InkWell(
                          //                           onTap: () async {
                          //                             try {
                          //                               User? user = FirebaseAuth
                          //                                   .instance.currentUser;
                          //                               await FirebaseFirestore.instance
                          //                                   .collection("user_student")
                          //                                   .doc(user!.uid)
                          //                                   .delete();
                          //                               print("delete successful");
                          //                               await FirebaseAuth
                          //                                   .instance.currentUser!
                          //                                   .delete();

                          //                               //SchedulerBinding.instance!.addPostFrameCallback((_) {
                          //                               Future.delayed(Duration.zero, () {
                          //                                 Navigator.popUntil(
                          //                                     context,
                          //                                     ModalRoute.withName(Navigator
                          //                                         .defaultRouteName));
                          //                               });
                          //                               // });
                          //                             } on FirebaseAuthException catch (exp) {
                          //                               // ignore: avoid_print
                          //                               print(
                          //                                   "error... Invalid login $exp");
                          //                               // ignore: avoid_print
                          //                               print("email entered = ");
                          //                             } catch (exp) {
                          //                               // ignore: avoid_print
                          //                               print("error- $exp");
                          //                             }
                          //                           },
                          //                           borderRadius:
                          //                               BorderRadius.circular(14.0),
                          //                           child: Center(
                          //                             child: Text(
                          //                               "Delete user with data",
                          //                               style: heading5.copyWith(
                          //                                   color: Colors.white),
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 )
                          //               ]),
                          //         );
                          //       }
                          //       if (snapshot.hasError) {
                          //         print("snapshot has error");
                          //         print(snapshot);
                          //       }
                          //       return const Center(child: Text("something happened"));
                          //     },
                          //   ),
                          //   floatingActionButton: new FloatingActionButton(
                          //     onPressed: () => Future.delayed(Duration.zero, () {
                          //       Navigator.push(context,
                          //           MaterialPageRoute(builder: (context) => otp_and_qr()));
                          //     }), //() {
                          //     //   _navigate();
                          //     // },
                          //     tooltip: 'Give attendance',
                          //     child: const Icon(Icons.qr_code_rounded),
                          //   ),

                          //   //Center(
                          //   //     child: Column(
                          //   //   children: [
                          //   //     const Text("student login dashboard"),
                          //   //     Material(
                          //   //       borderRadius: BorderRadius.circular(14.0),
                          //   //       elevation: 0,
                          //   //       child: Container(
                          //   //         height: 56,
                          //   //         decoration: BoxDecoration(
                          //   //           color: Colors.blue,
                          //   //           borderRadius: BorderRadius.circular(14.0),
                          //   //         ),
                          //   //         child: Material(
                          //   //           color: Colors.transparent,
                          //   //           child: InkWell(
                          //   //             onTap: () async {
                          //   //               try {
                          //   //                 await FirebaseAuth.instance.signOut();
                          //   //                 print("logout successful");
                          //   //                 //SchedulerBinding.instance!.addPostFrameCallback((_) {
                          //   //                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Selection_page()));
                          //   //                // });
                          //   //               } on FirebaseAuthException catch (exp) {
                          //   //                 // ignore: avoid_print
                          //   //                 print("error... Invalid login $exp");
                          //   //                 // ignore: avoid_print
                          //   //                 print("email entered = ");
                          //   //               } catch (exp) {
                          //   //                 // ignore: avoid_print
                          //   //                 print("error- $exp");
                          //   //               }
                          //   //             },
                          //   //             borderRadius: BorderRadius.circular(14.0),
                          //   //             child: Center(
                          //   //               child: Text(
                          //   //                 "Login",
                          //   //                 style: heading5.copyWith(color: Colors.white),
                          //   //               ),
                          //   //             ),
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //     ),
                          //   //   ],
                          //   // )),
                          );
                    }
                    if (snapshot.data!.docs[i]["uid"] ==
                            FirebaseAuth.instance.currentUser!.uid &&
                        snapshot.data!.docs[i]["accept"] == false) {
                      WaitingScreen();
                    }
                  }
                } catch (e) {
                  return WaitingScreen();
                }
              }
              return WaitingScreen();
            }),
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

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("user_student").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int i = 0;
            for (i = 0; i < snapshot.data!.size; i++) {
              try {
                if (snapshot.data!.docs[i]["uid"] ==
                        FirebaseAuth.instance.currentUser!.uid &&
                    snapshot.data!.docs[i]["accept"] == false) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("The institute is about to accept your request"),
                          SizedBox(
                            height: 25,
                          ),
                          Material(
                              borderRadius: BorderRadius.circular(14.0),
                              elevation: 0,
                              child: Container(
                                  height: 56,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: primaryBlue,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      highlightColor:
                                          Colors.blue.withOpacity(0.4),
                                      splashColor:
                                          Colors.green.withOpacity(0.5),
                                      onTap: () async {
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        await FirebaseFirestore.instance
                                            .collection("user_student")
                                            .doc(user!.uid)
                                            .delete();
                                        print("delete successful");
                                        await FirebaseAuth.instance.currentUser!
                                            .delete();
                                        Future.delayed(Duration.zero, () {
                                          Navigator.popUntil(
                                              context,
                                              ModalRoute.withName(
                                                  Navigator.defaultRouteName));
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Center(
                                        child: Text(
                                          "Delete account",
                                          style: heading5.copyWith(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ))),
                          SizedBox(
                            height: 25,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(14.0),
                            elevation: 0,
                            child: Container(
                              height: 56,
                              width: 300,
                              decoration: BoxDecoration(
                                color: primaryBlue,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    highlightColor:
                                        Colors.blue.withOpacity(0.4),
                                    splashColor: Colors.green.withOpacity(0.5),
                                    onTap: () async {
                                      try {
                                        await FirebaseAuth.instance.signOut();
                                        print("logout successful");
                                        //SchedulerBinding.instance!.addPostFrameCallback((_) {
                                        Future.delayed(Duration.zero, () {
                                          Navigator.popUntil(
                                              context,
                                              ModalRoute.withName(
                                                  Navigator.defaultRouteName));
                                        });
                                        // });
                                      } on FirebaseAuthException catch (exp) {
                                        // ignore: avoid_print
                                        print("error... Invalid login $exp");
                                        // ignore: avoid_print
                                        print("email entered = ");
                                      } catch (exp) {
                                        // ignore: avoid_print
                                        print("error- $exp");
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: Center(
                                      child: Text(
                                        "Logout",
                                        style: heading5.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              } catch (e) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("The institute has rejected your request"),
                        SizedBox(
                          height: 25,
                        ),
                        Material(
                            borderRadius: BorderRadius.circular(14.0),
                            elevation: 0,
                            child: Container(
                                height: 56,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: primaryBlue,
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      await FirebaseFirestore.instance
                                          .collection("user_student")
                                          .doc(user!.uid)
                                          .delete();
                                      print("delete successful");
                                      await FirebaseAuth.instance.currentUser!
                                          .delete();
                                      Future.delayed(Duration.zero, () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                Navigator.defaultRouteName));
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: Center(
                                      child: Text(
                                        "Delete account",
                                        style: heading5.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ))),
                        SizedBox(
                          height: 25,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(14.0),
                          elevation: 0,
                          child: Container(
                            height: 56,
                            width: 300,
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor: Colors.blue.withOpacity(0.4),
                                  splashColor: Colors.green.withOpacity(0.5),
                                  onTap: () async {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      print("logout successful");
                                      //SchedulerBinding.instance!.addPostFrameCallback((_) {
                                      Future.delayed(Duration.zero, () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                Navigator.defaultRouteName));
                                      });
                                      // });
                                    } on FirebaseAuthException catch (exp) {
                                      // ignore: avoid_print
                                      print("error... Invalid login $exp");
                                      // ignore: avoid_print
                                      print("email entered = ");
                                    } catch (exp) {
                                      // ignore: avoid_print
                                      print("error- $exp");
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(14.0),
                                  child: Center(
                                    child: Text(
                                      "Logout",
                                      style: heading5.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
          }
          return Scaffold(
            body: Center(
              child: Text("Error occured"),
            ),
          );
        });
  }
}

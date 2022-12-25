import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/Institute/institutehome.dart';
import 'package:presence/Selection_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presence/Student/studenthome.dart';
import 'package:presence/Teacher/teacherhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Connection_checker(),
      // const MyHomePage(title: "HOME",)
    ));
  }
}

// flutter run --no-sound-null-safety
// ignore: camel_case_types
class Connection_checker extends StatefulWidget {
  Connection_checker({Key? key}) : super(key: key);

  @override
  State<Connection_checker> createState() => _Connection_checkerState();
}

class _Connection_checkerState extends State<Connection_checker> {
  Future<void> checkinternet() async {
    bool hasinternet = await InternetConnectionChecker().hasConnection;
    final text = hasinternet ? "Connected" : "No internet";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkinternet();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCi8Mt0qh4bpLl_sNFs6ZUW-LCOqm9ryb4',
          appId: '1:267084318059:web:3af05c13deb7bb79f4782e',
          messagingSenderId: '267084318059',
          projectId: 'presence-d332b'));

  Future<void> _gotostudent() async {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const student()));
      // Your Code
    });
  }

  Future<void> _gototeacher() async {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const teacher()));
      // Your Code
    });
  }

  Future<void> _gotoinstitute() async {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const institute()));
      // Your Code
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("error...." + snapshot.error.toString()),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                var arr = ["user_student", "user_teacher", "user_institute"];
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data as User?;
                  if (user == null) {
                    return const Selection_page();
                    // ignore: unnecessary_null_comparison
                  }
                  if (user != null) {
                    // ignore: unused_local_variable
                    return Scaffold(
                        body: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(arr[0])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                int i = 0;
                                int length = snapshot.data!.size;
                                for (i = 0; i < length; i++) {
                                  if (snapshot.data!.docs[i]["uid"]
                                          .toString() ==
                                      // ignore: unrelated_type_equality_checks
                                      user.uid) {
                                    _gotostudent();
                                  }
                                }
                                // return const Center(
                                //   child: Text("Permission denied"),
                                //);
                              }
                              if (snapshot.hasError) {
                                // ignore: avoid_print
                                print("error $snapshot");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  // child: Text("waiting"),
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Scaffold(
                                  body: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection(arr[1])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          int i = 0;
                                          int length = snapshot.data!.size;
                                          for (i = 0; i < length; i++) {
                                            if (snapshot.data!.docs[i]["uid"]
                                                    .toString() ==
                                                user.uid) {
                                              _gototeacher();
                                            }
                                          }
                                          // return const Center(
                                          //   child: Text("Permission denied"),
                                          //);
                                        }
                                        if (snapshot.hasError) {
                                          // ignore: avoid_print
                                          print("error $snapshot");
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            // child: Text("waiting"),
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return Scaffold(
                                            body: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection(arr[2])
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    int i = 0;
                                                    int length =
                                                        snapshot.data!.size;
                                                    for (i = 0;
                                                        i < length;
                                                        i++) {
                                                      if (snapshot.data!
                                                              .docs[i]["uid"]
                                                              .toString() ==
                                                          user.uid) {
                                                        _gotoinstitute();
                                                      }
                                                    }
                                                  }
                                                  if (snapshot.hasError) {
                                                    // ignore: avoid_print
                                                    print("error $snapshot");
                                                  }
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      // child: Text("waiting"),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    Selection_page;
                                                    return const Center(
                                                      // child: Text("waiting"),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                }));
                                      }));
                            }));
                  }
                  // elase ends here
                  if (user != null) {
                  } else {}
                }
                return const Scaffold(
                  body: Center(
                    child: Text("Checking login...."),
                  ),
                );
              },
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text("Something happened...."),
              ),
            );
          }
        });
  }
}

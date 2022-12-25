import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:presence/register/register_as_a_stu.dart';
import 'Forget.dart';
import 'widgets/custom_checkbox.dart';
import 'theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:presence/Student/studenthome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
dynamic userid;
// ignore: camel_case_types
class student_login extends StatefulWidget {
  @override
  _student_loginState createState() => _student_loginState();
}

final GlobalKey<FormState> _formKey = GlobalKey();

// ignore: camel_case_types
class _student_loginState extends State<student_login> {
  void callstudent() async {
    Future.delayed(Duration.zero, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const student()));
    });
  }

  Future<void> _authuser() async {
    print("entered auth user");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailEditingController.text,
              password: passwordEditingController.text);
      // ignore: avoid_print
      // print("email - $userCredential");
      userid = FirebaseAuth.instance.currentUser!.uid;
      print(userid);
      AsyncSnapshot qs = FirebaseFirestore.instance
          .collection("user_student")
          .snapshots() as AsyncSnapshot;
      if (qs.hasData) {
        int i = 0;
        int length = qs.data!.size;
        for (i = 0; i < length; i++) {
          if (qs.data!.docs[i]["uid"].toString() == userid && qs.data!.docs[i]["accept"]==true) {
            callstudent();
          }
          else{
Future.delayed(Duration.zero, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const WaitingScreen()));
    });
          }
        }
        print("waiting");
      }
      if (qs.hasError) {
        // ignore: avoid_print
        print("error $qs");
      }
      if (qs.connectionState == ConnectionState.waiting) {
        print("waiting");
      }

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => checkstudent(
      //               userid: userid,
      //             )));

      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (exp) {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Inavlid login"),
          content: Text("Invalid login id or password"),
          actions: [
            TextButton(onPressed: () async{
Navigator.of(context).pop();
        }, child: Text("Try again"))
          ],
        );
      });
      // ignore: avoid_print
      print("error... Invalid login $exp");
      // ignore: avoid_print
    } catch (exp) {
      // ignore: avoid_print
      print("error- $exp");
    }
  }

  void callauthuser() {
    _authuser();
  }

  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }
  Future<void> checkinternet() async {
  bool hasinternet = await InternetConnectionChecker().hasConnection;
  final text = hasinternet ? "Connected" : "No internet";
  final alertcolor = hasinternet ? Colors.green : Colors.red;
  showSimpleNotification(
    Text(text),
    position: NotificationPosition.bottom,
    background: alertcolor
  );
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkinternet();
  }
// ignore: prefer_typing_uninitialized_variables
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      // Your Code
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
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
                  Text(
                    'Student Login',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: emailEditingController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) =>
                            emailEditingController.text = value!,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: passwordEditingController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                        },
                        onSaved: (value) =>
                            passwordEditingController.text = value!,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: togglePassword,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 32,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     CustomCheckbox(),
              //     SizedBox(
              //       width: 12,
              //     ),
              //     Text('Remember me', style: regular16pt),
              //   ],
              // ),
              SizedBox(
                height: 32,
              ),
              Material(
                borderRadius: BorderRadius.circular(14.0),
                elevation: 0,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          print("validated");
                          callauthuser();
                        }
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: Text(
                          "Login",
                          style: heading5.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Forget Password?',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text(
                      'Register',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("user_student").snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          int i = 0;
          for (i = 0; i < snapshot.data!.size;i++){
          if(snapshot.data!.docs[i]["uid"] == userid && snapshot.data!.docs[i]["accept"] == false)
          {
            return Center(
              child: Row(
                children: [
                  Text("The institute is about to accept your request"),
                  SizedBox(
                    height: 25,
                  ),
                  Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                                await FirebaseFirestore.instance.collection("user_student").doc(user!.uid).delete();
                                print("delete successful");
                                await FirebaseAuth.instance.currentUser!.delete();
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
                        style: heading5.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
                ],
              ),
            );
          }
          if(snapshot.data!.docs[i]["rejeted"] == true){
            return Center(
              child: Row(
                children: [
                  Text("The institute has rejected your request"),
                  SizedBox(
                    height: 25,
                  ),
                  Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                                await FirebaseFirestore.instance.collection("user_student").doc(user!.uid).delete();
                                print("delete successful");
                                await FirebaseAuth.instance.currentUser!.delete();
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
                        style: heading5.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
                ],
              ),
            );
          }
          }
        }
          return Scaffold(
            body: Center(child: Text("Error occured"),),
          );
        
      });
  }
}
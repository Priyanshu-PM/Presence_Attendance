// ignore_for_file: prefer_equal_for_default_values
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presence/Institute_login.dart';
import 'package:presence/register/ins_add_courses.dart';
import 'package:presence/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

final instituteNameEditingController = new TextEditingController();
final deptNameEditingController = new TextEditingController();
final emailEditingController = new TextEditingController();
final passwordEditingController = new TextEditingController();
final confirmPasswordEditingController = new TextEditingController();
final contactinfocontroller = new TextEditingController();
late final String insCode; 
class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }
String generateRandomString(int len) {
  var r = Random();
  const _chars = '1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
void generateinscode(){
  insCode = generateRandomString(8);
}
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child:Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register as an Institute',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: instituteNameEditingController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Institute Name cannot be Empty");
                          }
                        },
                        onSaved: (value) =>
                            instituteNameEditingController.text = value!,
                        decoration: InputDecoration(
                          hintText: 'Institute Name',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: deptNameEditingController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Department Name cannot be Empty");
                          }
                        },
                        onSaved: (value) =>
                            deptNameEditingController.text = value!,
                        decoration: InputDecoration(
                          hintText: 'Department',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
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
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        textInputAction: TextInputAction.next,
                        controller: confirmPasswordEditingController,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          if (passwordEditingController.text !=
                              confirmPasswordEditingController.text) {
                            return ("Passwords don't match");
                          }
                        },
                        onSaved: (value) =>
                            confirmPasswordEditingController.text = value!,
                        obscureText: !passwordConfrimationVisible,
                        decoration: InputDecoration(
                          hintText: 'Password Confirmation',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordConfrimationVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () {
                              setState(() {
                                passwordConfrimationVisible =
                                    !passwordConfrimationVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        controller: contactinfocontroller,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{10,}$');
                          if (value!.isEmpty) {
                            return ("Contact is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Phone number");
                          }
                        },
                        onSaved: (value) => contactinfocontroller.text = value!,
                        decoration: InputDecoration(
                          hintText: 'Contact No',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                          child: MaterialButton(
                            onPressed: () async {
                              final FormState? formstateofform =
                                  _formKey.currentState;
                              print("form state of form is");
                              print(formstateofform);
                              formstateofform!.save();
                              print(formstateofform);
                              // ignore: unnecessary_null_comparison
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // ignore: avoid_print
                                print("validated");
                                try {
                                  generateinscode();
                                  FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);

                                  UserCredential result = await FirebaseAuth
                                      .instanceFor(app: app)
                                      .createUserWithEmailAndPassword(
                                          email: emailEditingController.text,
                                          password:
                                              passwordEditingController.text);
                                              
                                  User? user = result.user;
                                  await app.delete();
                                  await FirebaseFirestore.instance
                                      .collection('user_institute')
                                      .doc(user!.uid)
                                      .set({'uid': user.uid,'code':insCode});
                                      await FirebaseFirestore.instance
                                      .collection('institute')
                                      .doc(user.uid)
                                      .set({'uid': user.uid,'code':insCode,'name':instituteNameEditingController.text,'dept':deptNameEditingController.text,'contact':contactinfocontroller.text});
                                  //.doc(user!.uid).set({ 'uid': });
                                  Future.delayed(Duration.zero, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InsAddCourses( curuser: user,username: emailEditingController.text,pass: passwordEditingController.text,)));
    });
                                } on FirebaseAuthException catch (exp) {
                                  // ignore: avoid_print
                                  print("error... Invalid login $exp");
                                  // ignore: avoid_print
                                } catch (exp) {
                                  // ignore: avoid_print
                                  print("error- $exp");
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             Registerinstitute()));
                              } else {
                                // ignore: avoid_print
    //                              Future.delayed(Duration.zero, () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => InsAddCourses()));
    // });
                              }
                            },
                            child: Center(
                              child: Text(
                                "Register",
                                style: heading5.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: regular16pt.copyWith(color: textGrey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: Text(
                            'Login',
                            style: regular16pt.copyWith(color: primaryBlue),
                          ),
                        ),
                      ],
                    ), const SizedBox(
                      height: 32,
                    ), const SizedBox(
                      height: 32,
                    ), const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ], //add here
          ),
        ),
      ),
    ));
  }
}

// class Registerinstitute extends StatefulWidget {
//   Registerinstitute({
//     Key? key,
//   }) : super(key: key);
//   @override
//   _RegisterinstituteState createState() => _RegisterinstituteState();
// }

// class _RegisterinstituteState extends State<Registerinstitute> {
//   final _auth = FirebaseAuth.instance;
//   var userid;
//   // string for displaying the error Message
//   String? errorMessage;
//   void createinstitute() async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//           email: emailEditingController.text,
//           password: passwordEditingController.text);
//       userid = FirebaseAuth.instance.currentUser!.uid;
//     } on FirebaseAuthException catch (error) {
//       switch (error.code) {
//         case "invalid-email":
//           errorMessage = "Your email address appears to be malformed.";
//           break;
//         case "wrong-password":
//           errorMessage = "Your password is wrong.";
//           break;
//         case "user-not-found":
//           errorMessage = "User with this email doesn't exist.";
//           break;
//         case "user-disabled":
//           errorMessage = "User with this email has been disabled.";
//           break;
//         case "too-many-requests":
//           errorMessage = "Too many requests";
//           break;
//         case "operation-not-allowed":
//           errorMessage = "Signing in with Email and Password is not enabled.";
//           break;
//         default:
//           errorMessage = "An undefined Error happened.";
//       }
//       print(error.code);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection("user_institute")
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 createinstitute();
//                 int i = 0;
//                 int length = snapshot.data!.size;
//                 for (i = 0; i < length; i++) {
//                   if (snapshot.data!.docs[i]["uid"].toString() == userid) {
//                     return const Center(
//                       child: Text("User exixt"),
//                     );
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => const institute()));
//                   } else {}
//                 }
//                 FirebaseFirestore.instance.runTransaction((transaction) async {
//                   CollectionReference refernce =
//                       FirebaseFirestore.instance.collection('user_institute');
//                   await refernce
//                       .add({"institutecode": "123441", "uid": userid});
//                   print("user craeted successfully");
//                 });
//               }
//               if (snapshot.hasError) {
//                 // ignore: avoid_print
//                 print("error $snapshot");
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: Text("waiting"),
//                 );
//               }
//               return Center(
//                 child: Text("Something happened...."),
//               );
//             }));
//   }
// }

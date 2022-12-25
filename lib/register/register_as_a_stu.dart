import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presence/register/student_select_courses.dart';
import 'package:presence/student_login.dart';
import 'package:presence/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late QuerySnapshot gqs;
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  Future<void> getdata() async {
    gqs = await FirebaseFirestore.instance.collection("institute").get();
  }

  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final StudentNameEditingController = new TextEditingController();
  final collegecodeEditingController = new TextEditingController();
  final collegeidEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final contactinfocontroller = new TextEditingController();
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register as a Student',
                        style: heading2.copyWith(color: textBlack),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Image.asset(
                        'assets/images/accent.png',
                        width: 99,
                        height: 4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                            autovalidateMode: AutovalidateMode.always,
                            controller: StudentNameEditingController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Student Name cannot be Empty");
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) =>
                                StudentNameEditingController.text = value!,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: heading6.copyWith(color: textGrey),
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
                            controller: collegecodeEditingController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Institute code cannot be Empty");
                              } else {
                                //Future<bool> check = insvalidate(value);
                                // if(check == true){
                                //   return null;
                                // }else{
                                return null;
                                // }
                              }
                            },
                            onSaved: (value) =>
                                collegecodeEditingController.text = value!,
                            decoration: InputDecoration(
                              hintText: 'Institute Code',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
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
                            controller: collegeidEditingController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Institute Id cannot be Empty");
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) =>
                                collegeidEditingController.text = value!,
                            decoration: InputDecoration(
                              hintText: 'Enrollment Number',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 15,
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
                              controller: emailEditingController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please Enter Your Email");
                                }
                                // reg expression for email validation
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please Enter a valid email");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) =>
                                  emailEditingController.text = value!,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: heading6.copyWith(color: textGrey),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress),
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
                            controller: passwordEditingController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return ("Password is required for login");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter Valid Password(Min. 6 Character)");
                              } else {
                                return null;
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
                              } else {
                                return null;
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
                          height: 20,
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
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) =>
                                contactinfocontroller.text = value!,
                            decoration: InputDecoration(
                              hintText: 'Phone No',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        )
                      ],
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
                              for (int n = 0; n < gqs.size; n++) {
                                if (gqs.docs[n]["code"] ==
                                    collegecodeEditingController.text) {
                                  _formKey.currentState!.save();
                                  // ignore: avoid_print
                                  print("validated");
                                  FirebaseApp app =
                                      await Firebase.initializeApp(
                                          name: 'ternary',
                                          options: Firebase.app().options);
                                  try {
                                    QuerySnapshot qs = await FirebaseFirestore
                                        .instance
                                        .collection("institute")
                                        .get();
                                    int x = 1;
                                    for (int i = 0; i < qs.size; i++) {
                                      if (qs.docs[i]["code"].toString() ==
                                          collegecodeEditingController.text
                                              .toString()) {
                                        x = 0;
                                        break;
                                      } else {
                                        x = 1;
                                      }
                                    }
                                    if (x == 1) {
                                      throw Exception();
                                    }

                                    UserCredential result =
                                        await FirebaseAuth.instanceFor(app: app)
                                            .createUserWithEmailAndPassword(
                                                email:
                                                    emailEditingController.text,
                                                password:
                                                    passwordEditingController
                                                        .text);
                                    User? user = result.user;
                                    await app.delete();
                                    await FirebaseFirestore.instance
                                        .collection('user_student')
                                        .doc(user!.uid)
                                        .set({
                                      'uid': user.uid,
                                      'name': StudentNameEditingController.text,
                                      'accept': false,
                                      'roll': collegeidEditingController.text,
                                      "contact": contactinfocontroller.text,
                                      "inscode":
                                          collegecodeEditingController.text
                                    });
                                    //.doc(user!.uid).set({ 'uid': });
                                    Future.delayed(Duration.zero, () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Studentselectcourses(
                                                    user: user,
                                                    inscode:
                                                        collegecodeEditingController
                                                            .text,
                                                    username:
                                                        emailEditingController
                                                            .text,
                                                    pass:
                                                        passwordEditingController
                                                            .text,
                                                  )));
                                    });
                                  } on FirebaseAuthException catch (exp) {
                                    await app.delete();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Invalid Login"),
                                            content: Text(exp.toString()),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Close"))
                                            ],
                                          );
                                        });

                                    // ignore: avoid_print
                                    print("error... Invalid login $exp");
                                    // ignore: avoid_print
                                  } catch (exp) {
                                    await app.delete();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Invalid Institute"),
                                            content:
                                                Text("Institute not found"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Close"))
                                            ],
                                          );
                                        });
                                    // ignore: avoid_print
                                    print("error- $exp");
                                  } finally {
                                    await app.delete();
                                  }

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             Registerinstitute()));

                                }
                              }
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Institute not Found"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Future.delayed(Duration.zero, () {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text("Back"))
                                      ],
                                    );
                                  });
                            } else {}
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
                    height: 32,
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
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

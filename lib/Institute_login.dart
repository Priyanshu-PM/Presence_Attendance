// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:presence/Selection_page.dart';
import 'package:presence/register/reg_as_ins.dart';
import 'Forget.dart';
import 'widgets/custom_checkbox.dart';
import 'theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presence/Institute/institutehome.dart';

class Institute_login extends StatefulWidget {
  @override
  _Institute_loginState createState() => _Institute_loginState();
}
final GlobalKey<FormState> _formKey = GlobalKey();
class _Institute_loginState extends State<Institute_login> {
  bool passwordVisible = false;
  // ignore: prefer_typing_uninitialized_variables
var userid;
 void callinstitute() async{
      Future.delayed(Duration.zero,(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const institute()));});
 }
 Future<void> _authuser() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text);
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
                  if (qs.data!.docs[i]["uid"].toString() ==
                      userid) {
                      callinstitute();
                  }
                } print("waiting")
                ;}
                if (qs.hasError) {
                // ignore: avoid_print
                print("error $qs");
              }
              if (qs.connectionState == ConnectionState.waiting) {
                print("waiting")
                ;
              }

    // ignore: unused_catch_clause
    }on FirebaseAuthException catch (exp){
      // ignore: avoid_print
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
      print("error... Invalid login $exp");
      // ignore: avoid_print
    }catch (exp){
      // ignore: avoid_print
      print("error- $exp");
    }
  }
 void callauthuser(){
    _authuser();
  }
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }
final emailEditingController = new TextEditingController();
final passwordEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: 
       Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
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
                    'Institute Login',
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
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                          border: OutlineInputBorder(
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
            onTap: callauthuser,
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
      ),
    );
    // ignore: dead_code
    ;
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
// class checkstudent extends StatefulWidget {
//   var userid;
//   checkstudent({ Key? key ,required this.userid}) : super(key: key);
//   @override
//   _checkstudentState createState() => _checkstudentState();
// }

// class _checkstudentState extends State<checkstudent> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("user_institute").snapshots(),
//       builder:(context,snapshot){
//          if (snapshot.hasData) {
//                 int i = 0;
//                 int length = snapshot.data!.size;
//                 for (i = 0; i < length; i++) {
//                   if (snapshot.data!.docs[i]["uid"].toString() ==
//                       widget.userid) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const institute()));
//                   }
//                 }return const Center(
//                     child: Text("Permission denied"),
//                   );
//               }
//         if(snapshot.hasError){
//           // ignore: avoid_print
//           print("error $snapshot");
//         }
//         if(snapshot.connectionState == ConnectionState.waiting){
//           return const Center(
//             child: Text("waiting"),
//           );
//         }
//         return Center(
//             child: Text("Something happened...."),
//           );
        
         
        
//       })
//     );
//   }
// }


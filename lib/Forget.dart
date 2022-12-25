import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presence/Forget3.dart';
import 'package:presence/register_page.dart';
import 'package:presence/widgets/custom_checkbox.dart';
import 'package:presence/widgets/primary_button_main.dart';
import 'theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
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
                        'Forget Password',
                        style: heading2.copyWith(color: textBlack),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/images/accent.png',
                        width: 999,
                        height: 4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Form(
                    key:_formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: TextFormField(
                            controller: emailEditingController,
                            validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                        },keyboardType: TextInputType.emailAddress,
                        onSaved: (value) =>
                            emailEditingController.text = value!,
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              
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
                        ),
                      ],
                    ),
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
            onTap:() async {if (_formKey.currentState!.validate()){
              print("validated");
              try {
                 await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEditingController.text);
                 Future.delayed(Duration.zero,(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage4()));});
              } catch (e) {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text(e.toString()),
                    actions: [TextButton(onPressed: (){
                      Future.delayed(Duration.zero,(){
                    Navigator.of(context).pop();});
                    }, child: Text("Back"))],
                  );
                });
              }
               }
               },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Send request',
                style: heading5.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    ),
      ]),
          ),
        ));
  }
}

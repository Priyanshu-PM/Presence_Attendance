// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:presence/Institute/institutehome.dart';
import "package:presence/theme.dart";

class InsAddCourses extends StatefulWidget {
  final User curuser;
  final String username;
  final String pass;


  const InsAddCourses({Key? key,required this.curuser,required this.username,required this.pass}) : super(key: key);
  @override
  _InsAddCoursesState createState() => _InsAddCoursesState();
}

class _InsAddCoursesState extends State<InsAddCourses> {
  final coursetitlecontroller = new TextEditingController();
  final coursedesccontroller = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<coursedetails> courselist = [];
  bool passwordVisible = false;
  Future<void> Addtocourselist(String Coursetitle, String Desc) async {
    print(Coursetitle);
    print(Desc);
    courselist.add(coursedetails(title: Coursetitle, desc: Desc));
    coursedesccontroller.clear();
    coursetitlecontroller.clear(); 
    setState(() { });
    //print(courselist.length);
  }
  Future<dynamic>? addcoursedialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add course"),
            actions: [
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
                        controller: coursetitlecontroller,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter course title");
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => coursetitlecontroller.text = value!,
                        decoration: InputDecoration(
                          hintText: 'Course title',
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
                        controller: coursedesccontroller,
                        textInputAction: TextInputAction.next,
                        // ignore: missing_return
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please enter discription of course");
                          }
                        },
                        onSaved: (value) => coursedesccontroller.text = value!,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: heading6.copyWith(color: textGrey),
                          // suffixIcon: IconButton(
                          //   color: textGrey,
                          //   splashRadius: 1,
                          //   icon: Icon(passwordVisible
                          //       ? Icons.visibility_outlined
                          //       : Icons.visibility_off_outlined),
                          //   onPressed: togglePassword,
                          // ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 0,
                child: Container(
                  height: 30,
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
                          Addtocourselist(coursetitlecontroller.text,
                              coursedesccontroller.text);   
                          Future.delayed(Duration.zero, () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: Text(
                          "Add",
                          style: heading5.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
Widget checklistempty() {
  if(courselist.isEmpty){
    print("list is null");
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Add courses to the list",style: heading6.copyWith(color: textBlack))],
    ));
  }else{
    return ListView.builder(itemCount: courselist.length,
              itemBuilder: (context, index) => 
              courselistwidget(
      onClicked: () {
        courselist.removeAt(index);
        setState(() { });
      },
      item: courselist[index],
    ));
          
  }
}
@override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
                height: 40,
              ),
          Container(
            height: 10,
          ),
          Text(
            'Add courses',
            style: heading2.copyWith(color: textBlack),
          ),
          Expanded(
              child:checklistempty()),
          Container(
            padding: EdgeInsets.all(12),
            child: Material(
              borderRadius: BorderRadius.circular(14.0),
              elevation: 0,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => addcoursedialogue(context),
                    borderRadius: BorderRadius.circular(14.0),
                    child: Center(
                      child: Text(
                        "Add course",
                        style: heading5.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Material(
              borderRadius: BorderRadius.circular(14.0),
              elevation: 0,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if(courselist.isEmpty){
                        print("Enter courses");
                      }else{
                        User user = widget.curuser;
                        print("user");
                        print(user);
                        List<dynamic> ctitle=[];
                        List<dynamic> cdesc=[];
                        for(int i = 0;i<courselist.length;i++){
                          ctitle.add(courselist[i].title);
                          print(ctitle);
                          cdesc.add(courselist[i].desc);
                        }
                        try{
                          await FirebaseFirestore.instance.collection("institute").doc(user.uid).update({"course_title":ctitle});
                          await FirebaseFirestore.instance.collection("institute").doc(user.uid).update({"course_des":cdesc});
                          List<dynamic> templist = [];
                            for(int i = 0;i<ctitle.length;i++){
                              await FirebaseFirestore.instance.collection("institute").doc(user.uid).collection(ctitle[i]).doc("courseinfo").set({"student_list": templist,"teacher_list": templist});
                            }
                             await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.username, password: widget.pass);   
                        // ignore: nullable_type_in_catch_clause
                        }on Exception catch (exp) {
                                  // ignore: avoid_print
                                  print("error... Invalid login $exp");
                                  // ignore: avoid_print
                                } catch (exp) {
                                  // ignore: avoid_print
                                  print("error- $exp");
                                }
                        print("Courses chosen successfully");
                      }
                    },
                    borderRadius: BorderRadius.circular(14.0),
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: heading5.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }}

class coursedetails {
  final String title;
  final String desc;

  const coursedetails({
    required this.title,
    required this.desc,
  });
}

class courselistwidget extends StatelessWidget {
  final coursedetails item;
  final VoidCallback onClicked;

  const courselistwidget({
    required this.item,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            subtitle: Text(item.desc, style: TextStyle(fontSize: 20)),
            title: Text(item.title, style: TextStyle(fontSize: 20)),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline_outlined, color: Colors.red, size: 32),
              onPressed: onClicked,
            ),
          ),
      );
}

import '../register/ins_add_courses.dart';
import '../theme.dart';
import 'Functions_teacher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<bool> _isChecked = [];

class SelectCourse extends StatefulWidget {
  final User user;
  final String inscode;
  final String username;
  final String pass;

  const SelectCourse(
      {Key? key,
      required this.user,
      required this.inscode,
      required this.username,
      required this.pass})
      : super(key: key);
  @override
  _FacultySelectCourseState createState() => _FacultySelectCourseState();
}

bool flag = false;

class _FacultySelectCourseState extends State<SelectCourse> {
  final coursetitlecontroller = new TextEditingController();
  final coursedesccontroller = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<dynamic> courselist = [];
  List<dynamic> finalregisterlist = [];
  bool passwordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    getcoursefromdatabase();
    super.initState();
  }

  static String insid = "";
  Future<void> getcoursefromdatabase() async {
    int i = 0;
    List<dynamic> demolist = [];
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    for (i = 0; i < qs.size; i++) {
      if (qs.docs[i]['code'] == widget.inscode) {
        int j = 0;
        insid = qs.docs[i].id;
        List courseTitle = qs.docs[i]["course_title"];
        List courseDes = qs.docs[i]["course_des"];
        print(courseTitle);
        for (j = 0; j < courseTitle.length; j++) {
          demolist
              .add(coursedetails(title: courseTitle[j], desc: courseDes[j]));
        }
      }
    }
    addtoactuallist(demolist);
  }

  void addtoactuallist(List<dynamic> demo) {
    courselist = demo;
    _isChecked = List.filled(courselist.length, false);
    setState(() {});
  }

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
              child: ListView.builder(
                  itemCount: courselist.length,
                  itemBuilder: (context, index) => courselistwidget(
                      item: courselist[index],
                      is_checked: _isChecked[index],
                      onClicked: () {
                        setState(() {
                          _isChecked[index] = flag;
                        });
                      }))),
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
                      print(courselist);
                      if (courselist.isEmpty) {
                        print("Select courses");
                      } else {
                        int i = 0;
                        int j = courselist.length;
                        for (i = 0; i < j; i++) {
                          if (_isChecked[i] == true) {
                            finalregisterlist.add(courselist[i]);
                          }
                        }
                        List<dynamic> ctitle = [];
                        List<dynamic> cdesc = [];
                        for (int i = 0; i < finalregisterlist.length; i++) {
                          ctitle.add(finalregisterlist[i].title);
                          print(ctitle);
                          cdesc.add(finalregisterlist[i].desc);
                        }
                        try {
                          await FirebaseFirestore.instance
                              .collection("user_student")
                              .doc(widget.user.uid)
                              .update({"course_title": ctitle});
                          await FirebaseFirestore.instance
                              .collection("user_student")
                              .doc(widget.user.uid)
                              .update({"course_des": cdesc});
                          // try{
                          //   value.docs[0].data().update("course_title", (value) => ctitle,ifAbsent: ()=>ctitle);
                          //   value.docs[0].data().update("course_des", (value) => cdesc,ifAbsent: ()=>cdesc);
                          // }catch(e){
                          //   print(e);
                          // }
                          // ignore: nullable_type_in_catch_clause
                          // FirebaseAuth.instance.signInWithCredential(widget);
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: widget.username,
                                  password: widget.pass);
                        } on Exception catch (exp) {
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
  }
}

class coursedetails {
  final String title;
  final String desc;

  const coursedetails({
    required this.title,
    required this.desc,
  });
}

class courselistwidget extends StatefulWidget {
  final coursedetails item;
  // ignore: non_constant_identifier_names
  late bool is_checked;
  final VoidCallback onClicked;

  courselistwidget({
    required this.item,
    // ignore: non_constant_identifier_names
    required this.is_checked,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  State<courselistwidget> createState() => _courselistwidgetState();
}

class _courselistwidgetState extends State<courselistwidget> {
  bool checkedornot = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          subtitle: Text(widget.item.desc, style: TextStyle(fontSize: 20)),
          title: Text(widget.item.title, style: TextStyle(fontSize: 20)),
          onChanged: (bool? value) {
            flag = value!;
            widget.onClicked();
          },
          value: widget.is_checked,
        ),
      );
}

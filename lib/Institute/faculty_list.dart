import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:presence/Institute/institutehome.dart';
import 'package:presence/Teacher/teacherhome.dart';
import 'package:presence/student_login.dart';
import 'dart:async';
import '../theme.dart';
import 'Functions_ins.dart';

// ignore: use_key_in_widget_constructors
class F_listapp extends StatefulWidget {
  @override
  State<F_listapp> createState() => _F_listappState();
}

class _F_listappState extends State<F_listapp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: FListpage(),
      );
}

class FListpage extends StatefulWidget {
  @override
  _FListpageState createState() => _FListpageState();
}

class _FListpageState extends State<FListpage> {
  @override
  void setState(VoidCallback fn) {
    get_all_teachers(); // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ChatsScreen(),
          ),
        ),
      );
}

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 1;
  @override
  void setState(VoidCallback fn) {
    //get_all_teachers();
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print("retrved faclty list");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
        ),
        title: Text("Faculty List", style: TextStyle(color: Colors.black)),
      ),
      body: Body(),
    );
  }
}

// class Mylist extends StatefulWidget {
//   const Mylist({ Key? key }) : super(key: key);

//   @override
//   _MylistState createState() => _MylistState();
// }
// class _MylistState extends State<Mylist> {
// int length = 0;
//   // ignore: non_constant_identifier_names
//   Future get_student_attendence() async{
//     var firestore = FirebaseFirestore.instance;
//     // ignore: await_only_futures, non_constant_identifier_names
//     QuerySnapshot QS = (await firestore.collection("post").get());
//     length = QS.docs.length;
//     return QS.docs;
//   }

//   // ignore: non_constant_identifier_names
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: get_student_attendence(),
//       builder: (_,snapshot){
//       if(snapshot.connectionState == ConnectionState.waiting){
//         return const Center(
//           child: Text("loading..."),
//         );
//       }
//       else
//       {
//         var list = snapshot.data! as List;
//         return ListView.builder(
//           itemCount: length,
//           itemBuilder: (_,index){
//             return ListTile(
//               title: Text(list[index].data["title"]),
//             );
//         });
//       }
//     });
//   }
// }
class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (teacherinfolist.isEmpty) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("No faculty found"),
            )
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: teacherinfolist.length,
              itemBuilder: (context, index) => ChatCard(
                chat: teacherinfolist[index],
                press: () {
                }, clicked: () async {
                   await DeleteAlert(context, teacherinfolist[index].document.toString(),
                                     teacherinfolist[index].courses,teacherinfolist[index]);
                  //teacherinfolist.removeAt(index);
                  
                  setState(() { }); },
              ),
            ),
          )
        ],
      );
    }
  }
}

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton({
    Key? key,
    this.isFilled = true,
    required this.press,
    required this.text,
  }) : super(key: key);

  final bool isFilled;
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.white),
      ),
      elevation: isFilled ? 2 : 0,
      color: isFilled ? Colors.white : Colors.transparent,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? kContentColorLightTheme : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
    required this.clicked

  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;
  final VoidCallback clicked;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromRGBO(191, 230, 245, 1),
                  foregroundColor: Colors.blue,
                  foregroundImage: AssetImage(widget.chat.image),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.chat.courses.join(" "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      ButtonTheme(
                        child: ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 70.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: widget.clicked,
                                textColor: Color.fromARGB(255, 255, 255, 255),
                                color: Color.fromARGB(255, 255, 2, 2),
                                child: Text("Remove"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> DeleteAlert(
    BuildContext context, String tech_docid, List<dynamic> courses,Chat temp) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Teacher"),
          actions: [
            Column(
              children: [
                const Text(
                    "Permanently Delete Faculty (The data would be lost permanently)"),
                const SizedBox(
                  height: 10,
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
                        onTap: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          for (int i = 0; i < courses.length; i++) {
                            await FirebaseFirestore.instance
                                .collection("institute")
                                .doc(user!.uid)
                                .collection(courses[i])
                                .doc("courseinfo")
                                .update({
                              "teacher_list":
                                  FieldValue.arrayRemove([tech_docid])
                            });
                          }
                          teacherinfolist.remove(temp);
                          await FirebaseFirestore.instance.collection("user_teacher").doc(tech_docid).update({"accept":FieldValue.delete()});
                          Future.delayed(Duration.zero, () {
                            Navigator.pop(context);
                          });
                        },
                        borderRadius: BorderRadius.circular(14.0),
                        child: Center(
                          child: Text(
                            "Delete",
                            style: heading5.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      });
}

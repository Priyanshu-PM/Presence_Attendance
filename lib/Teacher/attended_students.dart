import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:presence/Teacher/teacherhome.dart';
import 'onclick_list2.dart';

// ignore: use_key_in_widget_constructors
List<Chat> myrequestlist1 = [];

class attended_stud extends StatefulWidget {
  final String subname;
  final String qr;
  const attended_stud({Key? key, required this.subname, required this.qr})
      : super(key: key);
  @override
  _attended_students createState() => _attended_students();
}

List<dynamic> boollist = [];
List<dynamic> doclist = [];
String currentqrdoc = "";
String currentinsdoc = "";
String globalsub = "";

class _attended_students extends State<attended_stud> {
  Future<void> attendedstdlist() async {
    myrequestlist1.clear();
    boollist.clear();
    doclist.clear();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    String inscode = ds.get("inscode");
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    for (int i = 0; i < qs.size; i++) {
      try {
        if (qs.docs[i]["code"] == inscode) {
          currentinsdoc = qs.docs[i].id;
          QuerySnapshot currentlec = await FirebaseFirestore.instance
              .collection("institute")
              .doc(qs.docs[i].id)
              .collection(widget.subname)
              .get();
          for (int x = 0; x < currentlec.size; x++) {
            try {
              if (currentlec.docs[x]["qrstr"] == widget.qr) {
                currentqrdoc = currentlec.docs[x].id;
                List<dynamic> attend = currentlec.docs[x]["attend"];
                boollist = attend;
                List<dynamic> students = currentlec.docs[x]["total_students"];
                doclist = students;
                List<String> stdnames;

                for (int v = 0; v < students.length; v++) {
                  DocumentSnapshot std = await FirebaseFirestore.instance
                      .collection("user_student")
                      .doc(students[v])
                      .get();
                  myrequestlist1.add(Chat(
                      name: std.get("name"),
                      attended: attend[v],
                      docid: students[v],
                      roll: std.get("roll")));
                }
              }
            } catch (e) {
              continue;
            }
          }
        }
      } catch (e) {}
    }
    myrequestlist1.sort((a,b)=>
      a.roll.compareTo(b.roll));
    setState(() {});
  }

  Future<void> savelist() async {
    await FirebaseFirestore.instance
        .collection("institute")
        .doc(currentinsdoc)
        .collection(widget.subname)
        .doc(currentqrdoc)
        .update({'accept': false, 'attend': boollist});

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const teacher()));
      // Your Code
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Attendance saved successfully"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attendedstdlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Alert"),
                            content:
                                Text("Lecture attendance will be discarded"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("institute")
                                        .doc(currentinsdoc)
                                        .collection(widget.subname)
                                        .doc(currentqrdoc)
                                        .delete();
                                    print("Success");
                                    SchedulerBinding.instance!
                                        .addPostFrameCallback((_) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const teacher()));
                                      // Your Code
                                    });
                                  },
                                  child: Text("Confirm")),
                              TextButton(
                                  onPressed: () {
                                    SchedulerBinding.instance!
                                        .addPostFrameCallback((_) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Text("cancel"))
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.arrow_back));
            },
          ),
          title: Text('Lecture List'),
          actions: [
            TextButton(onPressed: () => savelist(), child: Text("Save"))
          ],
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ChatScreen2(
                subname: widget.subname,
              ),
            ),
          ),
        ));
  }
}

// ignore: use_key_in_widget_constructors
class ChatScreen2 extends StatefulWidget {
  final String subname;

  const ChatScreen2({Key? key, required this.subname}) : super(key: key);
  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(subname: widget.subname),
    );
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

class Body extends StatefulWidget {
  final String subname;

  const Body({Key? key, required this.subname}) : super(key: key);
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Future<void> fetchattenddance() async {
  //   myrequestlist.clear();
  //   User? user = FirebaseAuth.instance.currentUser;
  //   DocumentSnapshot ds = await FirebaseFirestore.instance
  //       .collection("user_teacher")
  //       .doc(user!.uid)
  //       .get();
  //   String inscode = ds.get("inscode");
  //   QuerySnapshot qs =
  //       await FirebaseFirestore.instance.collection("institute").get();
  //   for (int i = 0; i < qs.size; i++) {
  //     try {
  //       if (qs.docs[i]["code"] == inscode) {
  //         print("ins found");
  //         String docstr = qs.docs[i].id;
  //         QuerySnapshot qs1 = await FirebaseFirestore.instance
  //             .collection("institute")
  //             .doc(docstr)
  //             .collection(widget.subname)
  //             .get();
  //         for (int x = 0; x < qs1.size; x++) {
  //           print("inside for");
  //           print(widget.subname);
  //           try {
  //             String temp = qs1.docs[x]["qrstr"];
  //             List<dynamic> templist1 = qs1.docs[x]["total_students"];
  //             List<dynamic> templist2 = qs1.docs[x]["attend"];
  //             int asum = 0;
  //             int tsum = 0;
  //             if (!templist1.isEmpty) {
  //               tsum = templist1.length;
  //               for (int c = 0; c < templist2.length; c++) {
  //                 if (templist2[c] == true) {
  //                   asum = asum + 1;
  //                 }
  //               }
  //             }
  //             double avg = (asum / tsum) * 100;
  //             String tes = 'Average Attendance: ' +
  //                 templist1.length.toString() +
  //                 '/' +
  //                 templist2.length.toString();
  //             myrequestlist.add(Chat(
  //                 val: avg.toInt(), TimStp: qs1.docs[x]["timestp"], tes: tes));
  //           } catch (e) {
  //             print(e);
  //             continue;
  //           }
  //         }
  //       }
  //     } catch (e) {}
  //   }
  //   setState(() {});
  //   print(myrequestlist);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchattenddance();
  }

  @override
  Widget build(BuildContext context) {
    if (myrequestlist1.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [CircularProgressIndicator()],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myrequestlist1.length,
              itemBuilder: (context, index) => ChatCard(
                chat: myrequestlist1[index],
                press: () {},
                onclicked: (bool value) {
                  Chat temp = myrequestlist1[index];
                  temp.attended = value;
                  myrequestlist1[index] = temp;
                  boollist[index] = value;
                  print(boollist);
                  setState(() {});
                },
              ),
            ),
          )
        ],
      );
    }
  }
}

// List<dynamic> myrequestlist = [
//   Chat(attended: true, name: "sujyot"),
//   Chat(attended: false, name: "sakshi"),
//   Chat(attended: true, name: "ayush"),
//   Chat(attended: false, name: "sarthak"),
// ];

class Chat {
  final String name;
  bool attended;
  String roll;
  final String docid;
  Chat({
    required this.roll,
    required this.name,
    required this.attended,
    required this.docid,
  });
}

/*Future<void> getdatafromfirestore() async {
  int i = 0;
  QuerySnapshot qs =
      await FirebaseFirestore.instance.collection("user_student").get();
  for (i = 0; i < qs.size; i++) {
    print(qs.docs[i]['name']);
    myrequestlist.add(Chat(
      name: qs.docs[i]["name"],
      lastMessage: qs.docs[i]["roll"],
      image: "image/Presence_name.png",
    ));
  }
  print(myrequestlist);
}*/
typedef voidcallbackbool = void Function(bool value);

class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
    required this.onclicked,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;
  final voidcallbackbool onclicked;
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settoggle();
  }

  void settoggle() {
    toggle = widget.chat.attended;
    setState(() {});
  }

  late bool toggle;
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
                new Image.asset(
                  'assets/images/lecture.png',
                  width: 70,
                  height: 60,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.chat.roll,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      // ignore: prefer_const_constructors
                    ]),
              ),
            ),
            Switch(
                activeColor: Color.fromRGBO(2, 217, 42, 1),
                inactiveThumbColor: Color.fromRGBO(237, 5, 5, 1),
                inactiveTrackColor: Color.fromRGBO(250, 105, 105, 1),
                value: widget.chat.attended,
                onChanged: widget.onclicked)
          ],
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

const kDefaultPadding = 8.0;

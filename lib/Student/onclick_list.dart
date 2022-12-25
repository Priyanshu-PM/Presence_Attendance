import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors

class MainPage2 extends StatefulWidget {
  final String subname;

  const MainPage2({Key? key, required this.subname}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lecture List'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ChatsScreen(
                subname: widget.subname,
              ),
            ),
          ),
        ));
  }
}

// ignore: use_key_in_widget_constructors
class ChatsScreen extends StatefulWidget {
  final String subname;

  const ChatsScreen({Key? key, required this.subname}) : super(key: key);
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
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
  const Body({Key? key, required this.subname}) : super(key: key);
  final String subname;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> fetchattenddance() async {
    myrequestlist.clear();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_student")
        .doc(user!.uid)
        .get();
    String inscode = ds.get("inscode");
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    for (int i = 0; i < qs.size; i++) {
      try {
        if (qs.docs[i]["code"] == inscode) {
          print("ins found");
          String docstr = qs.docs[i].id;
          QuerySnapshot qs1 = await FirebaseFirestore.instance
              .collection("institute")
              .doc(docstr)
              .collection(widget.subname)
              .get();
          for (int x = 0; x < qs1.size; x++) {
            print("inside for");
            print(widget.subname);
            try {
              String temp = qs1.docs[x]["qrstr"];
              List<dynamic> templist1 = qs1.docs[x]["total_students"];
              List<dynamic> templist2 = qs1.docs[x]["attend"];

              for (int j = 0; j < templist1.length; j++) {
                print("inside another for");
                if (user.uid == templist1[j]) {
                  print("user found");
                  if (templist2[j] == true) {
                    print("match found");
                    myrequestlist.add(Chat(
                      attended: true,
                      TimStp: qs1.docs[x]["timestp"],
                    ));
                  } else {
                    myrequestlist.add(Chat(
                      attended: false,
                      TimStp: qs1.docs[x]["timestp"],
                    ));
                  }
                }
              }
              myrequestlist.add(Chat(
                attended: false,
                TimStp: qs1.docs[i]["timestp"],
              ));
            } catch (e) {
              print(e);
              continue;
            }
          }
        }
      } catch (e) {}
    }
    setState(() {});
    print(myrequestlist);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchattenddance();
  }

  @override
  Widget build(BuildContext context) {
    if (myrequestlist.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: myrequestlist.length,
              itemBuilder: (context, index) => ChatCard(
                chat: myrequestlist[index],
                press: () {},
              ),
            ),
          )
        ],
      );
    }
  }
}

List<dynamic> myrequestlist = [];

class Chat {
  final Timestamp TimStp;
  final String name, datetext, stat, tes;
  final bool attended;
  final int val;

  Chat({
    this.name = '',
    this.datetext = 'Lecture taken at: ',
    this.stat = '',
    this.attended = false,
    this.tes = 'Average Attendance: ',
    this.val = 0,
    required this.TimStp,
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

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.blue.withOpacity(0.4),
      splashColor: Colors.green.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      onTap: press,
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        DateFormat.yMMMEd().format(chat.TimStp.toDate()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      if (chat.attended == false) ...[
                        ButtonTheme(
                          minWidth: 70.0,
                          height: 40.0,
                          child: RaisedButton(
                            onPressed: () {},
                            textColor: Color.fromARGB(255, 255, 255, 255),
                            color: Color.fromARGB(255, 255, 1, 1),
                            child: Text("Not attended"),
                          ),
                        )
                      ] else ...[
                        ButtonTheme(
                          minWidth: 70.0,
                          height: 40.0,
                          child: FlatButton(
                            onPressed: () {},
                            textColor: Color.fromARGB(255, 255, 255, 255),
                            color: Color.fromARGB(255, 9, 255, 5),
                            child: Text("Attended"),
                          ),
                        )
                      ],
                      const SizedBox(height: 10),
                      Text(
                        DateFormat("kk:mm:a").format(chat.TimStp.toDate()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
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

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

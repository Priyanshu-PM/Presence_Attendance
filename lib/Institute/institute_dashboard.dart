// ignore: avoid_web_libraries_in_flutter
// ignore_for_file: unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presence/Institute/navigationDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presence/Teacher/otp_and_qr.dart';
import "Functions_ins.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: Connection_checker()));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  static Image title = Image.asset("image/Presence_name.png");

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    code_display();
    super.initState();
    get_all_teachers();
    get_all_students();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

Future<void> code_display() async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot ds = await FirebaseFirestore.instance
      .collection("institute")
      .doc(user!.uid)
      .get();
  print(ds.get("code"));
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        // endDrawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: 
          Image.asset(
            'image/Presence_name.png',
            height: 40,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search),
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ChatsScreen(),
            ),
          ),
        ));
  }
}

class Connection_checker extends StatelessWidget {
  Connection_checker({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCi8Mt0qh4bpLl_sNFs6ZUW-LCOqm9ryb4',
          appId: '1:267084318059:web:3af05c13deb7bb79f4782e',
          messagingSenderId: '267084318059',
          projectId: 'presence-d332b'));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("error...." + snapshot.error.toString()),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          } else {
            return const Scaffold(
              body: Center(
                child: Text("Something happened...."),
              ),
            );
          }
        });
  }
}

List<dynamic> myrequestlist1 = [];
List<dynamic> myrequestlist2 = [];

class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;
  final String document;
  final List<dynamic> courses;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false,
    this.document = "",
    required this.courses,
  });
}

void check_student_or_teacher() {}

class studentBody extends StatefulWidget {
  @override
  State<studentBody> createState() => _studentBodyState();
}

class _studentBodyState extends State<studentBody> {
  Future<void> getdatafromfirestore_s() async {
    myrequestlist1.clear();
    int i = 0;
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("user_student").get();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("institute")
        .doc(user!.uid)
        .get();
    for (i = 0; i < qs.size; i++) {
      try {
        if (ds.get("code") == qs.docs[i]["inscode"]) {
          if (qs.docs[i]['accept'] == false) {
            print(qs.docs[i]['name']);
            myrequestlist1.add(Chat(
                name: qs.docs[i]["name"],
                lastMessage: qs.docs[i]["roll"],
                image: "assets/images/student.png",
                document: qs.docs[i].id.toString(),
                courses: qs.docs[i]["course_title"]));
          }
        }
      } catch (e) {
        continue;
      }
    }
    print(myrequestlist1);
    setState(() {
      checkonlyinternet();
    });
  }

  void donothing() {
    // getdatafromfirestore_s();
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatafromfirestore_s();
    donothing();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (myrequestlist1.isEmpty) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("No request found"),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: myrequestlist1.length,
                itemBuilder: (context, index) => ChatCard(
                  chat: myrequestlist1[index],
                  pressaccept: () async {
                    DocumentSnapshot ds = await FirebaseFirestore.instance
                        .collection("user_student")
                        .doc(myrequestlist1[index].document.toString())
                        .get();
                    List<dynamic> ctitle = ds.get("course_title");
                    List<dynamic> templist = [];
                    User? user = FirebaseAuth.instance.currentUser;
                    templist.add(myrequestlist1[index].document.toString());
                    for (int x = 0; x < ctitle.length; x++) {
                      await FirebaseFirestore.instance
                          .collection("institute")
                          .doc(user!.uid)
                          .collection(ctitle[x])
                          .doc("courseinfo")
                          .update({
                        "student_list": FieldValue.arrayUnion(templist)
                      });
                    }
                    await FirebaseFirestore.instance
                        .collection("user_student")
                        .doc(myrequestlist1[index].document.toString())
                        .update({'accept': true});
                    myrequestlist1.removeAt(index);
                  },
                  pressreject: () async {
                    await FirebaseFirestore.instance
                        .collection("user_student")
                        .doc(myrequestlist1[index].document.toString())
                        .update({"accept": FieldValue.delete()});
                    myrequestlist1.removeAt(index);
                  },
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}

class teacherBody extends StatefulWidget {
  @override
  State<teacherBody> createState() => _teacherBodyState();
}

class _teacherBodyState extends State<teacherBody> {
  Future<void> getdatafromfirestore_t() async {
    myrequestlist2.clear();
    int i = 0;
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("user_teacher").get();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("institute")
        .doc(user!.uid)
        .get();
    for (i = 0; i < qs.size; i++) {
      try {
        if (ds.get("code") == qs.docs[i]["inscode"]) {
          if (qs.docs[i]['accept'] == false) {
            print(qs.docs[i]['name']);
            myrequestlist2.add(Chat(
                name: qs.docs[i]["name"],
                lastMessage: qs.docs[i]["contact"],
                image: "assets/images/teacher.png",
                document: qs.docs[i].id.toString(),
                courses: qs.docs[i]["course_title"]));
          }
        }
      } catch (e) {
        continue;
      }
    }
    print(myrequestlist2);
    setState(() {
      checkonlyinternet();
    });
  }

  void donothing() {
    // getdatafromfirestore_t();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatafromfirestore_t();
    donothing();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (myrequestlist2.isEmpty) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("No request found"),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: myrequestlist2.length,
                itemBuilder: (context, index) => ChatCard(
                    chat: myrequestlist2[index],
                    pressaccept: () async {
                      DocumentSnapshot ds = await FirebaseFirestore.instance
                          .collection("user_teacher")
                          .doc(myrequestlist2[index].document.toString())
                          .get();
                      List<dynamic> ctitle = ds.get("course_title");
                      print(ds.get("course_title"));
                      List<dynamic> templist = [];
                      User? user = FirebaseAuth.instance.currentUser;
                      templist.add(myrequestlist2[index].document.toString());
                      for (int x = 0; x < ctitle.length; x++) {
                        await FirebaseFirestore.instance
                            .collection("institute")
                            .doc(user!.uid)
                            .collection(ctitle[x])
                            .doc("courseinfo")
                            .update({
                          "teacher_list": FieldValue.arrayUnion(templist)
                        });
                      }
                      await FirebaseFirestore.instance
                          .collection("user_teacher")
                          .doc(myrequestlist2[index].document.toString())
                          .update({'accept': true});
                      myrequestlist2.removeAt(index);
                    },
                    pressreject: () async {
                      await FirebaseFirestore.instance
                          .collection("user_teacher")
                          .doc(myrequestlist1[index].document.toString())
                          .update({"accept": FieldValue.delete()});
                      myrequestlist2.removeAt(index);
                    }
                    // Mylist()
                    ),
              ),
            )
          ],
        ),
      );
    }
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.pressaccept,
    required this.pressreject,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback pressaccept;
  final VoidCallback pressreject;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                  foregroundImage: AssetImage(chat.image),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      //SizedBox(height: 8),
                      Text(
                        chat.courses.join(" "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      ButtonTheme(
                        child: ButtonBar(
                          // alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 70.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: pressaccept,
                                textColor: Color.fromARGB(255, 255, 255, 255),
                                color: Color.fromARGB(255, 38, 204, 16),
                                child: Text("Accept"),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 70.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: pressreject,
                                textColor: Color.fromARGB(255, 255, 255, 255),
                                color: Color.fromARGB(255, 255, 1, 1),
                                child: Text("Reject"),
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

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 5.0;

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

// ignore: use_key_in_widget_constructors
class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: insdashboardlist[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded), label: "Students"),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_moderator_rounded), label: "Teacher"),
      ],
    );
  }
}

List<Widget> insdashboardlist = <Widget>[studentBody(), teacherBody()];

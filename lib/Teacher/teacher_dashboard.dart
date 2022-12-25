import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:presence/Teacher/Functions_teacher.dart';
import 'package:presence/Teacher/navigationDrawer.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:presence/Teacher/otp_and_qr.dart';
import 'package:presence/Teacher/qrgenerator.dart';
import 'package:presence/Teacher/onclick_list.dart';
import 'package:presence/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: Connection_checker()));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  static String title = "Faculty Dashboard";

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

class _MainPageState extends State<MainPage> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    checkglobalinternet();
  }
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ChatsScreen(),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          checkonlyinternet();
          hasinternetglobal ? showDialog(
              context: context, builder: (BuildContext context) => listcart()) : showDialog(
              context: context, builder: (BuildContext context) => 
              AlertDialog(title: Text("No internet connection")
              ,actions: [TextButton(onPressed: (){
                SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      // Your Code
    });
              }, child: Text("Back"))],));
        },
        tooltip: 'Take attendance',
        child: const Icon(Icons.qr_code_rounded),
      ), //() {
      //   _navigate();
      // },
    );
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

// ignore: use_key_in_widget_constructors
class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
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

double minclasses = 0;
double maxclasses = 100;
double valueAt = 0;
// ignore: non_constant_identifier_names
double attend_percent = (maxclasses - (minclasses - valueAt)) / maxclasses;
String email = "abcdef@gmail.com";

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> FetchAverageAttendanceofstudent() async {
    T_DASH_LIST.clear();
    teachercourselist.clear();
    courseattendlist.clear();
    CourseTotallist.clear();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    String inscode = ds.get("inscode");
    teachercourselist = ds.get("course_title");
    List<dynamic> templist = [];
    int count = 0;
    int temp = 0;
    int temp2 = 0;
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    for (int i = 0; i < qs.size; i++) {
      try {
        if (qs.docs[i]["code"] == inscode) {
          String docstr = qs.docs[i].id;
          for (int x = 0; x < teachercourselist.length; x++) {
            count = 0;
            temp = 1;
            temp2 = 0;
            QuerySnapshot qs1 = await FirebaseFirestore.instance
                .collection("institute")
                .doc(docstr)
                .collection(teachercourselist[x])
                .get();
            DocumentSnapshot df = await FirebaseFirestore.instance
                .collection("institute")
                .doc(docstr)
                .collection(teachercourselist[x])
                .doc("courseinfo")
                .get();
            int totalstd = 0;
            int totalatt = 0;
            for (int n = 0; n < qs1.size; n++) {
              print("inside a doc" + teachercourselist[x]);
              try {
                templist = qs1.docs[n]["attend"];
                print("fetched the attend list " + templist.length.toString());
                temp = templist.length;
                temp2 = templist.length;
                //print(templist.length);
                for (int c = 0; c < templist.length; c++) {
                  if (templist[c] == true) {
                    count = count + 1;
                    print("count");
                  }
                }
                totalstd = totalstd + temp2;
                print(totalstd);
              } catch (e) {
                print("no data found in " + teachercourselist[x]);
                print(e);
              }
            }
            if (totalstd == 0) {
              T_DASH_LIST.add(TeacherDashboardCart(
                  val: (count / 1) * 100,
                  name: teachercourselist[x],
                  lastMessage: "$count/$totalstd"));
            }
            if (totalstd != 0) {
              T_DASH_LIST.add(TeacherDashboardCart(
                  val: (count / totalstd) * 100,
                  name: teachercourselist[x],
                  lastMessage: "$count/$totalstd"));
            }

            courseattendlist.add(count);
            CourseTotallist.add(totalstd);
          }
        }
      } catch (e) {
        print("outer " + e.toString());
      }
    }
    print(T_DASH_LIST);
    cal_pointer_value();
    setState(() {checkonlyinternet();});
  }

  Future<void> cal_pointer_value() async {
    print("calling calculate functin");
    int sum = 0;
    int attend = 0;
    for (int i = 0; i < courseattendlist.length; i++) {
      sum += courseattendlist[i];
    }
    for (int i = 0; i < CourseTotallist.length; i++) {
      attend += CourseTotallist[i];
    }
    print(sum.toString());
    print(attend.toString());
    if (attend == 0) {
      attend = 1;
    }
    double percent = sum / attend * 100;
    valueAt = percent;
    print("Present value " + percent.toString());
    setState(() {
      checkonlyinternet();
    });
  }

  bool checkfinal = false;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    print("called set state");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchAverageAttendanceofstudent();
  }

  @override
  Widget build(BuildContext context) {
    print(T_DASH_LIST.length);
    return RefreshIndicator(
        child: Column(
          children: [
            
            SizedBox(
              height: 200,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                      minimum: minclasses,
                      maximum: maxclasses,
                      showLabels: false,
                      showTicks: false,
                      radiusFactor: 0.8,
                      axisLineStyle: const AxisLineStyle(
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromRGBO(212, 228, 252, 1),
                          thickness: 20),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: valueAt,
                            cornerStyle: CornerStyle.bothCurve,
                            width: 20,
                            sizeUnit: GaugeSizeUnit.logicalPixel,
                            gradient: const SweepGradient(colors: <Color>[
                              Color.fromRGBO(67, 0, 161, 1),
                              // Color.fromRGBO(252, 252, 5, 1),
                              Color.fromRGBO(125, 0, 171, 1)
                            ], stops: <double>[
                              0.25,
                              0.75
                            ])),
                        MarkerPointer(
                            value: valueAt,
                            enableDragging: true,
                            markerHeight: 24,
                            markerWidth: 24,
                            markerType: MarkerType.circle,
                            color: const Color(0xFF753A88),
                            borderWidth: 3,
                            borderColor: Colors.white54)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            angle: 90,
                            axisValue: 5,
                            positionFactor: 0.2,
                            widget: Text(valueAt.toInt().toString() + "%",
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFCC2B5E))))
                      ])
                ],
                enableLoadingAnimation: true,
                animationDuration: 3200,
              ),
            ),
            Text('Average Attendance',
                maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w500)),
                            
            Expanded(
              child: ListView.builder(
                itemCount: T_DASH_LIST.length,
                itemBuilder: (context, index) => ChatCard(
                  chat: T_DASH_LIST[index],
                  press: () {},
                ),
              ),
            )
          ],
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          setState(() {
            checkglobalinternet();
            FetchAverageAttendanceofstudent();
          });
        });
  }
}

/*class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}*/
/*class _BodyState extends State<Body> {
  void donothing() {
    getdatafromfirestore();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    donothing();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        const radial_guage(),
        Expanded(
          child: ListView.builder(
            itemCount: myrequestlist.length,
            itemBuilder: (context, index) => ChatCard(
              chat: myrequestlist[index],
              press: () {},
              // Mylist()
            ),
          ),
        )
      ],
    ),
  );
}
*/
// ignore: camel_case_types

List<dynamic> myrequestlist = [];

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
class Subjectcart extends StatelessWidget {
  const Subjectcart({Key? key, required this.courselist}) : super(key: key);
  final List<dynamic> courselist;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final TeacherDashboardCart chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.blue.withOpacity(0.4),
      splashColor: Colors.green.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => MainPage1(
              subname: chat.name,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/subject1.png'),
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
                        chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      FAProgressBar(
                        direction: Axis.horizontal,
                        currentValue: chat.val.toInt(),
                        displayText: '%',
                        size: 17,
                        progressColor: const Color(0xFF753A88),
                        backgroundColor: Color.fromRGBO(212, 228, 252, 1),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Points : "+chat.lastMessage,
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

const kDefaultPadding = 10.0;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:presence/Student/Student_functions.dart';
import 'package:presence/Student/navigationDrawer.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:presence/Student/onclick_list.dart';
import 'package:presence/Teacher/otp_and_qr.dart';
import 'package:presence/Student/qrscanner.dart';
import 'package:presence/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:presence/Student/onclick_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: Connection_checker()));
}

// ignore: use_key_in_widget_constructors
class MyStudentApp extends StatelessWidget {
  static String title = "Student Dashboard";

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
              
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ChatsScreen(),
            ),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () { 
            checkonlyinternet();
            hasinternetglobal ? 
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Select type"),
                  content: Text("select method to proceed"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => qrscanner()));
                          });
                        },
                        child: Text("Scan")),
                    TextButton(
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => listcart()));
                            ;
                          });
                        },
                        child: Text("Enter code"))
                  ],
                );
              }): showDialog(
              context: context, builder: (BuildContext context) => 
              AlertDialog(title: Text("No internet connection")
              ,actions: [TextButton(onPressed: (){
                SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      // Your Code
    });
              }, child: Text("Back"))],));}, //() {
          //   _navigate();
          // },
          tooltip: 'Give attendance',
          child: const Icon(Icons.qr_code_rounded),
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
            return MyStudentApp();
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

double minclasses = 0;
double maxclasses = 100;
double valueAt = 30;
// ignore: non_constant_identifier_names
double attend_percent = (maxclasses - (minclasses - valueAt)) / maxclasses;
String email = "abcdef@gmail.com";

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<void> Fetchmyaverageattendance() async {
    CourseTotallist.clear();
    courseattendlist.clear();
    mysubwiseattendlist.clear();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_student")
        .doc(user!.uid)
        .get();
    String inscode = ds.get("inscode");
    studentcourselist = ds.get("course_title");
    int myindex;
    int temp1 = 0;
    int temp2 = 0;
    List<dynamic> templist1 = [];
    List<dynamic> templist2 = [];
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    for (int i = 0; i < qs.size; i++) {
      try {
        if (qs.docs[i]["code"] == inscode) {
          // print("institute found");
          String docstr = qs.docs[i].id;
          // print("id retrived");
          for (int x = 0; x < studentcourselist.length; x++) {
            temp1 = 0;
            temp2 = 0;
            // print("got documents");
            QuerySnapshot qs1 = await FirebaseFirestore.instance
                .collection("institute")
                .doc(docstr)
                .collection(studentcourselist[x])
                .get();
            CourseTotallist.add(0);
            courseattendlist.add(0);
            for (int d = 0; d < qs1.size; d++) {
              // print("control in for");
              try {
                templist1 = qs1.docs[d]["total_students"];
                templist2 = qs1.docs[d]["attend"];
                print(templist2);

                for (int n = 0; n < templist1.length; n++) {
                  if (templist1[n] == user.uid) {
                    print("std found in " + studentcourselist[x].toString());
                    // CourseTotallist.add(0);
                    // courseattendlist.add(0);
                    if (templist2[n] == true) {
                      print("inside true");
                      courseattendlist[x] = courseattendlist[x] + 1;
                      CourseTotallist[x] = CourseTotallist[x] + 1;
                    }
                    if (templist2[n] == false) {
                      CourseTotallist[x] = CourseTotallist[x] + 1;
                    }
                    print(courseattendlist);
                    print(CourseTotallist);
                  }
                }
                temp1 = courseattendlist[x];
                temp2 = CourseTotallist[x];

                print("course attend" + courseattendlist.toString());
                // print("control after for");
              } catch (e) {
                print(e);
                print("control in catch");
              }
            }
            print("control going here");
            Displayval.add(0);
            int temp3 = CourseTotallist[x];
            if (CourseTotallist[x] == 0) {
              temp3 = 1;
            }
            Displayval[x] = ((courseattendlist[x] / temp3) * 100).toInt();
            print(courseattendlist);
            print(CourseTotallist);

            String lastmsg = "Classes Attended $temp1/$temp2";
            print("adding to list");
            mysubwiseattendlist.add(Chat_s(
                val: Displayval[x],
                name: studentcourselist[x],
                lastMessage: lastmsg));
          }
        }
      } catch (e) {
        print(e);
      }
    }
    cal_pointer_value();
    setState(() {});
    print("called set state");
    print(mysubwiseattendlist);
    print(studentcourselist);
  }

  Future<void> cal_pointer_value() async {
    print("calling calculate function");
    int sum = 0;
    int attend = 0;
    for (int i = 0; i < courseattendlist.length; i++) {
      sum += courseattendlist[i];
    }
    for (int i = 0; i < CourseTotallist.length; i++) {
      attend += CourseTotallist[i];
    }
    if (attend == 0) {
      attend = 1;
    }
    double percent = sum / attend * 100;
    valueAt = percent;
    print(percent);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fetchmyaverageattendance();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scaffold(
          body: Column(
            children: [
              Text('Average Attendance',
                  style: TextStyle(
                      fontSize: 25.0, height: 2.0, color: Colors.black)),
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
                        ]),
                  ],
                  enableLoadingAnimation: true,
                  animationDuration: 3200,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mysubwiseattendlist.length,
                  itemBuilder: (context, index) => ChatCard(
                    chat: mysubwiseattendlist[index],
                    press: () {},
                  ),
                ),
              )
            ],
          ),
        ),
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
          setState(() {
            checkglobalinternet();
            Fetchmyaverageattendance();
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
*/
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Column(
//       children: [
//         const radial_guage(),
//         Expanded(
//           child: ListView.builder(
//             itemCount: myrequestlist.length,
//             itemBuilder: (context, index) => ChatCard(
//               chat: myrequestlist[index],
//               press: () {},
//               // Mylist()
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

// ignore: camel_case_types

List<dynamic> myrequestlist = [];

// class Chat {
//   final String name, lastMessage, stat;
//   final bool isActive;
//   final int val;

//   Chat({
//     this.name = '',
//     this.lastMessage = 'Classes Attended 15/30',
//     this.stat = '',
//     this.isActive = false,
//     required this.val,
//   });
// }

// List chatsData = [
//   Chat(
//     name: "Data Structure",
//     stat: "5/30",
//     val: 80,
//   ),
//   Chat(
//     name: "OS",
//     stat: "13/30",
//     val: 60,
//   ),
//   Chat(
//     name: "C++",
//     stat: "15/30",
//     val: 40,
//   ),
//   Chat(
//     name: "Java",
//     val: 70,
//   ),
//   Chat(
//     name: "Linux",
//     val: 90,
//   ),
//   Chat(
//     name: "ABC",
//     val: 80,
//   ),
//   Chat(
//     name: "Shirkey",
//     val: 80,
//   ),
//   Chat(
//     name: "S.A Khatri",
//     val: 80,
//   ),
// ];
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

  final Chat_s chat;
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
            builder: (_) => MainPage2(subname: chat.name),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.50),
        child: Row(
          children: [
            Stack(
              children: [
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5),
                      FAProgressBar(
                        direction: Axis.horizontal,
                        currentValue: chat.val,
                        displayText: '%',
                        size: 15,
                        progressColor: const Color(0xFF753A88),
                        backgroundColor: Color.fromRGBO(212, 228, 252, 1),
                      ),
                      SizedBox(height: 10),
                      Text(
                        chat.lastMessage,
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

class listcart extends StatefulWidget {
  const listcart({
    Key? key,
  }) : super(key: key);
  @override
  State<listcart> createState() => _listcartState();
}

// ignore: prefer_typing_uninitialized_variables
class _listcartState extends State<listcart> {
  @override
  Widget build(BuildContext context) {
    String temp = "";
    return AlertDialog(
      title: Text("select course"),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
            itemCount: studentcourselist.length,
            itemBuilder: (context, index) {
              return listselectcart(
                  press: () {}, sub: studentcourselist[index]);
            }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            });
          },
          child: Text("cancel"),
        )
      ],
    );
  }
}

final GlobalKey<FormState> _formKey = GlobalKey();

class listselectcart extends StatelessWidget {
  const listselectcart({
    Key? key,
    required this.press,
    required this.sub,
  }) : super(key: key);

  final String sub;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final qrcodecontroller = new TextEditingController();
    return InkWell(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Enter code"),
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
                            controller: qrcodecontroller,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter code");
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => qrcodecontroller.text = value!,
                            decoration: InputDecoration(
                              hintText: 'Code',
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
                              SchedulerBinding.instance!
                                  .addPostFrameCallback((_) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConfirmQr(
                                            qrcode: qrcodecontroller.text,
                                            sub: sub)));
                                // Your Code
                              });
                              Future.delayed(Duration.zero, () {
                                Navigator.pop(context);
                              });
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
                  )
                ],
              );
              ;
            });
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
                        sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

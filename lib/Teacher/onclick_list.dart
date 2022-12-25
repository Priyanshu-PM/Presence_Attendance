import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import "package:presence/Download_support/mobile.dart"
    if (dart.library.html) 'package:presence/Download_support/web.dart';
import 'package:presence/Student/studenthome.dart';
import 'package:presence/Teacher/Functions_teacher.dart';
import 'onclick_list2.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

String mysubject = "";
String Teachername = "";
// ignore: use_key_in_widget_constructors

class MainPage1 extends StatefulWidget {
  final String subname;

  const MainPage1({Key? key, required this.subname}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage1> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    checkglobalinternet();
  }

  @override
  Widget build(BuildContext context) {
    mysubject = widget.subname;
    return Scaffold(
        appBar: AppBar(
          title: Text('Lecture List'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          actions: [
            IconButton(
                tooltip: "Attendance report",
                onPressed: () {
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => buildpdfandsave()));
                    // Your Code
                  });
                },
                icon: Icon(Icons.picture_as_pdf,
                    color: Color.fromRGBO(194, 16, 16, 1))),
            IconButton(
                tooltip: "Lecture list",
                onPressed: () {
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => buildpdfandsave2()));
                    // Your Code
                  });
                },
                icon: Icon(
                  Icons.list_alt_sharp,
                  color: Color.fromRGBO(194, 16, 16, 1),
                ))
          ],
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
        side: const BorderSide(color: Colors.white),
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
  Future<void> fetchattenddance() async {
    myrequestlist.clear();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    Teachername = ds.get("name");
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
              .orderBy("timestp", descending: true)
              .get();
          for (int x = 0; x < qs1.size; x++) {
            print("inside for");
            print(widget.subname);
            try {
              String temp = qs1.docs[x]["qrstr"];
              List<dynamic> templist1 = qs1.docs[x]["total_students"];
              List<dynamic> templist2 = qs1.docs[x]["attend"];
              int asum = 0;
              int tsum = 0;
              if (!templist1.isEmpty) {
                tsum = templist1.length;
                for (int c = 0; c < templist2.length; c++) {
                  if (templist2[c] == true) {
                    asum = asum + 1;
                  }
                }
              }
              double avg = (asum / tsum) * 100;
              String tes = 'Average Attendance: ' +
                  asum.toString() +
                  '/' +
                  templist2.length.toString();
                  String chatdesc = "";
                  try {
                    chatdesc = qs1.docs[x]["desc"];
                  } catch (e) {
                    chatdesc = "Lecture/Practical";
                  }
              myrequestlist.add(Chat(
                  val: avg.toInt(),
                  TimStp: qs1.docs[x]["timestp"],
                  tes: tes,
                  docstr: qs1.docs[x].id,
                  stat: chatdesc,
                  name: widget.subname,
                  attended: asum.toString(),
                  total: templist2.length.toString()));
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
  final bool isActive;
  final int val;
  final String docstr;
  String total;
  String attended;

  Chat({
    this.name = '',
    this.datetext = 'Lecture taken at: ',
    this.stat = '',
    this.isActive = false,
    this.tes = 'Average Attendance: ',
    required this.val,
    required this.total,
    required this.attended,
    required this.TimStp,
    required this.docstr,
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
      onTap: () async {
        print("navigated");
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => attended_stud_of_lec(
              docstr: chat.docstr,
              subname: chat.name,
              tstmp: chat.TimStp,
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
                      SizedBox(height: 10),
                      Text(
                        DateFormat.yMMMEd().format(chat.TimStp.toDate()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        chat.tes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 4),
                      FAProgressBar(
                        direction: Axis.horizontal,
                        currentValue: chat.val,
                        displayText: '%',
                        size: 17,
                        progressColor: const Color(0xFF753A88),
                        backgroundColor: Color.fromRGBO(212, 228, 252, 1),
                      ),
                      SizedBox(height: 10),
                      Text(
                        chat.datetext +
                            DateFormat("kk:mm:a").format(chat.TimStp.toDate()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      chat.stat.length > 0 ? Text(
                        "Comment : "+chat.stat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ) : Text(
                        "No comment found",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class stdlist {
  
  final String name, roll;
  int attended;

  stdlist({
    required this.name,
    required this.roll,
    required this.attended,
  });
}
const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 5.0;

class buildpdfandsave extends StatefulWidget {
  buildpdfandsave({Key? key}) : super(key: key);

  @override
  State<buildpdfandsave> createState() => _buildpdfandsaveState();
}

class _buildpdfandsaveState extends State<buildpdfandsave> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyCi8Mt0qh4bpLl_sNFs6ZUW-LCOqm9ryb4',
  //         appId: '1:267084318059:web:3af05c13deb7bb79f4782e',
  //         messagingSenderId: '267084318059',
  //         projectId: 'presence-d332b'));

  Future<void> Createpdf() async {
    try {
      PdfDocument pdfdoc = PdfDocument();
      final page = pdfdoc.pages.add();
      PdfStringFormat format = new PdfStringFormat();
//Set the text alignment.
      page.graphics.drawImage(PdfBitmap(await _readImageData('name.png')),
          const Rect.fromLTWH(220, 0, 75, 25));
// page.graphics.drawImage(
      // PdfBitmap(await _readImageData('name.png')),
      // Rect.fromLTWH(190, 10, 40, 20));
      page.graphics.drawString(
          'Attendance Report', PdfStandardFont(PdfFontFamily.helvetica, 18),
          bounds: Rect.fromLTWH(186, 30, 615, 100));
      page.graphics.drawString(
          'Generated through Presence Attendance tracking system',
          PdfStandardFont(PdfFontFamily.helvetica, 8),
          bounds: const Rect.fromLTWH(160, 50, 615, 100));

      page.graphics.drawString(
          "Generated at  : " + new DateTime.now().toString(),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 65, 615, 100));

      page.graphics.drawString('Subject           : ' + mysubject,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 85, 615, 100));

      page.graphics.drawString('Generated by : ' + Teachername,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 105, 615, 100));

      PdfGrid grid = PdfGrid();
      grid.style = PdfGridStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, 12),
          cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

      grid.columns.add(count: 5);
      grid.headers.add(1);

      PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Name';
      header.cells[1].value = 'Enrollment Id';
      header.cells[2].value = 'Attended lectures';
      header.cells[3].value = 'Total lectures';
      header.cells[4].value = 'Average Attendance';
      // late final page2;
      // code to add rows goes here
      // bool second = false;
      // if (Student_list.length > 30) {
      //   page2 = pdfdoc.pages.add();
      //   second = true;
      // }
      int index = 0;
      // database values will go here
      for (int i = 0; i < stdfinallist.length; i++) {
        stdlist temp = stdfinallist[i];
        PdfGridRow row = grid.rows.add();
        row.style =
            PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));
        double value = temp.attended / total * 100;
        row.cells[0].value = temp.name;
        row.cells[1].value = temp.roll;
        row.cells[2].value = temp.attended.toString();
        row.cells[3].value = total.toString();
        row.cells[4].value = value.toInt().toString() + "%";
        row.cells[4].style = value.toInt()>=75 ? PdfGridCellStyle(textBrush: PdfBrushes.green ) : PdfGridCellStyle(textBrush: PdfBrushes.red );
      }

      // for (int i = 0; i < 40; i++) {
      //   PdfGridRow row = grid.rows.add();
      //   row.style =
      //       PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));
      //   double value = Student_list_attended[0] / total * 100;
      //   row.cells[0].value = Student_list_name[0];
      //   row.cells[1].value = Student_list_roll[0].toString();
      //   row.cells[2].value = Student_list_attended[0].toString();
      //   row.cells[3].value = total.toString();
      //   row.cells[4].value = value.toInt().toString() + "%";
      // }

      // PdfGrid grid1 = PdfGrid();
      // grid1.style = PdfGridStyle(
      //     font: PdfStandardFont(PdfFontFamily.helvetica, 12),
      //     cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

      // grid1.columns.add(count: 5);
      // grid1.headers.add(1);

      // PdfGridRow header1 = grid1.headers[0];
      // header1.cells[0].value = 'Name';
      // header1.cells[1].value = 'Enrollment Id';
      // header1.cells[2].value = 'Attended lectures';
      // header1.cells[3].value = 'Total lectures';
      // header1.cells[4].value = 'Average Attendance';

      // // database values will go here
      // for (index; index < Student_list.length; index++) {
      //   PdfGridRow row = grid1.rows.add();
      //   row.style =
      //       PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));
      //   double value = Student_list_attended[index] / total * 100;
      //   row.cells[0].value = Student_list_name[index];
      //   row.cells[1].value = Student_list_roll[index].toString();
      //   row.cells[2].value = Student_list_attended[index].toString();
      //   row.cells[3].value = total.toString();
      //   row.cells[4].value = value.toInt().toString() + "%";
      //   if (Student_list.length > 30) {
      //     index = 30;
      //   }
      // }
      // drawing page 1
      grid.draw(page: page, bounds: const Rect.fromLTWH(0, 130, 0, 0));
      // page.graphics.drawString('Lecturer : ' + Teachername,
      //     PdfStandardFont(PdfFontFamily.helvetica, 12),
      //     bounds: const Rect.fromLTWH(12, 700, 615, 100));

      // drawing page 2
      // grid.draw(page: page2, bounds: const Rect.fromLTWH(0, 130, 0, 0));

      // page.graphics.drawString('Lecturer : ' + Teachername,
      //     PdfStandardFont(PdfFontFamily.helvetica, 12),
      //     bounds: const Rect.fromLTWH(12, 700, 615, 100));
      List<int> bytes = pdfdoc.save();
      pdfdoc.dispose();
      String filename = "Attendance Report : " +
          mysubject +
          " " +
          new DateTime.now().toString() +
          ".pdf";
      saveAndLaunchFile(bytes, filename);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  bool done = false;
  List<stdlist> stdfinallist = [];
  List<dynamic> Student_list = [];
  List<dynamic> Student_list_name = [];
  List<dynamic> Student_list_roll = [];
  List<dynamic> Student_list_attended = [];
  int total = 0;
  Future<void> fetchdetailstoprint() async {
    stdfinallist.clear();
    Student_list.clear();
    Student_list_name.clear();
    Student_list_attended.clear();
    Student_list_roll.clear();
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
          print("ins found");
          String docstr = qs.docs[i].id;
          QuerySnapshot qs1 = await FirebaseFirestore.instance
              .collection("institute")
              .doc(docstr)
              .collection(mysubject)
              .orderBy("timestp")
              .get();
          total = qs1.size - 1;
          DocumentSnapshot ds1 = await FirebaseFirestore.instance
              .collection("institute")
              .doc(docstr)
              .collection(mysubject)
              .doc("courseinfo")
              .get();
          Student_list = ds1.get("student_list");
          Student_list_attended =
              new List<dynamic>.filled(Student_list.length, 0);
          for (int n = 0; n < Student_list.length; n++) {
            DocumentSnapshot tempds = await FirebaseFirestore.instance
                .collection("user_student")
                .doc(Student_list[n])
                .get();
            Student_list_name.add(tempds.get("name"));
            Student_list_roll.add(tempds.get("roll"));
          }
          for (int x = 0; x < qs1.size; x++) {
            print("inside for");
            try {
              List<dynamic> tempstdlist = qs1.docs[x]["total_students"];
              List<dynamic> tempattendlist = qs1.docs[x]["attend"];
              for (int k = 0; k < tempstdlist.length; k++) {
                for (int q = 0; q < Student_list.length; q++) {
                  try {
                    if (tempstdlist[k] == Student_list[q]) {
                      if (tempattendlist[k] == true) {
                        Student_list_attended[q] = Student_list_attended[q] + 1;
                      }
                    }
                  } catch (e) {
                    continue;
                  }
                }
              }
            } catch (e) {
              print(e);
              continue;
            }
          }
        }
      } catch (e) {}
    }
    for(int m=0;m<Student_list.length;m++){
      stdfinallist.add(stdlist(attended:Student_list_attended[m] , name: Student_list_name[m], roll: Student_list_roll[m]));
    }
    stdfinallist.sort((a,b)=>a.roll.compareTo(b.roll));
    done = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdetailstoprint();
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Students Report'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator()
                  // const Icon(
                  //   Icons.download_for_offline_sharp,
                  //   size: 200,
                  //   color: Colors.red,
                  // ),
                  // const SizedBox(
                  //   height: 25,
                  // ),
                  // const Text("Request in process"),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Text("Generating report"),
                  // const SizedBox(
                  //   height: 25,
                  // )
                ]),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Students Report'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.download_done_sharp,
                  size: 200,
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text("Report generated", style: TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 30,
                ),
                Text("Download the report by clicking the button below"),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () => Createpdf(),
                    child: const Text("Print Pdf"))
              ],
            ),
          ));
    }
  }
}

class buildpdfandsave2 extends StatefulWidget {
  buildpdfandsave2({Key? key}) : super(key: key);

  @override
  State<buildpdfandsave2> createState() => _buildpdfandsave2State();
}

class _buildpdfandsave2State extends State<buildpdfandsave2> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyCi8Mt0qh4bpLl_sNFs6ZUW-LCOqm9ryb4',
  //         appId: '1:267084318059:web:3af05c13deb7bb79f4782e',
  //         messagingSenderId: '267084318059',
  //         projectId: 'presence-d332b'));

  Future<void> Createpdf() async {
    try {
      PdfDocument pdfdoc = PdfDocument();
      final page = pdfdoc.pages.add();
      PdfStringFormat format = new PdfStringFormat();
//Set the text alignment.
// page.graphics.drawImage(
      // PdfBitmap(await _readImageData('name.png')),
      // Rect.fromLTWH(190, 10, 40, 20));

      page.graphics.drawImage(PdfBitmap(await _readImageData('name.png')),
          const Rect.fromLTWH(220, 0, 75, 25));
      page.graphics.drawString(
          'Lecture List', PdfStandardFont(PdfFontFamily.helvetica, 18),
          bounds: const Rect.fromLTWH(215, 30, 615, 100));
      page.graphics.drawString(
          'Generated through Presence Attendance tracking system',
          PdfStandardFont(PdfFontFamily.helvetica, 8),
          bounds: const Rect.fromLTWH(160, 50, 615, 100));

      page.graphics.drawString(
          "Generated at  : " + new DateTime.now().toString(),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 65, 615, 100));

      page.graphics.drawString('Subject           : ' + mysubject,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 85, 615, 100));

      page.graphics.drawString('Generated by : ' + Teachername,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 105, 615, 100));

      PdfGrid grid = PdfGrid();
      grid.style = PdfGridStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, 12),
          cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

      grid.columns.add(count: 6);
      grid.headers.add(1);

      PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Lecture Date';
      header.cells[1].value = 'Lecture Time';
      header.cells[2].value = 'Comments';
      header.cells[3].value = 'Total Attandance';
      header.cells[4].value = 'Total Students';
      header.cells[5].value = 'Average Attendance';

      // code to add rows goes here

      if (myrequestlist.length > 30) {
        final page2 = pdfdoc.pages.add();
      }
      // database values will go here
      for (int i = 0; i < myrequestlist.length; i++) {
        Chat temp = myrequestlist[i];
        PdfGridRow row = grid.rows.add();
        row.style =
            PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));

        row.cells[0].value =
            DateFormat.yMMMEd().format(temp.TimStp.toDate()).toString();
        row.cells[1].value =
            DateFormat("kk:mm:a").format(temp.TimStp.toDate()).toString();
        row.cells[2].value = temp.stat.length>0 ?temp.stat.toString(): "No comment found" ;
        row.cells[3].value = temp.attended;
        row.cells[4].value = temp.total;
        row.cells[5].value = temp.val.toString() + "%";
        row.cells[5].style = temp.val>=75 ? PdfGridCellStyle(textBrush: PdfBrushes.green) : PdfGridCellStyle(textBrush: PdfBrushes.red);
      }
      grid.draw(page: page, bounds: const Rect.fromLTWH(0, 125, 0, 0));
      page.graphics.drawString('Lecturer : ' + Teachername,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTWH(12, 700, 615, 100));
      List<int> bytes = pdfdoc.save();
      pdfdoc.dispose();
      String filename = "Lecture List : " +
          mysubject +
          " " +
          new DateTime.now().toString() +
          ".pdf";
      saveAndLaunchFile(bytes, filename);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (myrequestlist.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Lecture Records'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator()
                  // const Icon(
                  //   Icons.download_for_offline_sharp,
                  //   size: 200,
                  //   color: Colors.red,
                  // ),
                  // const SizedBox(
                  //   height: 25,
                  // ),
                  // const Text("Request in process"),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Text("Generating report"),
                  // const SizedBox(
                  //   height: 25,
                  // )
                ]),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Lecture Records'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.list_alt_sharp,
                  size: 200,
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Lecture List",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                    "Download the lecture list by clicking the button below"),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () => Createpdf(),
                    child: const Text("Print Pdf"))
              ],
            ),
          ));
    }
  }
}

import 'dart:ui';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:presence/Teacher/Functions_teacher.dart';

import 'package:presence/Teacher/teacherhome.dart';
import 'onclick_list2.dart';
import "package:presence/Download_support/mobile.dart"
    if (dart.library.html) 'package:presence/Download_support/web.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// ignore: use_key_in_widget_constructors
List<Chat> myrequestlist1 = [];
String mysubject = "";
String Lecdesc="";
String Teachername = "";
Timestamp lectstmp = Timestamp(0, 0);
class attended_stud_of_lec extends StatefulWidget {
  final String docstr;
  final Timestamp tstmp;
  final String subname;
  const attended_stud_of_lec(
      {Key? key, required this.docstr, required this.subname,required this.tstmp})
      : super(key: key);
  @override
  _attended_stud_of_lecents createState() => _attended_stud_of_lecents();
}

List<dynamic> boollist = [];
List<dynamic> doclist = [];
String currentqrdoc = "";
String currentinsdoc = "";

class _attended_stud_of_lecents extends State<attended_stud_of_lec> {
  Future<void> attendedstdlist() async {
    print("Fetching details");
    myrequestlist1.clear();
    boollist.clear();
    doclist.clear();
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    String inscode = ds.get("inscode");
    Teachername = ds.get("name");
    mysubject = widget.subname;
    lectstmp = widget.tstmp;
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    for (int i = 0; i < qs.size; i++) {
      try {
        if (qs.docs[i]["code"] == inscode) {
          currentinsdoc = qs.docs[i].id;
          DocumentSnapshot currentlec = await FirebaseFirestore.instance
              .collection("institute")
              .doc(qs.docs[i].id)
              .collection(widget.subname)
              .doc(widget.docstr)
              .get();

          try {
            print("inside try");
            // currentqrdoc = currentlec.docs[x].id;
            List<dynamic> attend = currentlec.get("attend");
            boollist = attend;
            List<dynamic> students = currentlec.get("total_students");
            doclist = students;
            String chatdesc = "";
                  try {
                    Lecdesc = currentlec.get("desc");
                  } catch (e) {
                    Lecdesc = "Lecture/Practical";
                  }
            
            List<String> stdnames;

            for (int v = 0; v < students.length; v++) {
              print("inside for");
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
          } catch (e) {
            print(e);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    myrequestlist1.sort((a,b)=>
      a.roll.compareTo(b.roll)
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attendedstdlist();
  }
@override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    checkglobalinternet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
                        Navigator.of(context).pop();
                        // Your Code
                      });
                    },
                    icon: Icon(Icons.arrow_back));
              },
            ),
            title: Text('Student List'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            actions: [
              IconButton(
                tooltip: "Download list",
                  onPressed: () {
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => buildpdfandsave()));
                      // Your Code
                    });
                  },
                  icon: Icon(Icons.download_for_offline_sharp,color: Color.fromRGBO(194, 16, 16, 1),))
            ]),
        body: Builder(
          builder: (context) => Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12),
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
    print("the request list is " + myrequestlist1.toString());
    if (myrequestlist1.isEmpty) {
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
              itemCount: myrequestlist1.length,
              itemBuilder: (context, index) => ChatCard(
                chat: myrequestlist1[index],
                press: () {},
                onclicked: (bool value) {},
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
    if (widget.chat.attended) {
      return InkWell(
        highlightColor: Colors.blue.withOpacity(0.4),
        splashColor: Colors.green.withOpacity(0.5),
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.chat.roll,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        )
                        // ignore: prefer_const_constructors
                      ]),
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
              )
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        highlightColor: Colors.blue.withOpacity(0.4),
        splashColor: Colors.green.withOpacity(0.5),
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
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.chat.roll,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        )
                        // ignore: prefer_const_constructors
                      ]),
                ),
              ),
              const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
              )
            ],
          ),
        ),
      );
    }
  }
}

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 10.0;

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
// page.graphics.drawImage(
      // PdfBitmap(await _readImageData('name.png')),
      // Rect.fromLTWH(190, 10, 40, 20));
      page.graphics.drawImage(PdfBitmap(await _readImageData('name.png')),
          const Rect.fromLTWH(220, 0, 75, 25));
      page.graphics.drawString(
          'Lecture Report', PdfStandardFont(PdfFontFamily.helvetica, 18),
          bounds: Rect.fromLTWH(190, 30, 615, 100));
      page.graphics.drawString(
          'Generated through Presence Attendance tracking system',
          PdfStandardFont(PdfFontFamily.helvetica, 8),
          bounds: Rect.fromLTWH(160, 50, 615, 100));

      page.graphics.drawString("Generated at : " + new DateTime.now().toString(),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 65, 615, 100));

      page.graphics.drawString('Subject           : ' + mysubject,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 85, 615, 100));

      page.graphics.drawString('Generated by : ' + Teachername,
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 105, 615, 100));
      page.graphics.drawString('Lecture Date  : ' + DateFormat.yMMMEd().format(lectstmp.toDate()).toString(),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 125, 615, 100));
      page.graphics.drawString('Lecture time   : ' + DateFormat("kk:mm:a").format(lectstmp.toDate()).toString(),
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 145, 615, 100));
      page.graphics.drawString(Lecdesc.toString().length>0 ? 'Lecture comment   : '+ Lecdesc.toString() :"No comments found",
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(12, 165, 615, 100));

      PdfGrid grid = PdfGrid();
      grid.style = PdfGridStyle(
          font: PdfStandardFont(PdfFontFamily.helvetica, 12),
          cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

      grid.columns.add(count: 3);
      grid.headers.add(1);

      PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Name';
      header.cells[1].value = 'Enrollment Id';
      header.cells[2].value = 'Attended(P/A)';

      // code to add rows goes here

      if (myrequestlist1.length > 30) {
        final page2 = pdfdoc.pages.add();
      }
      // database values will go here
      for (int i = 0; i < myrequestlist1.length; i++) {
        Chat temp = myrequestlist1[i];
        PdfGridRow row = grid.rows.add();
        row.style =
            PdfGridRowStyle(font: PdfStandardFont(PdfFontFamily.helvetica, 10));
        row.cells[0].value = temp.name.toString();
        row.cells[1].value = temp.roll;
        row.cells[2].value = temp.attended ? "P":"A";
        row.cells[2].style = temp.attended ? PdfGridCellStyle(textBrush: PdfBrushes.green ) : PdfGridCellStyle(textBrush: PdfBrushes.red );
      }
      grid.draw(page: page, bounds: const Rect.fromLTWH(0, 185, 0, 0));

      // page.graphics.drawString('Lecturer : ' + Teachername,
      //     PdfStandardFont(PdfFontFamily.helvetica, 12),
      //     bounds: Rect.fromLTWH(12, 700, 615, 100));
      List<int> bytes = pdfdoc.save();
      pdfdoc.dispose();
      String filename = "Lecture Report : " +
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
    if (myrequestlist1.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Attendance List'),
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
                  Icons.checklist_rtl_sharp,
                  size: 200,
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text("Lecture Attendance List"),
                const SizedBox(
                  height: 30,
                ),
                Text("Download the list by clicking the button below"),
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

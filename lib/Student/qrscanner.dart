// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
// ignore: unused_import
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:presence/Student/studenthome.dart';
// ignore: unused_import
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class qrscanner extends StatefulWidget {
  const qrscanner({Key? key}) : super(key: key);

  @override
  _qrscanner createState() => _qrscanner();
}

class _qrscanner extends State<qrscanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (io.Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  late Map<String, dynamic> mydata;
  String qrcode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Qr'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Expanded(flex: 1, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (result != null)
                      Text('Barcode Type: ${result!.format}   Data: $qrcode')
                    else
                      const Text('Scan a code'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text('Flash: ${snapshot.data}');
                                },
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                        'Camera facing ${describeEnum(snapshot.data!)}');
                                  } else {
                                    return const Text('loading');
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    // Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // children: <Widget>[
                    // Container(
                    //   margin: const EdgeInsets.all(8),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       await controller?.pauseCamera();
                    //     },
                    //     child: const Text('pause',
                    //         style: TextStyle(fontSize: 20)),
                    //   ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.all(8),
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       await controller?.resumeCamera();
                    //     },
                    //     child: const Text('resume',
                    //         style: TextStyle(fontSize: 20)),
                    //   ),
                    // )
                    // ],
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 300 &&
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    bool set = false;
    controller.scannedDataStream.listen((scanData) {
      if (set) {
        return;
      }
      set = true;
      setState(
        () {
          result = scanData;
          qrcode = scanData.code;
          seperator(qrcode);
          // mydata = jsonDecode(result!.code);
          controller.dispose();
          set = false;
        },
      );
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void seperator(String code) async {
    int index = code.indexOf("@");
    if (code.contains("@")) {
      List parts = [
        code.substring(0, index).trim(),
        code.substring(index + 1).trim()
      ];
      SearchQrCode(parts[0], parts[1]);
      debugPrint(parts[0]);
      debugPrint(parts[1]);
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmQr(
                      qrcode: parts[1],
                      sub: parts[0],
                    )));
        // Your Code
      });
    } else {
      debugPrint("invalid qrcode");
    }

    // apna database code yaha dalna
  }

// hello from this
  Widget SearchQrCode(String coursecode, String qrcode) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('"institute"')
          .where('courses', isEqualTo: coursecode)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          debugPrint("something went wrong");
          return Text("something went wrong");
        } else {
          debugPrint("hello");
          return Text("hello");
        }
      },
    );
  }
}

class ConfirmQr extends StatefulWidget {
  const ConfirmQr({Key? key, required this.qrcode, required this.sub})
      : super(key: key);
  final String qrcode;
  final String sub;
  @override
  State<ConfirmQr> createState() => _ConfirmQrState();
}

List<dynamic> boollist = [];
List<dynamic> doclist = [];
String currentqrdoc = "";
String currentinsdoc = "";
String curruser = "";

class _ConfirmQrState extends State<ConfirmQr> {
  bool found = false;
  Future<void> findqrdoc() async {
    bool temp = false;
    User? user = FirebaseAuth.instance.currentUser;
    curruser = user!.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_student")
        .doc(user.uid)
        .get();
    String inscode = ds.get("inscode");
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("institute").get();
    print("insfound");
    for (int i = 0; i < qs.size; i++) {
      try {
        if (qs.docs[i]["code"] == inscode) {
          currentinsdoc = qs.docs[i].id;
          print("specific ins found");
          QuerySnapshot currentlec = await FirebaseFirestore.instance
              .collection("institute")
              .doc(qs.docs[i].id.toString())
              .collection(widget.sub.toString())
              .get();
          print("got curr lec");
          print(qs.docs[i].id.toString());
          print(widget.sub.toString());
          print(currentlec.size);
          for (int x = 0; x < currentlec.size; x++) {
            try {
              if (currentlec.docs[x]["qrstr"].toString() ==
                  widget.qrcode.toString()) {
                print("qrdoc found");
                currentqrdoc = currentlec.docs[x].id;
                if (currentlec.docs[x]["accept"] == true) {
                  print("qr doc accepting");
                  List<dynamic> attend = currentlec.docs[x]["attend"];
                  List<dynamic> students = currentlec.docs[x]["total_students"];
                  boollist = attend;
                  doclist = students;
                  for (int v = 0; v < students.length; v++) {
                    if (user.uid == students[v]) {
                      print("student match");
                      found = true;
                    }
                  }
                }
              } else {
                continue;
              }
            } catch (e) {
              print(e);
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {});
  }

  Future<void> markattendance() async {
    for (int x = 0; x < doclist.length; x++) {
      if (doclist[x] == curruser) {
        boollist[x] = true;
      }
    }
    await FirebaseFirestore.instance
        .collection("institute")
        .doc(currentinsdoc)
        .collection(widget.sub)
        .doc(currentqrdoc)
        .update({'attend': boollist});
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const student()));
      // Your Code
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Attendance marked successfully"),
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
    findqrdoc();
  }

  @override
  Widget build(BuildContext context) {
    if (found) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Give attendance'),
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
                Icons.check_circle_rounded,
                size: 200,
                color: Colors.green,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text("Match found"),
              const SizedBox(
                height: 30,
              ),
              Text("Give attendance for " + widget.sub),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () => markattendance(),
                  child: const Text("Mark Attendance"))
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Give attendance'),
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
                Icons.cancel_rounded,
                size: 200,
                color: Colors.red,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text("Institute not accepting responses"),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const student()));
                      // Your Code
                    });
                  },
                  child: const Text("Go back"))
            ],
          ),
        ),
      );
    }
    ;
  }
}

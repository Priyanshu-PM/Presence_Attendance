import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presence/Teacher/Functions_teacher.dart';
import 'package:presence/Teacher/student_list.dart';
import 'package:presence/theme.dart';
import 'package:presence/widgets/primary_button_main.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final urlImage = 'assets/images/teacher.png';

    return Drawer(
      child: Material(
        color: Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () {},
            ),
            Divider(color: Color.fromARGB(179, 8, 7, 7)),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  buildMenuItem(
                    text: 'Profile Page',
                    icon: Icons.person_add_alt_1_rounded,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Application Info',
                    icon: Icons.account_tree_outlined,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Contact Support',
                    icon: Icons.manage_accounts_rounded,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 0),
                  const SizedBox(height: 5),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  buildMenuItem(
                    text: 'Feedback',
                    icon: Icons.feedback,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const SizedBox(height: 5),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout_outlined,
                    onClicked: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            title: Text("Logout"),
                            content: Text("Are you sure you want to sign out?",
                                textAlign: TextAlign.center),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      print("logout successful");
                                      //SchedulerBinding.instance!.addPostFrameCallback((_) {
                                      Future.delayed(Duration.zero, () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                Navigator.defaultRouteName));
                                      });
                                      // });
                                    } on FirebaseAuthException catch (exp) {
                                      // ignore: avoid_print
                                      print("error... Invalid login $exp");
                                      // ignore: avoid_print
                                      print("email entered = ");
                                    } catch (exp) {
                                      // ignore: avoid_print
                                      print("error- $exp");
                                    }
                                  },
                                  child: Text("Yes")),
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      Navigator.of(context).pop();
                                      // });
                                    } on FirebaseAuthException catch (exp) {
                                      // ignore: avoid_print
                                      print("error... Invalid login $exp");
                                      // ignore: avoid_print
                                      print("email entered = ");
                                    } catch (exp) {
                                      // ignore: avoid_print
                                      print("error- $exp");
                                    }
                                  },
                                  child: Text("No"))
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  foregroundImage: AssetImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                        fontSize: 11, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Color.fromARGB(255, 0, 0, 0);
    final hoverColor = Color.fromARGB(255, 211, 211, 211);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FavouritesPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Contact(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Privacy_Policy(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Notifications(),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Feedback(),
        ));
        break;
    }
  }
}

class Feedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Feedback'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Image.asset(
                    'image/feedback.png',
                    width: 400,
                    height: 150,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Feedback From users',
                    style: TextStyle(
                        fontSize: 25.0, height: 2.0, color: Colors.black),
                    textAlign: TextAlign.end,
                  ),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  Text(
                    'Feedback is a key part of any programmer skills and contributes enormously to the success of a project.feedback helps to build better relationships between the project manager and the team and between team members.',
                    style: TextStyle(
                        fontSize: 18.0, height: 2.0, color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    color: Colors.cyan,
                    textColor: Colors.white,
                    onPressed: () {
                      launch(
                          'https://docs.google.com/forms/d/e/1FAIpQLSdC1bcS-W07ow7-tHDnuvDdeYwyER3ABFvcGWlVuwYJYYpwpQ/viewform?usp=sf_link');
                      final snackBar = SnackBar(content: Text("Pressed"));

                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: const Text('Send Feedback'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  new Image.asset(
                    'image/Presence_name.png',
                    width: 00,
                    height: 100,
                  ),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  Text('Send Message ',
                      style: TextStyle(
                          fontSize: 27.0, height: 3.0, color: Colors.black)),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  SizedBox(
                    height: 24,
                  ),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Write a Message',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: textWhiteGrey,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                        GestureDetector(
                          // When the child is tapped, show a snackbar.
                          onTap: () {
                            const snackBar = SnackBar(
                              content: Text('Message Sent!'),
                              backgroundColor: Colors.blue,
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          // The custom button
                          child: CustomPrimaryButton1(
                              buttonColor: primaryBlue,
                              textValue: 'Send',
                              textColor: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class CustomPrimaryButton1 extends StatelessWidget {
  final Color buttonColor;
  final String textValue;
  final Color textColor;

  // ignore: use_key_in_widget_constructors
  const CustomPrimaryButton1(
      {required this.buttonColor,
      required this.textValue,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14.0),
      elevation: 0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              const snackBar = SnackBar(
                content: Text('Message Sent!'),
                backgroundColor: Colors.blue,
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                textValue,
                style: heading5.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}

class Privacy_Policy extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Privacy & Policy'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Image.asset(
                    'image/privacy.png',
                    width: 400,
                    height: 150,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                          fontSize: 25.0, height: 2.0, color: Colors.black),
                      textAlign: TextAlign.end,
                    ),
                  ),

                  Divider(color: Color.fromARGB(179, 8, 7, 7)),

                  //Center(
                  //child: Text('Personal Information ',
                  //// style: TextStyle(
                  //   fontSize: 20.0, height: 2.0, color: Colors.black)),
                  //),
                  Text(
                    'The App may collect your personal identification information from the users. This information can be collected using vivid means, including, but not limited to, your visit to the App, register on the App, and in connection with other activities, services, features, or resources that we offer on our app',
                    style: TextStyle(
                        fontSize: 14.0, height: 2.0, color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  SizedBox(
                    height: 0,
                  ),
                  Center(
                    child: Text('Information Security ',
                        style: TextStyle(
                            fontSize: 20.0, height: 2.0, color: Colors.black)),
                  ),
                  Text(
                    'We have developed an improved data collection, storage and processing practice. The advanced security measures facilitate protection against the unauthorized access, alteration, disclosure or destruction of your personal information, username, password, transaction details and the data stored on the App',
                    style: TextStyle(
                        fontSize: 14.0, height: 2.0, color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(
                    height: 0,
                  ),
                  // Center(
                  // child: Text('Your consent to the terms ',
                  //    style: TextStyle(
                  //       fontSize: 20.0, height: 2.0, color: Colors.black)),
                  //  ),
                  // Text(
                  // 'You are agreeing to the above-mentioned terms of using this App. If you do not agree to the policy clauses, we would request you to, not to this App. Your consistent use of the App that is following the posting of amendments will be considered your acceptance to those changes.',
                  // style: TextStyle(
                  //   fontSize: 14.0, height: 2.0, color: Colors.black54),
                  // textAlign: TextAlign.start,
                  //  ),
                  SizedBox(
                    height: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

//navigation page
class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Application Info'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Image.asset(
                    'image/Presence_logo.png',
                    width: 400,
                    height: 130,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'APPLICATION INFO',
                      style: TextStyle(
                          fontSize: 25.0, height: 2.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  Text('About us ',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black)),
                  Text(
                    'The Presence app enables the institute, students & faculty to register online and track the attendance of the students in an effective way.',
                    style: TextStyle(
                        fontSize: 14.0, height: 2.0, color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  SizedBox(
                    height: 0,
                  ),
                  Text('Available Platforms',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black)),
                  Text('Android, IOS.',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  SizedBox(
                    height: 0,
                  ),
                  Text('Languages',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black)),
                  Text('English',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  Text('Application version',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black)),
                  Text('1.0.0 ',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  Text('Copyright',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black)),
                  Text('?? 2021-2022 Presence INC.',
                      style: TextStyle(
                          fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  SizedBox(
                    height: 10,
                  ),
                  //const Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  // const Text('Developed by',
                  //     style: TextStyle(
                  //         fontSize: 15.0, height: 2.0, color: Colors.black)),
                  // const Text('Sujyot Kothale                :   1913054',
                  //     style: TextStyle(
                  //         fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  // const Text('Aayush Paturkar             :   1913040',
                  //     style: TextStyle(
                  //         fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  // const Text('Priyanshu Mahukhaye   :   1913028',
                  //     style: TextStyle(
                  //         fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  // const Text('Sarthak Khutafale          :   1913049',
                  //     style: TextStyle(
                  //         fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  // const Text('Ayush Shahu                   :   1913050',
                  //     style: TextStyle(
                  //         fontSize: 15.0, height: 2.0, color: Colors.black54)),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

//profile page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";

  String email = "";

  String phone = "";

  Future<void> getprofile() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("user_teacher")
        .doc(user!.uid)
        .get();
    name = ds.get("name");
    email = user.email!;
    phone = ds.get("contact");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Faculty Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    // alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 95,
                      backgroundColor: Color.fromARGB(255, 105, 131, 234),
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: Image.asset(
                            "image/faculty_profile.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    // alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Username',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 35.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Institute code',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(insid,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 35.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(email,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 35.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Contact No.',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18.0)),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(phone,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 35.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Contact Support'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Image.asset(
                    'image/OIP.jfif',
                    width: 400,
                    height: 170,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    'CONTACT SUPPORT',
                    style: heading2.copyWith(color: textBlack),
                    textAlign: TextAlign.center,
                  )),
                  const Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Email us ',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const Text('-presenceattendance@gmail.com',
                      style: TextStyle(
                          fontSize: 17.0, height: 2.0, color: Colors.blue)),
                  const Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Call us ',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const Text('-Helpline(Mon-Sun,10AM-7PM):8275014834',
                      style: TextStyle(
                          fontSize: 17.0, height: 2.0, color: Colors.black54)),
                  const Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Whatsapp us ',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const Text('8446023441, 9730581779',
                      style: TextStyle(
                          fontSize: 17.0, height: 2.0, color: Colors.black54)),
                  const Divider(color: Color.fromARGB(179, 8, 7, 7)),
                  const SizedBox(
                    height: 5,
                  ),
                  new Image.asset(
                    'image/img.png',
                    width: 3000,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

//userpage
class UserPage extends StatelessWidget {
  final String name;
  final String urlImage;

  const UserPage({
    Key? key,
    required this.name,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(name),
          centerTitle: true,
        ),
        body: Image.network(
          urlImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
}

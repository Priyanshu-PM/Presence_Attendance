import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
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
  Widget build(BuildContext context) => Scaffold(
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
      );
}

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

class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;

  Chat({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false,
  });
}

List chatsData = [
  Chat(
    name: "Uikey",
    lastMessage: "C++ Faculty.",
    time: "5s",
  ),
  Chat(
    name: "Rahaman",
    lastMessage: "SA",
    image: "image/teacher.png",
  ),
  Chat(
    name: "Katiwal",
    lastMessage: "LINUX",
    image: "image/Presence_name.png",
  ),
  Chat(
    name: "Neha",
    lastMessage: "PHP",
    image: "image/Presence_name.png",
  ),
  Chat(
    name: "Sujoyt",
    lastMessage: "SIR",
    image: "image/Presence_name.png",
  ),
  Chat(
    name: "ABC",
    lastMessage: "XYZ",
    image: "image/Presence_name.png",
  ),
  Chat(
    name: "Shirkey",
    lastMessage: "DS",
    image: "image/Presence_name.png",
  ),
  Chat(
    name: "S.A Khatri",
    lastMessage: "Java Faculty.",
    image: "image/Presence_name.png",
  ),
];

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
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chatsData[index],
              press: () {},
            ),
          ),
        )
      ],
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

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

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
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('image/teacher.png'),
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
                      Text(
                        chat.lastMessage,
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
                                onPressed: () {},
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

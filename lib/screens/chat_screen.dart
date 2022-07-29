import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shainchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? time = DateTime.now().toString();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

User? loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final textfieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;
  final _firestore = FirebaseFirestore.instance;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      _showDialog1(context);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Fire Chat'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: TextField(
                        cursorColor: Colors.blueGrey,
                        controller: textfieldController,
                        onChanged: (value) {
                          //Do something with the user input.
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  TextButton(
                    onPressed: () {
                      textfieldController.clear();
                      time = DateTime.now().toString();
                      if (messageText != null) {
                        _firestore.collection("messages").add({
                          "text": messageText,
                          "sender": loggedInUser!.email,
                          "time": time.toString()
                        });
                        messageText = null;
                      }
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key? key,
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final messageDateTime = message['time'];

          final currentUser = loggedInUser!.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            TIME: messageDateTime,
          );
          messageBubbles.add(messageBubble);
          messageBubbles.sort((a, b) =>
              DateTime.parse(b.TIME!).compareTo(DateTime.parse(a.TIME!)));
        }
        return Expanded(
            child: ListView(reverse: true, children: messageBubbles));
      },
    );
  }
}

// class MessageBubble extends StatelessWidget {
//   String? text;
//   String? sender;
//   bool? isMe;
//   String? TIME;
//
//   MessageBubble({this.sender, this.text, this.isMe,this.TIME});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "$sender",
//             style: const TextStyle(fontSize: 11, color: Colors.white),
//           ),
//           Material(
//             elevation: 5,
//             color: isMe! ? Colors.lightBlue : Colors.blueGrey,
//             borderRadius: isMe!
//                 ? const BorderRadius.only(
//                     topLeft:  Radius.circular(30),
//                     topRight: Radius.circular(30),
//                     bottomLeft:  Radius.circular(30))
//                 : const BorderRadius.only(
//                     topRight:  Radius.circular(30),
//                     bottomLeft:  Radius.circular(30),
//                     bottomRight:  Radius.circular(30)),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Text('$text'),
//             ),
//             textStyle: const TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class MessageBubble extends StatelessWidget {
  String? text;
  String? sender;
  bool? isMe;
  String? TIME;

  MessageBubble({this.sender, this.text, this.isMe, this.TIME});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            (isMe!) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$sender",
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.white,
            ),
          ),
          Material(
            borderRadius: (isMe!)
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: (isMe!) ? Colors.lightBlueAccent : Colors.blueGrey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: (isMe!) ? Colors.white : Colors.grey.shade900,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Text(
            "$TIME",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showDialog1(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'ERROR',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Try again after some time',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OKAY',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

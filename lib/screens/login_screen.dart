import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shainchat/constants.dart';
import 'package:shainchat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? EMAIL;
  String? PASSWORD;
  bool Spinner = false;
  bool? isChecked = false;
  final textfieldController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        color: Colors.black,
        inAsyncCall: Spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  EMAIL = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    )),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: textfieldController,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  PASSWORD = value;
                },
                obscureText: isChecked! == false ? true : false,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(   
                    activeColor: Colors.grey,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                  checkColor: Colors.black),
                  Text("Show password",style: TextStyle(color: Colors.grey),)
                ],
              ),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'login',
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        //Implement login functionality.
                        setState(() {
                          Spinner = true;
                        });
                        try {
                          final User = await _auth.signInWithEmailAndPassword(
                              email: EMAIL!, password: PASSWORD!);
                          if (User != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                          setState(() {
                            Spinner = false;
                          });
                          textfieldController.clear();
                        } catch (e) {
                          textfieldController.clear();
                          setState(() {
                            Spinner = false;
                          });
                          _showDialog1(context);
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Log In',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        title: Text(
          'ERROR',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'check username and password',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
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

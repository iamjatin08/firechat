import 'package:flutter/material.dart';
import 'package:shainchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shainchat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registeration_screen';
  @override
  _RegistrationScreenState createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? EMAIL;
  String? PASSWORD;
  bool Spinner = false;
  bool? isChecked = false;
  String? ReEnterPassord;
  final textfieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        color: Colors.black,
        inAsyncCall: Spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  EMAIL = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Email',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    )),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  PASSWORD = value;
                },
                obscureText: isChecked! == false ? true : false,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'New Password',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    )),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: textfieldController,
                onChanged: (value) {
                  //Do something with the user input.
                  ReEnterPassord = value;
                },
                obscureText: isChecked! == false ? true : false,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Re Enter Password',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              const SizedBox(
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
              const SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'register',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        //Implement registration functionality.
                        if(PASSWORD == ReEnterPassord){
                          setState(() {
                            Spinner = true;
                          });
                          try {
                            final NewUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: EMAIL!, password: PASSWORD!);
                            if (NewUser != null) {
                              Navigator.pushNamed(context, ChatScreen.id);
                            }
                            setState(() {
                              Spinner = false;
                              textfieldController.clear();
                            });
                          } catch (e) {
                            textfieldController.clear();
                            setState(() {
                              Spinner = false;
                            });
                            _showDialog1(context);
                          }
                        }
                        else {
                          textfieldController.clear();
                          setState(() {
                            Spinner = false;
                            text = "Password mismatch";
                          });
                          _showDialog1(context);
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
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

String? text;

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
        content: text == null
            ? Text(
                'check username and password',
                style: TextStyle(color: Colors.black),
              )
            : Text(
                text!,
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

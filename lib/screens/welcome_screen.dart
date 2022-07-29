import 'package:flutter/material.dart';
import 'package:shainchat/screens/login_screen.dart';
import 'package:shainchat/screens/registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.ease);
    controller?.forward();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(animation!.value),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      child: Image.asset('images/logo.png'),
                      height: animation!.value * 75,
                    ),
                  ),
                ),
                const Text(
                  'FiRE',
                  style: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                const Text(
                  ' ChAt',
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'login',
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    minWidth: 200.0,
                    height: 50.0,
                    child: const Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'register',
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      //Go to registration screen.
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    minWidth: 200.0,
                    height: 50.0,
                    child: const Text(
                      'Register',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

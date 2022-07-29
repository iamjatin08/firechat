import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shainchat/screens/welcome_screen.dart';
import 'package:shainchat/screens/login_screen.dart';
import 'package:shainchat/screens/registration_screen.dart';
import 'package:shainchat/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ShainChat());
}

class ShainChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        ChatScreen.id : (context) => ChatScreen(),
      },
    );
  }
}

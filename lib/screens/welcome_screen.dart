import 'package:basyo/screens/main_screen.dart';
import 'package:basyo/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('images/welcomeLogo.png'),
          ElevatedButton(
            child: Text('Login'),
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
          ElevatedButton(
            child: Text('新規登録'),
            style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
            onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
          ),
          ElevatedButton(
            child: Text('無視して進む'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, MainScreen.id);
            },
          ),
        ],
      ),
    );
  }
}

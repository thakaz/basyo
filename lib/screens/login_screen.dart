import 'package:basyo/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({Key key}) : super(key: key);
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('images/login.png'),
            SizedBox.fromSize(),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'メールアドレス'),
              onChanged: (value) {
                email = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'パスワード'),
              onChanged: (value) {
                password = value;
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  try {
                    UserCredential userCredential =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    if (userCredential != null) {
                      Navigator.pushNamed(context, MainScreen.id);
                    }
                    setState(() {});
                  } catch (e) {
                    var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Icon(Icons.error_outline),
                            content: Icon(Icons.error),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(0);
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                    print(result);
                    print(e);
                  }
                },
                child: Text('Go'))
          ],
        ),
      ),
    );
  }
}

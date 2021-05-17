import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  //const RegistrationScreen({Key key}) : super(key: key);
  static const id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
            Image.asset('images/registration.png'),
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
                        await _auth.createUserWithEmailAndPassword(
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
                            content: Text(e.toString()),
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

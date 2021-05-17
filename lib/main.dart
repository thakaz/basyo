import 'dart:isolate';
import 'dart:ui';

import 'package:basyo/handlers/location_callback_handler.dart';
import 'package:basyo/screens/login_screen.dart';
import 'package:basyo/screens/main_screen.dart';
import 'package:basyo/screens/registration_screen.dart';
import 'package:basyo/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);

    port.listen((dynamic data) {});
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static Future<void> callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
    print('Callbackおわり');
  }

  static void notificationCallback() {
    print('Userはんが押しましたえ');
  }

  ///
  /// 位置情報ービスの開始
  void startLocationService() {
    BackgroundLocator.registerLocationUpdate(
      callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: <String, WidgetBuilder>{
        WelcomeScreen.id: (BuildContext context) => WelcomeScreen(),
        LoginScreen.id: (BuildContext context) => LoginScreen(),
        MainScreen.id: (BuildContext context) => MainScreen(),
        RegistrationScreen.id: (BuildContext context) => RegistrationScreen(),
      },
    );
  }
}

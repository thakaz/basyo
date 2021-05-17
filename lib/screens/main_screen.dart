import 'package:basyo/screens/map_screen.dart';
import 'package:basyo/screens/room_list_screen.dart';
import 'package:basyo/screens/set_location_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MainScreen extends StatefulWidget {
  //const MainScreen({Key key}) : super(key: key);
  static const id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pageList = [
    RoomListScreen(
      displayText: 'ルーム選択',
      roomSelectCallback: () {},
    ),
    MapScreen(),
    SetLocationServiceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart), label: "こんちわ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.backpack_sharp), label: "うす"),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "こんばんわ"),
        ],
      ),
    );
  }
}

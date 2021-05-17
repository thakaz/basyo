import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;
Function _roomSelectCallback = () {};

class RoomListScreen extends StatefulWidget {
  //const RoomListScreen({Key key}) : super(key: key);
  static const id = 'room_list_screen';
  final String displayText;

  RoomListScreen({required this.displayText, required roomSelectCallback}) {
    _roomSelectCallback = roomSelectCallback;
  }

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final messageTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser?.email);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: Column(
        children: [
          Text(
            widget.displayText,
            style: TextStyle(fontSize: 50.0),
          ),
          Expanded(child: RoomStream()),
        ],
      ),
    );
  }
}

class RoomStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('rooms').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text('だめじゃん');
          }

          final rooms = snapshot.data?.docs;

          List<Widget> roomList = <Widget>[];

          for (var room in rooms ?? []) {
            print(room);
            print(room['name']);
            roomList.add(ListTile(
              title: Text(room['name']),
              leading: Icon(Icons.home),
              onTap: _roomSelectCallback(room['id']),
            ));
          }

          return ListView(children: roomList);
        });
  }
}

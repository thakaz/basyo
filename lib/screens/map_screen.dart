import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  //const MapScreen({Key key}) : super(key: key);
  static const id = 'map_screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.0, 135.0),
    zoom: 15.0,
  );

  static final CameraPosition _kLake = CameraPosition(
    target: LatLng(35.1499, 136.9461),
    zoom: 15,
  );

  Set<Marker> markers = {
    Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(35, 136),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'マーカーの説明'))
  };

  void messagesStream() async {
    await for (var snapshot in rooms.snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: markers,
        ),
        Column(children: [
          ElevatedButton(
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
            },
            child: Text('GOTOLAKE!!'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool serviceEnabled;
              LocationPermission permission;

              serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                myShowDialog(context, 'Location services are disabled.');
              }

              permission = await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {
                  myShowDialog(context, 'Location permissions are denied');
                }
              }

              if (permission == LocationPermission.deniedForever) {
                myShowDialog(context, 'Location permissions are denied');
              }
              Position pos = await Geolocator.getCurrentPosition();
              //myShowDialog(context, pos.toString());
              var rand = Random().nextInt(10);

              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(pos.latitude, pos.longitude + rand / 10),
                      zoom: 15),
                ),
              );
              setState(() {
                markers.add(Marker(
                    markerId: MarkerId('newmarker' + rand.toString()),
                    position: LatLng(pos.latitude, pos.longitude + rand / 10),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                    infoWindow: InfoWindow(title: '現在地マーカー')));
              });
            },
            child: Text('現在位置を送信'),
          ),
        ])
      ],
    );
  }
}

Future myShowDialog(context, text) {
  return showDialog(
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
                child: Text(text))
          ],
        );
      });
}

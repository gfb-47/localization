import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition? _random;

  @override
  void initState() {
    _random = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(generateRandomLat(), generateRandomLong()),
        tilt: 39.44032436555,
        zoom: 19.151926040649414);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _random!,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Positioned(
          bottom: 5,
          child: ElevatedButton(
            onPressed: () => print('a'),
            child: Text('Bring me back home'),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff9A2EEF))),
          ),
        ),
        Positioned(
          bottom: 50,
          width: 150,
          child: ElevatedButton(
              onPressed: () => print('a'),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff2EC1EF))),
              child: Text('Teleport me to somewhere random')),
        ),
      ]),
    );
  }

  double generateRandomLat() {
    return -90 + Random().nextDouble() * 90 * 2;
  }

  double generateRandomLong() {
    return -180 + Random().nextDouble() * 180 * 2;
  }
}

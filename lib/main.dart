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

  CameraPosition? _random;
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    _random = CameraPosition(
        target: LatLng(37.432068, -122.087755), zoom: 19.151926040649414);
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _random!,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          bottom: 15,
          width: 200,
          child: ElevatedButton(
            onPressed: () => print('a'),
            child: Text(
              'Bring me back home',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: const Color(0xff9A2EEF)))),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xff9A2EEF))),
          ),
        ),
        Positioned(
          bottom: 85,
          width: 200,
          child: ElevatedButton(
              onPressed: () => print('a'),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(5),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: const Color(0xff2EC1EF)))),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff2EC1EF))),
              child: Text(
                'Teleport me to somewhere random',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              )),
        ),
      ]),
    );
  }

  double generateRandomLat() {
    var a = nextDouble(-90, 90);
    return a;
  }

  double generateRandomLong() {
    var a = nextDouble(-180, 180);
    return a;
  }

  double nextDouble(num min, num max) {
    final random = Random();

    return min + random.nextDouble() * (max - min);
  }
}

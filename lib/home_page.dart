import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/components.dart';
import 'utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      logger(error.toString(), isError: true);
    });
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        GoogleMap(
          // on below line setting camera position
          initialCameraPosition: _kGoogle,
          // on below line we are setting markers on the map
          markers: Set<Marker>.of(_markers),
          // on below line setting user location enabled.
          myLocationEnabled: true,
          // on below line setting compass enabled.
          // on below line specifying controller on map complete.
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Positioned(
          bottom: 15,
          width: 200,
          child: Button(
            onTap: () async {
              getUserCurrentLocation().then((value) async {
                logger(
                    '${value.latitude.toString()} ${value.longitude.toString()}');

                // marker added for current users location
                _markers.add(Marker(
                  markerId: const MarkerId('2'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: const InfoWindow(
                    title: 'My Current Location',
                  ),
                ));

                // specified current users location
                final CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14,
                );

                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));
                setState(() {});
              });
            },
            color: const Color(0xff9A2EEF),
            title: AppConsts.bringMeBackText,
          ),
        ),
        Positioned(
            bottom: 85,
            width: 200,
            child: Button(
              color: const Color(0xff2EC1EF),
              onTap: () async {
                getUserCurrentLocation().then((value) async {
                  logger(
                      '${value.latitude.toString()} ${value.longitude.toString()}');

                  // marker added for current users location
                  _markers.add(Marker(
                    markerId: const MarkerId('2'),
                    position: LatLng(generateRandomLat(), generateRandomLong()),
                    infoWindow: const InfoWindow(
                      title: 'My Current Location',
                    ),
                  ));

                  // specified current users location
                  final CameraPosition cameraPosition = CameraPosition(
                    target: LatLng(generateRandomLat(), generateRandomLong()),
                    zoom: 14,
                  );

                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition));
                  setState(() {});
                });
              },
              title: AppConsts.teleportSomewhereText,
            )),
      ]),
    );
  }

  double generateRandomLat() {
    return nextDouble(-90, 90);
  }

  double generateRandomLong() {
    return nextDouble(-180, 180);
  }

  double nextDouble(num min, num max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }
}

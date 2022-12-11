import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/components.dart';
import 'database.dart';
import 'lat_long_model.dart';
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
  var latLongList = <LatLongModel>[];
  CameraPosition? _myPosition;
  Future<void> initDb() async {
    await DatabaseRepository.instance.database;
  }

  Future<void> addLatLng(LatLongModel latLng) async {
    await DatabaseRepository.instance.insert(
        latLng: LatLongModel(
            id: latLng.id,
            latitude: latLng.latitude,
            longitude: latLng.longitude));
  }

  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      logger(error.toString(), isError: true);
    });
    return Geolocator.getCurrentPosition();
  }

  Future<void> _setMyPosition() async {
    final result = await getUserCurrentLocation();
    setState(() {
      _myPosition = CameraPosition(
        target: LatLng(result.latitude, result.longitude),
        zoom: 14.4746,
      );
    });
  }

  @override
  void initState() {
    initDb();
    _setMyPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _myPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(alignment: Alignment.center, children: [
              GoogleMap(
                initialCameraPosition: _myPosition!,
                markers: Set<Marker>.of(_markers),
                myLocationEnabled: true,
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

                      _markers.add(Marker(
                        markerId: const MarkerId('2'),
                        position: LatLng(value.latitude, value.longitude),
                        infoWindow: const InfoWindow(
                          title: 'My Current Location',
                        ),
                      ));

                      final CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(value.latitude, value.longitude),
                        zoom: 14,
                      );

                      final GoogleMapController controller =
                          await _controller.future;
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
                        final latLng =
                            LatLng(generateRandomLat(), generateRandomLong());
                        _markers.add(Marker(
                          markerId: const MarkerId('2'),
                          position: latLng,
                          infoWindow: const InfoWindow(
                            title: 'My Current Location',
                          ),
                        ));

                        final CameraPosition cameraPosition = CameraPosition(
                          target: latLng,
                          zoom: 14,
                        );

                        final GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                        addLatLng(LatLongModel(
                            latitude: latLng.latitude,
                            longitude: latLng.longitude));
                        latLongList.addAll(
                            await DatabaseRepository.instance.getAllLatLngs());
                        setState(() {});
                        showDialog<void>(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(list: latLongList);
                          },
                        );
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

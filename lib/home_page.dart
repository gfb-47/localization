import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'components/components.dart';
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
  late Box<Map<String, dynamic>> box;
  final Completer<GoogleMapController> _controller = Completer();
  var latLongList = <LatLongModel>[];
  CameraPosition? _myPosition;

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
    _openBox();
    _setMyPosition();
    super.initState();
  }

  Future<void> _openBox() async {
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
                        var latLng =
                            LatLng(generateRandomLat(), generateRandomLong());
                        // marker added for current users location
                        _markers.add(Marker(
                          markerId: const MarkerId('2'),
                          position: latLng,
                          infoWindow: const InfoWindow(
                            title: 'My Current Location',
                          ),
                        ));

                        // specified current users location
                        final CameraPosition cameraPosition = CameraPosition(
                          target: latLng,
                          zoom: 14,
                        );

                        final GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                        await box.put(
                            const Uuid().v4(),
                            LatLongModel(
                                    latitude: latLng.latitude,
                                    longitude: latLng.longitude)
                                .toMap());

                        latLongList.clear();
                        latLongList.addAll(
                            box.values.map((e) => LatLongModel.fromMap(e)));
                        // latLongList.addAll(a);
                        print(latLongList.length);
                        // showDialog<void>(
                        //   context: context,
                        //   barrierDismissible: false, // user must tap button!
                        //   builder: (BuildContext context) {
                        //     return SizedBox(
                        //       height: 100,
                        //       child: AlertDialog(
                        //         title: const Text('AlertDialog Title'),
                        //         content:
                        //             ListView.builder(itemBuilder: (_, index) {
                        //           return Row(
                        //             children: [
                        //               Text(latLongList[index]
                        //                   .latitude
                        //                   .toString()),
                        //               Text(latLongList[index]
                        //                   .longitude
                        //                   .toString()),
                        //             ],
                        //           );
                        //         }),
                        //         actions: <Widget>[
                        //           TextButton(
                        //             child: const Text('OK'),
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
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

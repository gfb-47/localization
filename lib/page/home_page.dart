import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/components.dart';
import '../database.dart';
import '../models/lat_long_model.dart';
import '../utils/utils.dart';

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

  @override
  void initState() {
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
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: _myPosition!,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              Positioned(
                bottom: 15,
                width: 200,
                child: Button(
                  onTap: _bringMeBack,
                  color: const Color(0xff9A2EEF),
                  title: AppConsts.bringMeBackText,
                ),
              ),
              Positioned(
                  bottom: 85,
                  width: 200,
                  child: Button(
                    color: const Color(0xff2EC1EF),
                    onTap: _teleportRandomPosition,
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
        zoom: 14,
      );
    });
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return LocDialog(
          list: latLongList,
        );
      },
    );
  }

  Future<void> _bringMeBack() async {
    getUserCurrentLocation().then((value) async {
      final CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  Future<void> _teleportRandomPosition() async {
    final latLng = LatLng(generateRandomLat(), generateRandomLong());

    final CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 14,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    DatabaseRepository.instance.addLatLngs(
        latLng: LatLongModel(
            latitude: latLng.latitude, longitude: latLng.longitude));

    latLongList.addAll(await DatabaseRepository.instance.getAllLatLngs());

    Future.delayed(const Duration(seconds: 4), () => _showDialog());
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database.dart';
import '../models/lat_long_model.dart';
import '../utils/utils.dart';

class LocalizationProvider with ChangeNotifier {
  var latLongList = <LatLongModel>[];
  CameraPosition? myPosition;

  final backupLat = 37.432068;
  final backupLong = -122.087755;

  double _generateRandomLat() {
    return _nextDouble(-90, 90);
  }

  double _generateRandomLong() {
    return _nextDouble(-180, 180);
  }

  double _nextDouble(num min, num max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }

  Future<void> teleportRandomPosition(GoogleMapController controller) async {
    final latLng = LatLng(_generateRandomLat(), _generateRandomLong());

    final CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 14,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    DatabaseRepository.instance.addLatLngs(
        latLng: LatLongModel(
            latitude: latLng.latitude, longitude: latLng.longitude));

    latLongList.addAll(await DatabaseRepository.instance.getAllLatLngs());
  }

  Future<Position?> getUserCurrentLocation() async {
    try {
      await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) async {
        await Geolocator.requestPermission();
        logger(error.toString(), isError: true);
      });
      return Geolocator.getCurrentPosition();
    } catch (e, s) {
      logger('getUserCurrentLocation -> $e $s', isError: true);
      return null;
    }
  }

  Future<void> bringMeBack(GoogleMapController controller) async {
    try {
      getUserCurrentLocation().then((value) async {
        late CameraPosition cameraPosition;
        if (value == null) {
          cameraPosition = CameraPosition(
            target: LatLng(backupLat, backupLong),
            zoom: 14,
          );
        } else {
          cameraPosition = CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 14,
          );
        }

        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    } catch (e, s) {
      logger('bringMeBack -> $e $s', isError: true);
    }
  }

  Future<void> setMyPosition() async {
    try {
      final result = await getUserCurrentLocation();
      if (result == null) {
        myPosition = CameraPosition(
          target: LatLng(backupLat, backupLong),
          zoom: 14,
        );
      } else {
        myPosition = CameraPosition(
          target: LatLng(result.latitude, result.longitude),
          zoom: 14,
        );
      }
      notifyListeners();
    } catch (e, s) {
      logger('setMyPosition -> $e $s', isError: true);
    }
  }
}

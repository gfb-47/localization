import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../models/lat_long_model.dart';
import '../providers/localization_provider.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LocalizationProvider>(context).setMyPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, value, child) => Scaffold(
        body: value.myPosition == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(alignment: Alignment.center, children: [
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: value.myPosition!,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 15,
                  width: 200,
                  child: Button(
                    onTap: () async =>
                        value.bringMeBack(await _controller.future),
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
                      value.teleportRandomPosition(await _controller.future);
                      Future.delayed(const Duration(seconds: 4),
                          () => _showDialog(value.latLongList));
                    },
                    title: AppConsts.teleportSomewhereText,
                  ),
                ),
              ]),
      ),
    );
  }

  Future<void> _showDialog(List<LatLongModel> latLongList) async {
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
}

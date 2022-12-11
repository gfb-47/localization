import 'package:flutter/material.dart';

import '../models/lat_long_model.dart';
import '../utils/utils.dart';
import 'components.dart';

@immutable
class LocDialog extends StatelessWidget {
  final List<LatLongModel> list;
  const LocDialog({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          Container(
            height: 350,
            padding: const EdgeInsets.only(
              top: 18.0,
            ),
            margin: const EdgeInsets.only(top: 13.0, right: 8.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(196, 196, 196, 0.83),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.transparent,
                ),
              ],
            ),
            child: ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            AppConsts.currentLocText,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Latitude: ${list.last.latitude}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Longitude: ${list.last.longitude}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lat: ${list[index].latitude.toStringAsFixed(2)}, ',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Long: ${list[index].longitude.toStringAsFixed(2)},',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(130),
                  child: const Cutout(
                    color: Color(0xff372929),
                    child: Icon(
                      Icons.close_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

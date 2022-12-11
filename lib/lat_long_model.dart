import 'dart:convert';

LatLongModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return LatLongModel.fromMap(jsonData as Map<String, dynamic>);
}

String clientToJson(LatLongModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class LatLongModel {
  double latitude;
  double longitude;

  LatLongModel({
    required this.latitude,
    required this.longitude,
  });

  factory LatLongModel.fromMap(Map<String, dynamic> json) => LatLongModel(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

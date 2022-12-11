class LatLongModel {
  int? id;
  double latitude;
  double longitude;

  LatLongModel({
    this.id,
    required this.latitude,
    required this.longitude,
  });

  factory LatLongModel.fromMap(Map<String, dynamic> json) => LatLongModel(
        id: json['id'] as int,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String address;
  final String? name;
  final String? placeId;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.name,
    this.placeId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      name: json['name'],
      placeId: json['placeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'name': name,
      'placeId': placeId,
    };
  }

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? name,
    String? placeId,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
    );
  }
}

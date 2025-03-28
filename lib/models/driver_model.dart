import 'location_model.dart';

class VehicleInfo {
  final String model;
  final String color;
  final String licensePlate;
  final String type; // sedan, SUV, etc.

  VehicleInfo({
    required this.model,
    required this.color,
    required this.licensePlate,
    required this.type,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      model: json['model'],
      color: json['color'],
      licensePlate: json['licensePlate'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'color': color,
      'licensePlate': licensePlate,
      'type': type,
    };
  }
}

class DriverModel {
  final String id;
  final String name;
  final String phoneNumber;
  final double rating;
  final int totalRides;
  final String photoUrl;
  final VehicleInfo vehicle;
  final LocationModel? currentLocation;
  final bool isAvailable;

  DriverModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.rating,
    required this.totalRides,
    required this.photoUrl,
    required this.vehicle,
    this.currentLocation,
    this.isAvailable = true,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      rating: json['rating'].toDouble(),
      totalRides: json['totalRides'],
      photoUrl: json['photoUrl'],
      vehicle: VehicleInfo.fromJson(json['vehicle']),
      currentLocation:
          json['currentLocation'] != null
              ? LocationModel.fromJson(json['currentLocation'])
              : null,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'totalRides': totalRides,
      'photoUrl': photoUrl,
      'vehicle': vehicle.toJson(),
      'currentLocation': currentLocation?.toJson(),
      'isAvailable': isAvailable,
    };
  }

  DriverModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    double? rating,
    int? totalRides,
    String? photoUrl,
    VehicleInfo? vehicle,
    LocationModel? currentLocation,
    bool? isAvailable,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      photoUrl: photoUrl ?? this.photoUrl,
      vehicle: vehicle ?? this.vehicle,
      currentLocation: currentLocation ?? this.currentLocation,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

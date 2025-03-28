import 'package:flutter/material.dart';

class RideTypeModel {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final double baseFare;
  final double pricePerKm;
  final double pricePerMinute;
  final int maxPassengers;
  final int estimatedArrivalTime; // in minutes
  final Color color;
  final bool isAvailable;

  RideTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.baseFare,
    required this.pricePerKm,
    required this.pricePerMinute,
    required this.maxPassengers,
    required this.estimatedArrivalTime,
    required this.color,
    this.isAvailable = true,
  });

  factory RideTypeModel.fromJson(Map<String, dynamic> json) {
    return RideTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      baseFare: json['baseFare'].toDouble(),
      pricePerKm: json['pricePerKm'].toDouble(),
      pricePerMinute: json['pricePerMinute'].toDouble(),
      maxPassengers: json['maxPassengers'],
      estimatedArrivalTime: json['estimatedArrivalTime'],
      color: Color(json['color']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'baseFare': baseFare,
      'pricePerKm': pricePerKm,
      'pricePerMinute': pricePerMinute,
      'maxPassengers': maxPassengers,
      'estimatedArrivalTime': estimatedArrivalTime,
      'color': color.value,
      'isAvailable': isAvailable,
    };
  }

  // Sample ride types for development purposes
  static List<RideTypeModel> getSampleRideTypes() {
    return [
      RideTypeModel(
        id: '1',
        name: 'SpaceCab Mini',
        description: 'Affordable rides for 1-2 people',
        iconPath: 'assets/icons/mini_car.png',
        baseFare: 5.0,
        pricePerKm: 1.2,
        pricePerMinute: 0.2,
        maxPassengers: 2,
        estimatedArrivalTime: 3,
        color: Colors.blue,
      ),
      RideTypeModel(
        id: '2',
        name: 'SpaceCab Sedan',
        description: 'Comfortable rides for up to 4 people',
        iconPath: 'assets/icons/sedan_car.png',
        baseFare: 7.0,
        pricePerKm: 1.5,
        pricePerMinute: 0.25,
        maxPassengers: 4,
        estimatedArrivalTime: 5,
        color: Colors.green,
      ),
      RideTypeModel(
        id: '3',
        name: 'SpaceCab Premium',
        description: 'Luxury rides with top-rated drivers',
        iconPath: 'assets/icons/premium_car.png',
        baseFare: 10.0,
        pricePerKm: 2.0,
        pricePerMinute: 0.3,
        maxPassengers: 4,
        estimatedArrivalTime: 7,
        color: Colors.black,
      ),
      RideTypeModel(
        id: '4',
        name: 'SpaceCab SUV',
        description: 'Spacious rides for up to 6 people',
        iconPath: 'assets/icons/suv_car.png',
        baseFare: 12.0,
        pricePerKm: 2.2,
        pricePerMinute: 0.35,
        maxPassengers: 6,
        estimatedArrivalTime: 8,
        color: Colors.orange,
      ),
    ];
  }
}

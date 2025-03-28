import 'location_model.dart';
import 'driver_model.dart';
import 'package:flutter/material.dart';

enum RideStatus {
  pending,
  searching,
  driverAssigned,
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

class RideModel {
  final String id;
  final LocationModel pickup;
  final LocationModel dropoff;
  final DateTime requestTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final double estimatedFare;
  final double? finalFare;
  final RideStatus status;
  final String rideType; // mini, sedan, prime, etc.
  final DriverModel? driver;
  final String? cancelReason;
  final String? paymentMethod;
  final bool isPaid;
  final String userId;

  RideModel({
    required this.id,
    required this.pickup,
    required this.dropoff,
    required this.requestTime,
    this.startTime,
    this.endTime,
    required this.estimatedFare,
    this.finalFare,
    required this.status,
    required this.rideType,
    this.driver,
    this.cancelReason,
    this.paymentMethod,
    this.isPaid = false,
    required this.userId,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      pickup: LocationModel.fromJson(json['pickup']),
      dropoff: LocationModel.fromJson(json['dropoff']),
      requestTime: DateTime.parse(json['requestTime']),
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      estimatedFare: json['estimatedFare'].toDouble(),
      finalFare: json['finalFare']?.toDouble(),
      status: RideStatus.values.byName(json['status']),
      rideType: json['rideType'],
      driver:
          json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      cancelReason: json['cancelReason'],
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'] ?? false,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickup': pickup.toJson(),
      'dropoff': dropoff.toJson(),
      'requestTime': requestTime.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'estimatedFare': estimatedFare,
      'finalFare': finalFare,
      'status': status.name,
      'rideType': rideType,
      'driver': driver?.toJson(),
      'cancelReason': cancelReason,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'userId': userId,
    };
  }

  RideModel copyWith({
    String? id,
    LocationModel? pickup,
    LocationModel? dropoff,
    DateTime? requestTime,
    DateTime? startTime,
    DateTime? endTime,
    double? estimatedFare,
    double? finalFare,
    RideStatus? status,
    String? rideType,
    DriverModel? driver,
    String? cancelReason,
    String? paymentMethod,
    bool? isPaid,
    String? userId,
  }) {
    return RideModel(
      id: id ?? this.id,
      pickup: pickup ?? this.pickup,
      dropoff: dropoff ?? this.dropoff,
      requestTime: requestTime ?? this.requestTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      finalFare: finalFare ?? this.finalFare,
      status: status ?? this.status,
      rideType: rideType ?? this.rideType,
      driver: driver ?? this.driver,
      cancelReason: cancelReason ?? this.cancelReason,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      userId: userId ?? this.userId,
    );
  }

  // Helper method to get color based on ride status
  Color getStatusColor() {
    switch (status) {
      case RideStatus.pending:
        return Colors.grey;
      case RideStatus.searching:
        return Colors.blue;
      case RideStatus.driverAssigned:
        return Colors.amber;
      case RideStatus.driverArriving:
        return Colors.orange;
      case RideStatus.inProgress:
        return Colors.green;
      case RideStatus.completed:
        return Colors.teal;
      case RideStatus.cancelled:
        return Colors.red;
    }
  }

  // Helper method to get status text
  String getStatusText() {
    switch (status) {
      case RideStatus.pending:
        return 'Pending';
      case RideStatus.searching:
        return 'Finding Driver';
      case RideStatus.driverAssigned:
        return 'Driver Assigned';
      case RideStatus.driverArriving:
        return 'Driver Arriving';
      case RideStatus.inProgress:
        return 'In Progress';
      case RideStatus.completed:
        return 'Completed';
      case RideStatus.cancelled:
        return 'Cancelled';
    }
  }
}

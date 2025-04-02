import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../models/ride_type_model.dart';
import '../../models/driver_model.dart';
import '../../models/location_model.dart';
import '../../widgets/custom_button.dart';

class RideConfirmationScreen extends StatefulWidget {
  const RideConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<RideConfirmationScreen> createState() => _RideConfirmationScreenState();
}

class _RideConfirmationScreenState extends State<RideConfirmationScreen> {
  bool _isLoading = false;

  // Mock data - in a real app, these would be passed as parameters
  final String _pickupAddress = "123 Main St, San Francisco, CA";
  final String _dropoffAddress = "456 Market St, San Francisco, CA";
  final double _distance = 3.2; // in km
  final int _estimatedTime = 12; // in minutes
  final RideTypeModel _selectedRideType =
      RideTypeModel.getSampleRideTypes()[0]; // SpaceCab Mini
  final String _paymentMethod = "Cash";

  void _confirmRide() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Mock driver data - in a real app, this would come from the API
      final driver = DriverModel(
        id: "DRV001",
        name: "John Doe",
        phoneNumber: "+91 98765 43210",
        rating: 4.8,
        totalRides: 1250,
        photoUrl: "https://example.com/driver-photo.jpg",
        vehicle: VehicleInfo(
          model: "SpaceCab Mini",
          color: "White",
          licensePlate: "KA-01-AB-1234",
          type: "sedan",
        ),
        currentLocation: LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          address: "San Francisco, CA",
          name: "San Francisco",
        ),
      );

      // Navigate to ride tracking screen
      context.push(
        '/ride-tracking',
        extra: {
          'pickupLocation': LocationModel(
            latitude: 37.7749,
            longitude: -122.4194,
            address: "San Francisco, CA",
            name: "San Francisco",
          ),
          'dropoffLocation': LocationModel(
            latitude: 37.7833,
            longitude: -122.4167,
            address: "Market St, San Francisco, CA",
            name: "Market Street",
          ),
          'driver': driver,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate fare
    final double baseFare = _selectedRideType.baseFare;
    final double distanceFare = _distance * _selectedRideType.pricePerKm;
    final double timeFare = _estimatedTime * _selectedRideType.pricePerMinute;
    final double platformFee = 1.50; // Fixed platform fee
    final double totalFare = baseFare + distanceFare + timeFare + platformFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Ride"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Ride summary
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ride type info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Ride type icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _selectedRideType.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.directions_car,
                              color: _selectedRideType.color,
                              size: 32,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Ride details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedRideType.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedRideType.description,
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: AppTheme.textSecondaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Arrives in ${_selectedRideType.estimatedArrivalTime} mins",
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Price
                        Text(
                          "₹${totalFare.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedRideType.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Route map (placeholder)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Map View",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Trip details
                  Text(
                    "Trip Details",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 16),

                  // Location details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Pickup
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.circle,
                                  color: AppTheme.primaryColor,
                                  size: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pickup",
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _pickupAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Container(
                            width: 1,
                            height: 24,
                            color: Colors.grey.shade300,
                          ),
                        ),

                        // Dropoff
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.location_on,
                                  color: AppTheme.primaryColor,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dropoff",
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _dropoffAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment method
                  Text(
                    "Payment Method",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 16),

                  // Payment selector
                  InkWell(
                    onTap: () {
                      // Navigate to payment selection screen
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                _paymentMethod == "Cash"
                                    ? Icons.money
                                    : Icons.credit_card,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _paymentMethod,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Fare breakdown
                  Text(
                    "Fare Breakdown",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 16),

                  // Fare details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Base fare
                        _buildFareRow(
                          "Base fare",
                          "₹${baseFare.toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 8),

                        // Distance fare
                        _buildFareRow(
                          "Distance (${_distance.toStringAsFixed(1)} km)",
                          "₹${distanceFare.toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 8),

                        // Time fare
                        _buildFareRow(
                          "Time (${_estimatedTime} mins)",
                          "₹${timeFare.toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 8),

                        // Platform fee
                        _buildFareRow(
                          "Platform fee",
                          "₹${platformFee.toStringAsFixed(2)}",
                        ),

                        const SizedBox(height: 16),

                        // Divider
                        Divider(color: Colors.grey.shade200, height: 1),

                        const SizedBox(height: 16),

                        // Total fare
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${totalFare.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm ride button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: CustomButton(
              text: "Confirm Ride",
              isLoading: _isLoading,
              onPressed: _confirmRide,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

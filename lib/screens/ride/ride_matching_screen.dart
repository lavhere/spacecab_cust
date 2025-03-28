import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../config/theme.dart';
import '../../models/driver_model.dart';
import '../../widgets/custom_button.dart';

class RideMatchingScreen extends StatefulWidget {
  const RideMatchingScreen({Key? key}) : super(key: key);

  @override
  State<RideMatchingScreen> createState() => _RideMatchingScreenState();
}

class _RideMatchingScreenState extends State<RideMatchingScreen> {
  bool _isSearching = true;
  bool _driverFound = false;
  DriverModel? _driver;
  int _searchTimeInSeconds = 0;
  late Timer _searchTimer;

  @override
  void initState() {
    super.initState();

    // Start search timer
    _searchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _searchTimeInSeconds++;
      });

      // After 5 seconds, show a driver
      if (_searchTimeInSeconds == 5) {
        _findDriver();
      }
    });
  }

  @override
  void dispose() {
    _searchTimer.cancel();
    super.dispose();
  }

  void _findDriver() {
    // In a real app, this would be done via an API call
    // For now, let's simulate finding a driver

    // Create a mock driver
    final _mockDriver = DriverModel(
      id: '1',
      name: 'John Doe',
      phoneNumber: '+1234567890',
      rating: 4.8,
      totalRides: 120,
      photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      vehicle: VehicleInfo(
        model: 'Toyota Camry',
        color: 'White',
        licensePlate: 'ABC123',
        type: 'sedan',
      ),
    );

    setState(() {
      _isSearching = false;
      _driverFound = true;
      _driver = _mockDriver;
    });

    // Automatically navigate to ride tracking after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.push('/ride_tracking');
      }
    });
  }

  void _cancelSearch() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Ride?'),
            content: const Text(
              'Are you sure you want to cancel your ride request?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate back to home
                  context.go('/home');
                },
                child: const Text('Yes'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSearching ? "Finding Driver" : "Driver Found"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSearching) ...[
                // Loading animation (placeholder)
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                        strokeWidth: 6.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  "Searching for a driver...",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  "Please wait while we find a driver near you.",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "Search time: ${_formatSearchTime(_searchTimeInSeconds)}",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),

                const Spacer(),

                CustomButton(
                  text: "Cancel",
                  isOutlined: true,
                  onPressed: _cancelSearch,
                ),
              ] else if (_driverFound && _driver != null) ...[
                // Driver found animation (placeholder)
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  "Driver Found!",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Driver card
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
                      // Driver info
                      Row(
                        children: [
                          // Driver photo (placeholder)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Driver details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _driver!.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${_driver!.rating}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "(${_driver!.totalRides} rides)",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Call button
                          IconButton(
                            icon: const Icon(Icons.phone),
                            color: AppTheme.primaryColor,
                            onPressed: () {
                              // Handle phone call
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Vehicle info
                      Row(
                        children: [
                          // Vehicle icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.directions_car,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Vehicle details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_driver!.vehicle.color} ${_driver!.vehicle.model}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _driver!.vehicle.licensePlate,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Your driver is on the way",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Cancel button
                CustomButton(
                  text: "Cancel Ride",
                  isOutlined: true,
                  onPressed: _cancelSearch,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatSearchTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

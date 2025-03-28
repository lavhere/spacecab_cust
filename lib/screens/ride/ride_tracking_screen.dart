import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/theme.dart';
import '../../models/driver_model.dart';
import '../../models/location_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  // Mock data
  final String _pickupAddress = "123 Main St, San Francisco, CA";
  final String _dropoffAddress = "456 Market St, San Francisco, CA";
  final int _estimatedTime = 12; // in minutes
  DriverModel _driver = DriverModel(
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
    currentLocation: LocationModel(
      latitude: AppConstants.defaultLatitude - 0.003,
      longitude: AppConstants.defaultLongitude - 0.003,
      address: "123 Main St",
    ),
  );

  // Ride status
  String _rideStatus = "Driver is arriving"; // or "In Progress", "Almost there"
  double _rideProgress = 0.3; // 0.0 to 1.0

  // Markers for the map
  Set<Marker> _markers = {};
  // Polyline for the route
  Set<Polyline> _polylines = {};

  // Initial camera position (San Francisco)
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: 14.0,
  );

  late Timer _rideProgressTimer;

  @override
  void initState() {
    super.initState();

    // Add markers for pickup, dropoff, and driver
    _addMarkers();

    // Add a simulated route
    _addRoute();

    // Simulate ride progress
    _rideProgressTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if (_rideProgress < 0.5) {
          _rideProgress += 0.1;
          _rideStatus = "Driver is arriving";
        } else if (_rideProgress < 0.8) {
          _rideProgress += 0.1;
          _rideStatus = "In Progress";
        } else if (_rideProgress < 1.0) {
          _rideProgress += 0.1;
          _rideStatus = "Almost there";
        } else {
          _rideProgressTimer.cancel();
          _showRideCompletedDialog();
        }

        // Update driver position (simulate movement)
        _updateDriverPosition();
      });
    });
  }

  @override
  void dispose() {
    _rideProgressTimer.cancel();
    super.dispose();
  }

  void _addMarkers() {
    setState(() {
      // Pickup marker
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(
            AppConstants.defaultLatitude,
            AppConstants.defaultLongitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'Pickup'),
        ),
      );

      // Dropoff marker
      _markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: LatLng(
            AppConstants.defaultLatitude + 0.01,
            AppConstants.defaultLongitude + 0.01,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Dropoff'),
        ),
      );

      // Driver marker
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            _driver.currentLocation!.latitude,
            _driver.currentLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(title: 'Driver: ${_driver.name}'),
        ),
      );
    });
  }

  void _addRoute() {
    // In a real app, we would get the actual route from a directions API
    // For now, let's create a simple straight line
    List<LatLng> routePoints = [
      LatLng(
        _driver.currentLocation!.latitude,
        _driver.currentLocation!.longitude,
      ),
      LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
      LatLng(
        AppConstants.defaultLatitude + 0.01,
        AppConstants.defaultLongitude + 0.01,
      ),
    ];

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: AppTheme.primaryColor,
          width: 4,
        ),
      );
    });
  }

  void _updateDriverPosition() {
    // In a real app, this would come from real-time location updates
    // For simplicity, let's move the driver closer to the pickup/dropoff based on progress
    double newLat, newLng;

    if (_rideProgress < 0.5) {
      // Moving toward pickup
      newLat = _driver.currentLocation!.latitude + 0.001;
      newLng = _driver.currentLocation!.longitude + 0.001;
    } else {
      // Moving toward dropoff
      newLat = AppConstants.defaultLatitude + (_rideProgress - 0.5) * 0.02;
      newLng = AppConstants.defaultLongitude + (_rideProgress - 0.5) * 0.02;
    }

    // Create a new location model
    LocationModel newLocation = LocationModel(
      latitude: newLat,
      longitude: newLng,
      address: _driver.currentLocation!.address,
    );

    // Update driver using copyWith since currentLocation is final
    _driver = _driver.copyWith(currentLocation: newLocation);

    // Update driver marker
    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'driver');
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            _driver.currentLocation!.latitude,
            _driver.currentLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(title: 'Driver: ${_driver.name}'),
        ),
      );
    });

    // Update the camera position to follow the driver
    if (_mapController.isCompleted) {
      _mapController.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(newLat, newLng)),
        );
      });
    }
  }

  void _showRideCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Ride Completed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('You have arrived at your destination!'),
                const SizedBox(height: 8),
                const Text('How was your ride?'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      icon: Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        color: index < 4 ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        // Handle rating
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/payment_confirmation');
                },
                child: const Text('Submit & Continue'),
              ),
            ],
          ),
    );
  }

  void _cancelRide() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Ride?'),
            content: const Text('Are you sure you want to cancel your ride?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
      body: Stack(
        children: [
          // Map view
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            mapType: MapType.normal,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),

          // Bottom sheet with ride details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: _rideProgress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Ride status
                  Text(
                    _rideStatus,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ETA
                  Text(
                    "ETA: ${(_estimatedTime * (1 - _rideProgress)).ceil()} mins",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Driver info
                  Row(
                    children: [
                      // Driver photo (placeholder)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
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
                              _driver.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${_driver.vehicle.color} ${_driver.vehicle.model} · ${_driver.vehicle.licensePlate}",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Contact buttons
                      Row(
                        children: [
                          // Message button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.message),
                              iconSize: 20,
                              color: AppTheme.primaryColor,
                              onPressed: () {
                                // Handle message
                              },
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Call button
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.phone),
                              iconSize: 20,
                              color: AppTheme.primaryColor,
                              onPressed: () {
                                // Handle call
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Location info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Pickup location
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _pickupAddress,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Container(
                            width: 1,
                            height: 16,
                            color: Colors.grey.shade300,
                          ),
                        ),

                        // Dropoff location
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _dropoffAddress,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      // SOS button
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          text: "SOS",
                          isOutlined: true,
                          backgroundColor: Colors.white,
                          textColor: Colors.red,
                          icon: Icons.sos,
                          onPressed: () {
                            // Show SOS options
                            showModalBottomSheet(
                              context: context,
                              builder:
                                  (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.local_police,
                                          color: Colors.blue,
                                        ),
                                        title: const Text('Contact Police'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.medical_services,
                                          color: Colors.red,
                                        ),
                                        title: const Text('Medical Emergency'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.support_agent,
                                          color: Colors.green,
                                        ),
                                        title: const Text('Contact Support'),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Cancel button
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          text: "Cancel Ride",
                          isOutlined: true,
                          onPressed: _cancelRide,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

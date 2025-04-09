import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/theme.dart';
import '../../models/driver_model.dart';
import '../../models/location_model.dart';

class RideTrackingScreen extends StatefulWidget {
  final LocationModel pickupLocation;
  final LocationModel dropoffLocation;
  final DriverModel driver;

  const RideTrackingScreen({
    Key? key,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.driver,
  }) : super(key: key);

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isDriverArrived = false;
  bool _isEnRoute = false;
  String _estimatedTime = '5 mins';
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _mapController.future;
    _updateMapMarkers();
  }

  void _startLocationUpdates() {
    // In a real app, this would be connected to a real-time location service
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateMapMarkers();
    });
  }

  void _updateMapMarkers() {
    setState(() {
      _markers.clear();
      _polylines.clear();

      // Add driver marker
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            widget.driver.currentLocation!.latitude,
            widget.driver.currentLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(title: 'Driver', snippet: widget.driver.name),
        ),
      );

      // Add pickup marker
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(
            widget.pickupLocation.latitude,
            widget.pickupLocation.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
        ),
      );

      // Add dropoff marker
      _markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: LatLng(
            widget.dropoffLocation.latitude,
            widget.dropoffLocation.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Dropoff Location'),
        ),
      );

      // Add route polyline
      if (_isEnRoute) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [
              LatLng(
                widget.pickupLocation.latitude,
                widget.pickupLocation.longitude,
              ),
              LatLng(
                widget.dropoffLocation.latitude,
                widget.dropoffLocation.longitude,
              ),
            ],
            color: AppTheme.primaryColor,
            width: 5,
          ),
        );
      } else {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [
              LatLng(
                widget.driver.currentLocation!.latitude,
                widget.driver.currentLocation!.longitude,
              ),
              LatLng(
                widget.pickupLocation.latitude,
                widget.pickupLocation.longitude,
              ),
            ],
            color: AppTheme.primaryColor,
            width: 5,
          ),
        );
      }
    });
  }

  void _simulateDriverArrival() {
    setState(() {
      _isDriverArrived = true;
    });
  }

  void _startRide() {
    setState(() {
      _isEnRoute = true;
    });
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
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.pickupLocation.latitude,
                widget.pickupLocation.longitude,
              ),
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
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

          // Bottom sheet
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
                  // Driver info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(widget.driver.photoUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.driver.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.driver.rating.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _estimatedTime,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppTheme.primaryColor),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Vehicle info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.driver.vehicle.model} (${widget.driver.vehicle.color})',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                widget.driver.vehicle.licensePlate,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  if (!_isDriverArrived)
                    ElevatedButton(
                      onPressed: _simulateDriverArrival,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Driver Arrived'),
                    )
                  else if (!_isEnRoute)
                    ElevatedButton(
                      onPressed: _startRide,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Start Ride'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _showRideCompletedDialog,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('End Ride'),
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

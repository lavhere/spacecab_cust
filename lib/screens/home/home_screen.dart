import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/driver_model.dart';
import '../../models/location_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  // Default location (San Francisco)
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: AppConstants.defaultMapZoom,
  );

  Set<Marker> _markers = {};
  bool _isLoading = true;
  bool _locationPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _getCurrentLocation();
    _loadNearbyDrivers();
  }

  Future<void> _initializeMap() async {
    // Wait for the map to be ready
    await _mapController.future;

    // For web platform, ensure the map is properly initialized
    if (kIsWeb) {
      // Add a small delay to ensure the map is fully loaded
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _locationPermissionDenied = true;
            _isLoading = false;
          });
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update camera position
      final CameraPosition newPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: AppConstants.defaultMapZoom,
      );

      // Add current location marker
      setState(() {
        _initialCameraPosition = newPosition;
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        _isLoading = false;
      });

      // Move camera to current location
      if (_mapController.isCompleted) {
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppConstants.locationPermissionDeniedMessage)),
      );
    }
  }

  void _loadNearbyDrivers() {
    // In a real app, you would fetch nearby drivers from an API
    // For now, we'll add some mock drivers

    final List<DriverModel> nearbyDrivers = [
      DriverModel(
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
          latitude: AppConstants.defaultLatitude + 0.001,
          longitude: AppConstants.defaultLongitude + 0.001,
          address: '123 Main St',
        ),
      ),
      DriverModel(
        id: '2',
        name: 'Jane Smith',
        phoneNumber: '+0987654321',
        rating: 4.9,
        totalRides: 200,
        photoUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
        vehicle: VehicleInfo(
          model: 'Honda Civic',
          color: 'Black',
          licensePlate: 'XYZ789',
          type: 'sedan',
        ),
        currentLocation: LocationModel(
          latitude: AppConstants.defaultLatitude - 0.001,
          longitude: AppConstants.defaultLongitude - 0.001,
          address: '456 Elm St',
        ),
      ),
    ];

    // Add driver markers
    setState(() {
      for (var driver in nearbyDrivers) {
        if (driver.currentLocation != null) {
          _markers.add(
            Marker(
              markerId: MarkerId('driver_${driver.id}'),
              position: LatLng(
                driver.currentLocation!.latitude,
                driver.currentLocation!.longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange,
              ),
              infoWindow: InfoWindow(
                title: driver.name,
                snippet: '${driver.vehicle.model} (${driver.vehicle.color})',
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
          ),

          // Top search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  LocationModel pickupLocation;
                  try {
                    final currentLocationMarker = _markers.firstWhere(
                      (marker) => marker.markerId.value == 'current_location',
                    );
                    pickupLocation = LocationModel(
                      latitude: currentLocationMarker.position.latitude,
                      longitude: currentLocationMarker.position.longitude,
                      address: 'Current Location',
                    );
                  } catch (e) {
                    // If no current location marker is found, use the default location
                    pickupLocation = LocationModel(
                      latitude: AppConstants.defaultLatitude,
                      longitude: AppConstants.defaultLongitude,
                      address: 'Default Location',
                    );
                  }
                  // Convert LocationModel to Map for navigation
                  final Map<String, dynamic> locationData = {
                    'latitude': pickupLocation.latitude,
                    'longitude': pickupLocation.longitude,
                    'address': pickupLocation.address,
                  };
                  context.push('/destination-selection', extra: locationData);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.textSecondaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Where to?",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // Location permission denied message
          if (_locationPermissionDenied)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_off, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "Location Permission Denied",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.locationPermissionDeniedMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _locationPermissionDenied = false;
                          _isLoading = true;
                        });
                        _getCurrentLocation();
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom ride request card
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.star, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ride with SpaceCab",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              "Get a ride in minutes",
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Material(
                      color: AppTheme.backgroundColor,
                      child: InkWell(
                        onTap: () {
                          context.push('/location_selection');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Where to?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // My location button
          FloatingActionButton(
            heroTag: 'my_location',
            mini: true,
            onPressed: _getCurrentLocation,
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 100), // Space for the bottom card
        ],
      ),
    );
  }
}

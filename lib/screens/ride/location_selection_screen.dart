import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/theme.dart';
import '../../models/location_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();

  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropoffFocusNode = FocusNode();

  LocationModel? _pickupLocation;
  LocationModel? _dropoffLocation;

  bool get _canProceed => _pickupLocation != null && _dropoffLocation != null;

  // Mock recent locations
  final List<LocationModel> _recentLocations = [
    LocationModel(
      address: "Home - 123 Main St, San Francisco, CA",
      latitude: AppConstants.defaultLatitude - 0.01,
      longitude: AppConstants.defaultLongitude - 0.01,
    ),
    LocationModel(
      address: "Work - 456 Market St, San Francisco, CA",
      latitude: AppConstants.defaultLatitude + 0.02,
      longitude: AppConstants.defaultLongitude + 0.01,
    ),
    LocationModel(
      address: "Gym - 789 Oak St, San Francisco, CA",
      latitude: AppConstants.defaultLatitude - 0.015,
      longitude: AppConstants.defaultLongitude + 0.02,
    ),
  ];

  // Mock search results
  final List<LocationModel> _searchResults = [];

  @override
  void initState() {
    super.initState();

    // Listen for focus changes
    _pickupFocusNode.addListener(_onPickupFocusChange);
    _dropoffFocusNode.addListener(_onDropoffFocusChange);

    // Listen for text changes
    _pickupController.addListener(_onPickupTextChange);
    _dropoffController.addListener(_onDropoffTextChange);
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _pickupFocusNode.dispose();
    _dropoffFocusNode.dispose();
    super.dispose();
  }

  void _onPickupFocusChange() {
    if (_pickupFocusNode.hasFocus) {
      _updateSearchResults(true);
    }
  }

  void _onDropoffFocusChange() {
    if (_dropoffFocusNode.hasFocus) {
      _updateSearchResults(false);
    }
  }

  void _onPickupTextChange() {
    if (_pickupFocusNode.hasFocus) {
      _updateSearchResults(true);
    }
  }

  void _onDropoffTextChange() {
    if (_dropoffFocusNode.hasFocus) {
      _updateSearchResults(false);
    }
  }

  void _updateSearchResults(bool isPickup) {
    // In a real app, this would perform a search based on the input
    // For demo, we'll filter our mock data
    final searchText =
        isPickup
            ? _pickupController.text.toLowerCase()
            : _dropoffController.text.toLowerCase();

    if (searchText.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // Generate mock search results based on input
      setState(() {
        _searchResults.clear();
        _searchResults.addAll([
          LocationModel(
            address: "123 $searchText Ave, San Francisco, CA",
            latitude: AppConstants.defaultLatitude + 0.01,
            longitude: AppConstants.defaultLongitude - 0.01,
          ),
          LocationModel(
            address: "456 $searchText St, San Francisco, CA",
            latitude: AppConstants.defaultLatitude - 0.02,
            longitude: AppConstants.defaultLongitude + 0.02,
          ),
          LocationModel(
            address: "789 $searchText Blvd, San Francisco, CA",
            latitude: AppConstants.defaultLatitude + 0.03,
            longitude: AppConstants.defaultLongitude + 0.01,
          ),
        ]);
      });
    });
  }

  void _selectLocation(LocationModel location, bool isPickup) {
    setState(() {
      if (isPickup) {
        _pickupLocation = location;
        _pickupController.text = location.address;
        _pickupFocusNode.unfocus();

        // If dropoff is empty, focus on it
        if (_dropoffLocation == null) {
          _dropoffFocusNode.requestFocus();
        }
      } else {
        _dropoffLocation = location;
        _dropoffController.text = location.address;
        _dropoffFocusNode.unfocus();
      }

      _searchResults.clear();
    });
  }

  void _swapLocations() {
    if (_pickupLocation == null && _dropoffLocation == null) return;

    setState(() {
      final tempLocation = _pickupLocation;
      _pickupLocation = _dropoffLocation;
      _dropoffLocation = tempLocation;

      _pickupController.text = _pickupLocation?.address ?? '';
      _dropoffController.text = _dropoffLocation?.address ?? '';
    });
  }

  void _proceedToRideOptions() {
    if (!_canProceed) return;

    context.go('/ride-options');
  }

  @override
  Widget build(BuildContext context) {
    final bool showSearchResults =
        (_pickupFocusNode.hasFocus || _dropoffFocusNode.hasFocus) &&
        _searchResults.isNotEmpty;

    final bool showRecentLocations =
        (_pickupFocusNode.hasFocus || _dropoffFocusNode.hasFocus) &&
        _searchResults.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Set Location')),
      body: Column(
        children: [
          // Location input fields
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                // Pickup input
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _pickupController,
                        focusNode: _pickupFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Pickup Location',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                    if (_pickupController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _pickupController.clear();
                            _pickupLocation = null;
                          });
                        },
                      ),
                  ],
                ),

                const Divider(),

                // Dropoff input
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _dropoffController,
                        focusNode: _dropoffFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Dropoff Location',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                    if (_dropoffController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _dropoffController.clear();
                            _dropoffLocation = null;
                          });
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Swap button
                GestureDetector(
                  onTap: _swapLocations,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.swap_vert, color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),

          // Map or location suggestions
          Expanded(
            child: Stack(
              children: [
                // Map
                if (!showSearchResults && !showRecentLocations) _buildMap(),

                // Search results
                if (showSearchResults) _buildSearchResults(),

                // Recent locations
                if (showRecentLocations) _buildRecentLocations(),
              ],
            ),
          ),

          // Bottom button
          if (!_pickupFocusNode.hasFocus && !_dropoffFocusNode.hasFocus)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: CustomButton(
                text: 'Continue',
                onPressed: _canProceed ? _proceedToRideOptions : () {},
                backgroundColor: _canProceed ? null : Colors.grey.shade400,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          AppConstants.defaultLatitude,
          AppConstants.defaultLongitude,
        ),
        zoom: 14,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      markers: {
        if (_pickupLocation != null)
          Marker(
            markerId: const MarkerId('pickup'),
            position: LatLng(
              _pickupLocation!.latitude,
              _pickupLocation!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        if (_dropoffLocation != null)
          Marker(
            markerId: const MarkerId('dropoff'),
            position: LatLng(
              _dropoffLocation!.latitude,
              _dropoffLocation!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
      },
    );
  }

  Widget _buildSearchResults() {
    final isPickupFocused = _pickupFocusNode.hasFocus;

    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.location_on, color: AppTheme.primaryColor),
          ),
          title: Text(
            location.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'San Francisco, CA',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          onTap: () => _selectLocation(location, isPickupFocused),
        );
      },
    );
  }

  Widget _buildRecentLocations() {
    final isPickupFocused = _pickupFocusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Recent Locations',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: _recentLocations.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final location = _recentLocations[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.history, color: Colors.grey),
                ),
                title: Text(
                  location.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'Recent address',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                onTap: () => _selectLocation(location, isPickupFocused),
              );
            },
          ),
        ),
      ],
    );
  }
}

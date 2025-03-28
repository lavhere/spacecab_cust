import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/location_model.dart';
import '../../widgets/location_search_box.dart';
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

  LocationModel? _pickupLocation;
  LocationModel? _dropoffLocation;

  final List<LocationModel> _recentLocations = [
    LocationModel(
      latitude: 37.7749,
      longitude: -122.4194,
      address: '123 Main St, San Francisco, CA',
      name: 'Home',
      placeId: 'place_id_1',
    ),
    LocationModel(
      latitude: 37.7833,
      longitude: -122.4167,
      address: '456 Market St, San Francisco, CA',
      name: 'Work',
      placeId: 'place_id_2',
    ),
    LocationModel(
      latitude: 37.8029,
      longitude: -122.4058,
      address: 'Pier 39, San Francisco, CA',
      name: 'Pier 39',
      placeId: 'place_id_3',
    ),
  ];

  final List<LocationModel> _suggestions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    // Set default pickup location to "Current Location"
    _pickupController.text = "Current Location";
    _pickupLocation = LocationModel(
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      address: "Current Location",
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  void _searchLocations(String query) {
    // In a real app, you would call a Places API here
    // For now, we'll just simulate a search with a delay

    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        setState(() {
          _suggestions.clear();
          _isSearching = false;
        });
        return;
      }

      // Mock suggestions based on query
      final mockSuggestions = [
        LocationModel(
          latitude: 37.7860,
          longitude: -122.4008,
          address: '$query Street, San Francisco, CA',
          name: '$query Street',
          placeId: 'place_id_${query.hashCode}_1',
        ),
        LocationModel(
          latitude: 37.7870,
          longitude: -122.4000,
          address: '$query Avenue, San Francisco, CA',
          name: '$query Avenue',
          placeId: 'place_id_${query.hashCode}_2',
        ),
        LocationModel(
          latitude: 37.7880,
          longitude: -122.4010,
          address: '$query Plaza, San Francisco, CA',
          name: '$query Plaza',
          placeId: 'place_id_${query.hashCode}_3',
        ),
      ];

      setState(() {
        _suggestions.clear();
        _suggestions.addAll(mockSuggestions);
        _isSearching = false;
      });
    });
  }

  void _selectLocation(LocationModel location, bool isPickup) {
    setState(() {
      if (isPickup) {
        _pickupLocation = location;
        _pickupController.text = location.name ?? location.address;
      } else {
        _dropoffLocation = location;
        _dropoffController.text = location.name ?? location.address;
      }
      _suggestions.clear();
    });
  }

  void _confirmLocations() {
    if (_pickupLocation == null || _dropoffLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both pickup and drop-off locations'),
        ),
      );
      return;
    }

    // In a real app, you would store the selected locations
    // For now, we'll just navigate to the ride options screen
    context.push('/ride_options');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Location"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Pickup and Dropoff inputs
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Pickup location
                LocationSearchBox(
                  controller: _pickupController,
                  hintText: "Pickup location",
                  prefixIcon: Icons.location_on,
                  readOnly: true,
                  onTap: () {
                    // Set focus to pickup input
                    _pickupController.clear();
                    _suggestions.clear();
                  },
                  onChanged: _searchLocations,
                ),

                const SizedBox(height: 16),

                // Dropoff location
                LocationSearchBox(
                  controller: _dropoffController,
                  hintText: "Where to?",
                  prefixIcon: Icons.location_searching,
                  onTap: () {
                    // Set focus to dropoff input
                    _suggestions.clear();
                  },
                  onChanged: _searchLocations,
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1),

          // Suggestions or recent locations
          Expanded(
            child:
                _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _suggestions.isNotEmpty
                    ? _buildSuggestionsList()
                    : _buildRecentLocations(),
          ),

          // Confirm button (shown only when both locations are selected)
          if (_pickupLocation != null && _dropoffLocation != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: CustomButton(
                text: "Confirm",
                onPressed: _confirmLocations,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(suggestion.name ?? 'Unknown'),
          subtitle: Text(
            suggestion.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            _selectLocation(
              suggestion,
              _dropoffController
                  .text
                  .isEmpty, // If dropoff is empty, we're setting the pickup
            );
          },
        );
      },
    );
  }

  Widget _buildRecentLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved places section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Saved Places",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Saved locations
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentLocations.length,
          itemBuilder: (context, index) {
            final location = _recentLocations[index];
            return ListTile(
              leading: Icon(
                location.name == 'Home'
                    ? Icons.home
                    : location.name == 'Work'
                    ? Icons.work
                    : Icons.star,
                color: AppTheme.primaryColor,
              ),
              title: Text(location.name ?? 'Unknown'),
              subtitle: Text(
                location.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                _selectLocation(
                  location,
                  _dropoffController
                      .text
                      .isEmpty, // If dropoff is empty, we're setting the pickup
                );
              },
            );
          },
        ),

        const Divider(),

        // Recent locations section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Recent Locations",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Map button
        ListTile(
          leading: const Icon(Icons.map_outlined),
          title: const Text("Set location on map"),
          onTap: () {
            // Open map to set location
          },
        ),

        // Current location button
        ListTile(
          leading: Icon(Icons.my_location, color: AppTheme.primaryColor),
          title: const Text("Current location"),
          onTap: () {
            _selectLocation(
              LocationModel(
                latitude: AppConstants.defaultLatitude,
                longitude: AppConstants.defaultLongitude,
                address: "Current Location",
              ),
              _dropoffController
                  .text
                  .isEmpty, // If dropoff is empty, we're setting the pickup
            );
          },
        ),
      ],
    );
  }
}

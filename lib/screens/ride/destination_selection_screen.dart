import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/location_search_box.dart';
import '../../models/location_model.dart';

class DestinationSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> pickupLocation;

  const DestinationSelectionScreen({Key? key, required this.pickupLocation})
    : super(key: key);

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<LocationModel> _recentDestinations = [
    LocationModel(
      latitude: 37.7749,
      longitude: -122.4194,
      address: 'MG Road, Bangalore',
    ),
    LocationModel(
      latitude: 12.9716,
      longitude: 77.5946,
      address: 'Indiranagar, Bangalore',
    ),
  ];
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecentDestinations();
  }

  void _loadRecentDestinations() {
    // In a real app, you would load this from local storage or an API
    setState(() {
      _recentDestinations;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      // Mock search results
      setState(() {
        _searchResults = [
          LocationModel(
            latitude: 12.9716,
            longitude: 77.5946,
            address: '$query, Bangalore',
          ),
          LocationModel(
            latitude: 12.9516,
            longitude: 77.5991,
            address: '$query Market, Bangalore',
          ),
        ];
        _isSearching = false;
      });
    });
  }

  void _selectDestination(LocationModel destination) {
    // Navigate to ride options screen with both locations
    context.push(
      '/ride-options',
      extra: {
        'pickup': widget.pickupLocation,
        'destination': {
          'latitude': destination.latitude,
          'longitude': destination.longitude,
          'address': destination.address,
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Where to?'), centerTitle: true),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search destination',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _handleSearch,
            ),
          ),

          // Search results or recent destinations
          Expanded(
            child:
                _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isNotEmpty
                    ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final destination = _searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(destination.address),
                          onTap: () => _selectDestination(destination),
                        );
                      },
                    )
                    : ListView.builder(
                      itemCount: _recentDestinations.length,
                      itemBuilder: (context, index) {
                        final destination = _recentDestinations[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(destination.address),
                          onTap: () => _selectDestination(destination),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

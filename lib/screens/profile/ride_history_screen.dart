import 'package:flutter/material.dart';

import '../../config/theme.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({Key? key}) : super(key: key);

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _completedRides = [
    {
      'id': 'R12345',
      'date': '2023-11-15',
      'time': '14:30',
      'pickupAddress': '123 Main St, San Francisco, CA',
      'dropoffAddress': '456 Market St, San Francisco, CA',
      'driverName': 'John Doe',
      'fare': 24.50,
      'rating': 5,
      'paymentMethod': 'Credit Card',
      'status': 'completed',
    },
    {
      'id': 'R12346',
      'date': '2023-11-12',
      'time': '09:15',
      'pickupAddress': '789 Oak Ave, San Francisco, CA',
      'dropoffAddress': '101 Pine St, San Francisco, CA',
      'driverName': 'Jane Smith',
      'fare': 18.75,
      'rating': 4,
      'paymentMethod': 'PayPal',
      'status': 'completed',
    },
    {
      'id': 'R12347',
      'date': '2023-11-08',
      'time': '19:45',
      'pickupAddress': '222 Valencia St, San Francisco, CA',
      'dropoffAddress': '555 Mission St, San Francisco, CA',
      'driverName': 'Mike Johnson',
      'fare': 32.20,
      'rating': 5,
      'paymentMethod': 'Credit Card',
      'status': 'completed',
    },
    {
      'id': 'R12348',
      'date': '2023-11-05',
      'time': '11:30',
      'pickupAddress': '333 Bryant St, San Francisco, CA',
      'dropoffAddress': '777 Folsom St, San Francisco, CA',
      'driverName': 'Sara Wilson',
      'fare': 15.80,
      'rating': 3,
      'paymentMethod': 'PayPal',
      'status': 'completed',
    },
  ];

  final List<Map<String, dynamic>> _cancelledRides = [
    {
      'id': 'R12349',
      'date': '2023-11-14',
      'time': '16:20',
      'pickupAddress': '444 Harrison St, San Francisco, CA',
      'status': 'cancelled',
      'cancellationReason': 'Driver unavailable',
      'cancellationFee': 5.00,
    },
    {
      'id': 'R12350',
      'date': '2023-11-10',
      'time': '08:45',
      'pickupAddress': '666 Townsend St, San Francisco, CA',
      'status': 'cancelled',
      'cancellationReason': 'Changed plans',
      'cancellationFee': 0.00,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Completed'), Tab(text: 'Cancelled')],
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Completed rides tab
          _buildRidesList(_completedRides, isCompleted: true),

          // Cancelled rides tab
          _buildRidesList(_cancelledRides, isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildRidesList(
    List<Map<String, dynamic>> rides, {
    required bool isCompleted,
  }) {
    if (rides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.directions_car : Icons.cancel,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted ? 'No completed rides yet' : 'No cancelled rides',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        return _buildRideCard(ride, isCompleted);
      },
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride date and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ride['date']} at ${ride['time']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'ID: ${ride['id']}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),

            const Divider(height: 24),

            // Ride details
            if (isCompleted) ...[
              // For completed rides
              _buildLocationInfo(
                pickup: ride['pickupAddress'],
                dropoff: ride['dropoffAddress'],
              ),

              const SizedBox(height: 16),

              // Driver and payment info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Driver',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride['driverName'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ride['paymentMethod'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Fare and rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${ride['fare'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < ride['rating']
                              ? Icons.star
                              : Icons.star_border,
                          color:
                              index < ride['rating']
                                  ? Colors.amber
                                  : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.receipt),
                      label: const Text('Receipt'),
                      onPressed: () {
                        // Show receipt
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Help'),
                      onPressed: () {
                        // Show help options
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // For cancelled rides
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.cancel, color: Colors.red, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cancelled',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Reason: ${ride['cancellationReason']}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Show pickup location
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
                      child: Icon(Icons.circle, color: Colors.green, size: 10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          ride['pickupAddress'],
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cancellation fee
              if (ride['cancellationFee'] > 0)
                Text(
                  'Cancellation Fee: \$${ride['cancellationFee'].toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

              const SizedBox(height: 16),

              // Help button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Get Help'),
                  onPressed: () {
                    // Show help options
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo({required String pickup, required String dropoff}) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.circle, color: Colors.green, size: 8),
              ),
            ),
            Container(width: 2, height: 30, color: Colors.grey.shade300),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.location_on, color: Colors.red, size: 8),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pickup',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    pickup,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dropoff',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    dropoff,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

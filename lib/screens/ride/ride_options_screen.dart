import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../models/ride_type_model.dart';
import '../../widgets/custom_button.dart';

class RideOptionsScreen extends StatefulWidget {
  const RideOptionsScreen({Key? key}) : super(key: key);

  @override
  State<RideOptionsScreen> createState() => _RideOptionsScreenState();
}

class _RideOptionsScreenState extends State<RideOptionsScreen> {
  final List<RideTypeModel> _rideTypes = RideTypeModel.getSampleRideTypes();
  int _selectedRideTypeIndex = 0;

  // Mock data
  final String _pickupAddress = "123 Main St, San Francisco, CA";
  final String _dropoffAddress = "456 Market St, San Francisco, CA";
  final double _distance = 3.2; // in km
  final int _estimatedTime = 12; // in minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Ride"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Ride info summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Locations
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.circle,
                          color: AppTheme.primaryColor,
                          size: 12,
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: Colors.grey.shade300,
                        ),
                        Icon(
                          Icons.location_on,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pickup
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),

                          // Dropoff
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Go back to location selection
                        context.pop();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Trip info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Distance
                    Row(
                      children: [
                        Icon(
                          Icons.map,
                          color: AppTheme.textSecondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$_distance km",
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppTheme.textSecondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$_estimatedTime mins",
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    // Payment method
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: AppTheme.textSecondaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Cash",
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Available ride types
          Expanded(
            child: ListView.builder(
              itemCount: _rideTypes.length,
              itemBuilder: (context, index) {
                final rideType = _rideTypes[index];
                final isSelected = index == _selectedRideTypeIndex;

                // Calculate fare for this ride type
                final fare = _calculateFare(rideType);

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedRideTypeIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? rideType.color.withOpacity(0.1)
                              : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Ride type icon (placeholder using a Container)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: rideType.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.directions_car,
                              color: rideType.color,
                              size: 32,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Ride type details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rideType.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rideType.description,
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppTheme.textSecondaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${rideType.maxPassengers} persons",
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.access_time,
                                    color: AppTheme.textSecondaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${rideType.estimatedArrivalTime} mins",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${fare.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? rideType.color
                                        : AppTheme.textPrimaryColor,
                              ),
                            ),
                            Radio<int>(
                              value: index,
                              groupValue: _selectedRideTypeIndex,
                              activeColor: rideType.color,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRideTypeIndex = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Request ride button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Promo code row
                Row(
                  children: [
                    Icon(
                      Icons.discount,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Apply Promo Code",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.textSecondaryColor,
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Request ride button
                CustomButton(
                  text: "Request ${_rideTypes[_selectedRideTypeIndex].name}",
                  onPressed: () {
                    // Navigate to ride confirmation screen
                    context.push('/ride_confirmation');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calculate fare based on distance and ride type
  double _calculateFare(RideTypeModel rideType) {
    return rideType.baseFare +
        (_distance * rideType.pricePerKm) +
        (_estimatedTime * rideType.pricePerMinute);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showContent = false;

  // Mock payment details
  final Map<String, dynamic> _paymentDetails = {
    'id': 'P12345678',
    'amount': 26.10,
    'date': '2023-11-15',
    'time': '14:35',
    'method': 'Visa **** 4567',
    'status': 'Completed',
  };

  // Mock ride details
  final Map<String, dynamic> _rideDetails = {
    'id': 'R87654321',
    'driver': 'John Doe',
    'vehicle': 'Toyota Camry, White',
    'licensePlate': 'ABC123',
    'pickupAddress': '123 Main St, San Francisco, CA',
    'dropoffAddress': '456 Market St, San Francisco, CA',
    'rideDate': '2023-11-15',
    'rideTime': '14:05',
    'distance': '7.8 miles',
    'duration': '25 mins',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start animation and show content after delay
    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                !_showContent
                    ? _buildLoadingAnimation()
                    : _buildConfirmationContent(),
          ),

          // Bottom buttons
          if (_showContent)
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
              child: Column(
                children: [
                  CustomButton(
                    text: 'Rate Your Ride',
                    onPressed: () {
                      _showRatingDialog();
                    },
                  ),

                  const SizedBox(height: 12),

                  CustomButton(
                    text: 'Back to Home',
                    onPressed: () {
                      context.go('/home');
                    },
                    backgroundColor: Colors.white,
                    textColor: AppTheme.primaryColor,
                    isOutlined: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/payment_success.json',
            controller: _animationController,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            onLoaded: (composition) {
              _animationController.duration = composition.duration;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Processing Payment...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success animation or icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.check_circle, color: Colors.green, size: 50),
            ),
          ),

          const SizedBox(height: 16),

          // Success message
          const Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Payment amount
          Text(
            '\$${_paymentDetails['amount'].toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 8),

          // Payment date and time
          Text(
            'Paid on ${_paymentDetails['date']} at ${_paymentDetails['time']}',
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 32),

          // Payment details card
          _buildDetailsCard(
            title: 'Payment Details',
            content: [
              _buildDetailRow('Payment ID', _paymentDetails['id']),
              _buildDetailRow('Method', _paymentDetails['method']),
              _buildDetailRow('Status', _paymentDetails['status']),
            ],
          ),

          const SizedBox(height: 24),

          // Ride details card
          _buildDetailsCard(
            title: 'Ride Details',
            content: [
              _buildDetailRow('Ride ID', _rideDetails['id']),
              _buildDetailRow('Driver', _rideDetails['driver']),
              _buildDetailRow('Vehicle', _rideDetails['vehicle']),
              _buildDetailRow('License Plate', _rideDetails['licensePlate']),
              const Divider(),
              _buildDetailRow('Pickup', _rideDetails['pickupAddress']),
              _buildDetailRow('Dropoff', _rideDetails['dropoffAddress']),
              const Divider(),
              _buildDetailRow(
                'Date & Time',
                '${_rideDetails['rideDate']} at ${_rideDetails['rideTime']}',
              ),
              _buildDetailRow('Distance', _rideDetails['distance']),
              _buildDetailRow('Duration', _rideDetails['duration']),
            ],
          ),

          const SizedBox(height: 24),

          // Support and receipt options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.receipt,
                label: 'Email Receipt',
                onTap: () {
                  // Send email receipt
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receipt sent to your email')),
                  );
                },
              ),
              _buildActionButton(
                icon: Icons.support_agent,
                label: 'Need Help?',
                onTap: () {
                  context.go('/support');
                },
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () {
                  // Share ride details
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing options opened')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard({
    required String title,
    required List<Widget> content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: AppTheme.primaryColor)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    int _rating = 0;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Rate Your Ride'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('How was your experience?'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color:
                                  index < _rating ? Colors.amber : Colors.grey,
                              size: 36,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a comment (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Skip'),
                    ),
                    ElevatedButton(
                      onPressed:
                          _rating > 0
                              ? () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Thank you for your feedback!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
          ),
    );
  }
}

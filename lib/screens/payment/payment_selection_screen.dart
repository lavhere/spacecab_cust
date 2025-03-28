import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String _selectedPaymentMethod = 'card_1'; // Default selected payment method

  // Mock payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card_1',
      'type': 'credit_card',
      'name': 'Visa •••• 4567',
      'icon': Icons.credit_card,
      'isDefault': true,
      'expiryDate': '12/25',
    },
    {
      'id': 'card_2',
      'type': 'credit_card',
      'name': 'Mastercard •••• 8901',
      'icon': Icons.credit_card,
      'isDefault': false,
      'expiryDate': '09/24',
    },
    {
      'id': 'paypal_1',
      'type': 'paypal',
      'name': 'PayPal',
      'icon': Icons.paypal,
      'isDefault': false,
      'email': 'user@example.com',
    },
    {
      'id': 'cash',
      'type': 'cash',
      'name': 'Cash',
      'icon': Icons.money,
      'isDefault': false,
    },
  ];

  // Mock fare details from ride options
  final Map<String, dynamic> _fareDetails = {
    'baseFare': 15.0,
    'distance': 7.8, // in miles
    'distanceCost': 5.85,
    'time': 25, // in minutes
    'timeCost': 3.75,
    'serviceFee': 1.5,
    'total': 26.10,
    'discountCode': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method'), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fare details card
                  _buildFareDetailsCard(),

                  const SizedBox(height: 24),

                  // Payment methods
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // List of payment methods
                  ..._paymentMethods.map(
                    (method) => _buildPaymentMethodItem(method),
                  ),

                  const SizedBox(height: 16),

                  // Add payment method button
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Payment Method'),
                    onPressed: () {
                      _showAddPaymentMethodBottomSheet();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Promo code
                  _buildPromoCodeSection(),
                ],
              ),
            ),
          ),

          // Bottom payment button
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
              text: 'Confirm Payment Method',
              onPressed: () {
                // Navigate to payment confirmation
                context.go('/payment_confirmation');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fare Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Base fare
            _buildFareRow(
              label: 'Base Fare',
              value: '\$${_fareDetails['baseFare'].toStringAsFixed(2)}',
            ),

            // Distance cost
            _buildFareRow(
              label: 'Distance (${_fareDetails['distance']} mi)',
              value: '\$${_fareDetails['distanceCost'].toStringAsFixed(2)}',
            ),

            // Time cost
            _buildFareRow(
              label: 'Time (${_fareDetails['time']} min)',
              value: '\$${_fareDetails['timeCost'].toStringAsFixed(2)}',
            ),

            // Service fee
            _buildFareRow(
              label: 'Service Fee',
              value: '\$${_fareDetails['serviceFee'].toStringAsFixed(2)}',
            ),

            // Discount
            if (_fareDetails['discountCode'] != null)
              _buildFareRow(
                label: 'Discount (${_fareDetails['discountCode']})',
                value:
                    '-\$${_fareDetails['discountAmount'].toStringAsFixed(2)}',
                valueColor: Colors.green,
              ),

            const Divider(height: 24),

            // Total
            _buildFareRow(
              label: 'Total',
              value: '\$${_fareDetails['total'].toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  valueColor ?? (isTotal ? Colors.black : Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(Map<String, dynamic> method) {
    final bool isSelected = _selectedPaymentMethod == method['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        value: method['id'],
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method['icon'],
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (method['type'] == 'credit_card')
                    Text(
                      'Expires ${method['expiryDate']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  if (method['type'] == 'paypal')
                    Text(
                      method['email'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (method['isDefault'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(fontSize: 12, color: AppTheme.primaryColor),
                ),
              ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promo Code',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter promo code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Apply promo code logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddPaymentMethodBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.credit_card, color: AppTheme.primaryColor),
                ),
                title: const Text('Add Credit/Debit Card'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add card screen
                  // In a real app, this would be a new screen with form fields
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.paypal, color: AppTheme.primaryColor),
                ),
                title: const Text('Connect PayPal'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to connect PayPal
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

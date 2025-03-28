import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedIssueType = 'Technical Issue';

  final List<String> _issueTypes = [
    'Technical Issue',
    'Payment Problem',
    'Driver Complaint',
    'Lost Item',
    'Account Help',
    'Other',
  ];

  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I update my payment information?',
      'answer':
          'To update your payment information, go to your Profile, tap on "Payment Methods", and then tap "Add" to add a new payment method or select an existing one to update it.',
    },
    {
      'question': 'What if I lost an item during my ride?',
      'answer':
          'If you\'ve lost an item during your ride, go to your Ride History, find the specific ride, and use the "Lost Item" option to contact your driver directly. Alternatively, you can create a support ticket from this screen.',
    },
    {
      'question': 'How can I change my pickup or dropoff location?',
      'answer':
          'You can change your pickup location before a driver accepts your ride request. Once a driver has accepted, you can message them through the app to request a slight change, but significant changes may require cancelling and requesting a new ride.',
    },
    {
      'question': 'Why was I charged a cancellation fee?',
      'answer':
          'Cancellation fees apply if you cancel a ride after it has been accepted by a driver and more than 2 minutes have passed. This compensates drivers for their time and fuel spent heading to your location.',
    },
    {
      'question': 'How do I request a specific driver?',
      'answer':
          'Currently, you cannot request a specific driver directly through the app. However, if you\'ve had a positive experience with a driver, you can add them to your favorites list for future reference.',
    },
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitSupportTicket() {
    if (_formKey.currentState!.validate()) {
      // In a real app, we would submit the ticket to a backend API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Support ticket submitted successfully! We\'ll respond shortly.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form
      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _selectedIssueType = 'Technical Issue';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildQuickActionButton(
                  icon: Icons.phone,
                  label: 'Call Support',
                  onTap: () {
                    // Launch phone call to support
                  },
                ),
                const SizedBox(width: 16),
                _buildQuickActionButton(
                  icon: Icons.chat,
                  label: 'Live Chat',
                  onTap: () {
                    // Open live chat interface
                  },
                ),
                const SizedBox(width: 16),
                _buildQuickActionButton(
                  icon: Icons.email,
                  label: 'Email',
                  onTap: () {
                    // Open email client
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // FAQ Section
            _buildSectionTitle('Frequently Asked Questions'),
            const SizedBox(height: 16),
            ..._faqItems.map((item) => _buildFaqItem(item)),

            const SizedBox(height: 32),

            // Contact Form
            _buildSectionTitle('Create Support Ticket'),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Issue Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedIssueType,
                    decoration: InputDecoration(
                      labelText: 'Issue Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items:
                        _issueTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedIssueType = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an issue type';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Subject field
                  TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Message field
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      hintText: 'Please describe your issue in detail...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a message';
                      }
                      if (value.length < 10) {
                        return 'Message is too short. Please provide more details.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Attach files button
                  OutlinedButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Files'),
                    onPressed: () {
                      // Open file picker
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  CustomButton(
                    text: 'Submit Ticket',
                    onPressed: _submitSupportTicket,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Terms and policies
            _buildSectionTitle('Other Resources'),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.description, color: AppTheme.primaryColor),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // Open terms of service
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // Open privacy policy
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: AppTheme.primaryColor),
              title: const Text('FAQ'),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                // Navigate to full FAQ page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> item) {
    return ExpansionTile(
      title: Text(
        item['question'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            item['answer'],
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Alex Johnson',
    'email': 'alex.johnson@example.com',
    'phone': '+1 (555) 123-4567',
    'profileImage': 'https://randomuser.me/api/portraits/men/32.jpg',
  };

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Edit mode
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userData['name']);
    _emailController = TextEditingController(text: _userData['email']);
    _phoneController = TextEditingController(text: _userData['phone']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditMode) {
        // If we're exiting edit mode, reset the controllers to original values
        _nameController.text = _userData['name'];
        _emailController.text = _userData['email'];
        _phoneController.text = _userData['phone'];
      }
      _isEditMode = !_isEditMode;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // In a real app, we would save this to a database or API
      setState(() {
        _userData['name'] = _nameController.text;
        _userData['email'] = _emailController.text;
        _userData['phone'] = _phoneController.text;
        _isEditMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile image and edit button
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          _userData['profileImage'],
                        ),
                        backgroundColor: Colors.grey[200],
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                      if (_isEditMode)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Profile information
                _buildInfoSection(
                  title: 'Personal Information',
                  children: [
                    _buildTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      enabled: _isEditMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      enabled: _isEditMode,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      enabled: _isEditMode,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Payment methods
                _buildInfoSection(
                  title: 'Payment Methods',
                  trailing: _isEditMode ? const Icon(Icons.add) : null,
                  onTrailingTap:
                      _isEditMode
                          ? () {
                            // Navigate to add payment method
                          }
                          : null,
                  children: [
                    _buildPaymentMethod(
                      icon: Icons.credit_card,
                      title: '**** **** **** 4567',
                      subtitle: 'Expires 12/25',
                      isDefault: true,
                      onDelete:
                          _isEditMode
                              ? () {
                                // Delete payment method
                              }
                              : null,
                    ),
                    _buildPaymentMethod(
                      icon: Icons.payment,
                      title: 'PayPal',
                      subtitle: 'alex.johnson@example.com',
                      onDelete:
                          _isEditMode
                              ? () {
                                // Delete payment method
                              }
                              : null,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Favorite locations
                _buildInfoSection(
                  title: 'Favorite Locations',
                  trailing: _isEditMode ? const Icon(Icons.add) : null,
                  onTrailingTap:
                      _isEditMode
                          ? () {
                            // Navigate to add location
                          }
                          : null,
                  children: [
                    _buildLocationItem(
                      icon: Icons.home,
                      title: 'Home',
                      subtitle: '123 Main St, San Francisco, CA',
                      onDelete:
                          _isEditMode
                              ? () {
                                // Delete location
                              }
                              : null,
                    ),
                    _buildLocationItem(
                      icon: Icons.work,
                      title: 'Work',
                      subtitle: '456 Market St, San Francisco, CA',
                      onDelete:
                          _isEditMode
                              ? () {
                                // Delete location
                              }
                              : null,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Account actions
                _buildInfoSection(
                  title: 'Account',
                  children: [
                    _buildActionItem(
                      icon: Icons.history,
                      title: 'Ride History',
                      onTap: () => context.go('/ride_history'),
                    ),
                    _buildActionItem(
                      icon: Icons.support_agent,
                      title: 'Support',
                      onTap: () => context.go('/support'),
                    ),
                    _buildActionItem(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {
                        // Open privacy policy
                      },
                    ),
                    _buildActionItem(
                      icon: Icons.description,
                      title: 'Terms of Service',
                      onTap: () {
                        // Open terms of service
                      },
                    ),
                    _buildActionItem(
                      icon: Icons.logout,
                      title: 'Log Out',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Log Out'),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.go('/login');
                                    },
                                    child: const Text('Log Out'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                if (_isEditMode)
                  CustomButton(text: 'Save Changes', onPressed: _saveProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
    Widget? trailing,
    VoidCallback? onTrailingTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trailing != null)
                GestureDetector(onTap: onTrailingTap, child: trailing),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.primaryColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey.shade100,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDefault = false,
    VoidCallback? onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isDefault)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

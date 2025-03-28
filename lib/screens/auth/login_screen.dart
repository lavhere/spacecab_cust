import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _login() {
    // Validate phone number
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    // Show loading
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with a delay
    Future.delayed(const Duration(seconds: 2), () {
      // In a real app, you would call your auth service here
      // For now, we'll just navigate to the OTP verification screen

      setState(() {
        _isLoading = false;
      });

      // Navigate to the OTP verification screen
      // For now, we'll just go to the home screen
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // App logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "SC",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Welcome text
              Text(
                "Welcome to SpaceCab",
                style: Theme.of(context).textTheme.displayMedium,
              ),

              const SizedBox(height: 8),

              Text(
                "Sign in to continue",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),

              const SizedBox(height: 40),

              // Phone number input
              Text(
                "Phone Number",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                height: AppConstants.buttonHeight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Continue"),
                ),
              ),

              const SizedBox(height: 24),

              // Social login options
              Center(
                child: Text(
                  "Or continue with",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    color: Colors.red,
                    onTap: () {
                      // Handle Google login
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    onTap: () {
                      // Handle Facebook login
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.apple,
                    color: Colors.black,
                    onTap: () {
                      // Handle Apple login
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Register option
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register');
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: color, size: 36)),
      ),
    );
  }
}

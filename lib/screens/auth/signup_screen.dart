import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // added

import '../../config/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../home/home_screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  // Using IntlPhoneField so _phoneController now holds the complete phone number in E.164 format.
  final TextEditingController _phoneController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      final phoneNumber = _phoneController.text.trim();
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
            // Update additional user details
            await userCredential.user!.updateDisplayName(_nameController.text);
            await userCredential.user!.updateEmail(_emailController.text);
            // After auto verification, register new user details in Realtime Database.
            registerNewUser();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Auto verification failed: $e')),
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to the OTP verification screen, passing the verificationId and extra user details.
          context.go('/verify-otp', extra: {
            'phoneNumber': phoneNumber,
            'verificationId': verificationId,
            'name': _nameController.text,
            'email': _emailController.text,
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // This function updates the user's details in Firebase Realtime Database.
  registerNewUser() async {
    // Show loading dialog


    // Get current Firebase user (already signed in via phone auth)
    final User? userFirebase = FirebaseAuth.instance.currentUser;

    if (userFirebase == null) {
      Navigator.pop(context); // Dismiss loading dialog if no user
      return;
    }

    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(userFirebase.uid);

    Map userDataMap = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    await usersRef.set(userDataMap);

    Navigator.pop(context); // Dismiss loading dialog
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Join SpaceCab',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your details to create a new account',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Name field
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email field
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                prefixIcon: Icons.email_outlined,
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
              const SizedBox(height: 16),
              // Phone field using country code selector
              IntlPhoneField(
                initialCountryCode: 'US',
                onChanged: (phone) {
                  _phoneController.text = phone.completeNumber;
                },
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style:
                        TextStyle(color: Colors.grey[600], fontSize: 14),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Show terms and conditions
                              },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Show privacy policy
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Signup button
              CustomButton(text: 'Sign Up', onPressed: _signup),
              const SizedBox(height: 16),
              // Already have an account link
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go('/login');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Alternative sign-up methods
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or sign up with',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              // Social sign-up buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    icon: 'assets/icons/google.png',
                    onTap: () {
                      // Google sign-up
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    icon: 'assets/icons/facebook.png',
                    onTap: () {
                      // Facebook sign-up
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    icon: 'assets/icons/apple.png',
                    onTap: () {
                      // Apple sign-up
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Image.asset(
            icon,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.sync_alt, color: AppTheme.primaryColor),
          ),
        ),
      ),
    );
  }
}

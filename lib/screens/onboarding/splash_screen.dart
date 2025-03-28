import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import '../../config/theme.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Check if user is logged in or if onboarding has been completed
    _checkUserStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Wait for minimum splash screen duration
    await Future.delayed(Duration(seconds: AppConstants.splashScreenDuration));

    // Check if user has completed onboarding
    final bool onboardingCompleted =
        prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;

    // Check if user is logged in
    final String? authToken = prefs.getString(AppConstants.authTokenKey);

    if (mounted) {
      if (!onboardingCompleted) {
        // Navigate to onboarding
        context.go('/onboarding');
      } else if (authToken == null) {
        // Navigate to login
        context.go('/login');
      } else {
        // Navigate to home
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo placeholder - you can replace with your actual logo
                Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "SC",
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // App name
                const Text(
                  "SpaceCab",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                const Text(
                  "Your Ride Through Space and Time",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                const SizedBox(height: 50),

                // Loading indicator
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Loading text
                const Text(
                  "Preparing for takeoff...",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

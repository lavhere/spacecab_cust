import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/internet_connectivity.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final internet = InternetConnections();

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

    _checkUserStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: AppConstants.splashScreenDuration));

    final bool onboardingCompleted =
        prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;

    if (!onboardingCompleted) {
      context.go('/onboarding');
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      context.go('/login');
    } else {
      await getUserInfoAndCheckBlockStatus(user.uid);
    }
  }

  Future<void> getUserInfoAndCheckBlockStatus(String uid) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(uid);

    final snapshot = await usersRef.once();
    final data = snapshot.snapshot.value;

    if (data != null) {
      if ((data as Map)["blockStatus"] == "no") {
        context.go('/home');
      } else {
        FirebaseAuth.instance.signOut();
        context.go('/login');
        internet.displaySnackBar("Your account is blocked. Contact the admin.", context);
      }
    } else {
      FirebaseAuth.instance.signOut();
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: size.width * 0.35,
                  height: size.width * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "SC",
                      style: TextStyle(
                        fontSize: size.width * 0.1,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // App Name
                Text(
                  "SpaceCab",
                  style: TextStyle(
                    fontSize: size.width * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                Text(
                  "Your Ride Through Space and Time",
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 50),

                // Progress Bar
                SizedBox(
                  width: size.width * 0.6,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),

                const SizedBox(height: 20),

                // Loading text
                Text(
                  "Preparing for takeoff...",
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

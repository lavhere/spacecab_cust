import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Models
import '../models/location_model.dart';

// Screens
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/ride/destination_selection_screen.dart';
import '../screens/ride/ride_confirmation_screen.dart';
import '../screens/ride/ride_matching_screen.dart';
import '../screens/ride/ride_options_screen.dart';
import '../screens/ride/ride_tracking_screen.dart';
import '../screens/payment/payment_confirmation_screen.dart';
import '../screens/payment/payment_selection_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/ride_history_screen.dart';
import '../screens/profile/support_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash and Onboarding
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),

      // Authentication
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),

      // Main App
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),

      // Ride Flow
      GoRoute(
        path: '/destination-selection',
        builder:
            (context, state) => DestinationSelectionScreen(
              pickupLocation: state.extra as Map<String, dynamic>,
            ),
      ),
      GoRoute(
        path: '/ride-options',
        builder: (BuildContext context, GoRouterState state) {
          return const RideOptionsScreen();
        },
      ),
      GoRoute(
        path: '/ride-confirmation',
        builder: (BuildContext context, GoRouterState state) {
          return const RideConfirmationScreen();
        },
      ),
      GoRoute(
        path: '/ride-matching',
        builder: (BuildContext context, GoRouterState state) {
          return const RideMatchingScreen();
        },
      ),
      GoRoute(
        path: '/ride-tracking',
        builder: (BuildContext context, GoRouterState state) {
          return const RideTrackingScreen();
        },
      ),

      // Payment
      GoRoute(
        path: '/payment-selection',
        builder: (BuildContext context, GoRouterState state) {
          return const PaymentSelectionScreen();
        },
      ),
      GoRoute(
        path: '/payment-confirmation',
        builder: (BuildContext context, GoRouterState state) {
          return const PaymentConfirmationScreen();
        },
      ),

      // Profile and Settings
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: '/ride-history',
        builder: (BuildContext context, GoRouterState state) {
          return const RideHistoryScreen();
        },
      ),
      GoRoute(
        path: '/support',
        builder: (BuildContext context, GoRouterState state) {
          return const SupportScreen();
        },
      ),
    ],
    errorBuilder:
        (context, state) =>
            const Scaffold(body: Center(child: Text('Page not found!'))),
  );
}

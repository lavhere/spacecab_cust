class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.spacecab.com'; // Placeholder
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String userProfileEndpoint = '/user/profile';
  static const String rideHistoryEndpoint = '/user/rides';
  static const String requestRideEndpoint = '/ride/request';
  static const String cancelRideEndpoint = '/ride/cancel';
  static const String getRideStatusEndpoint = '/ride/status';
  static const String rateRideEndpoint = '/ride/rate';
  static const String paymentMethodsEndpoint = '/payment/methods';
  static const String processPaymentEndpoint = '/payment/process';

  // Shared Preferences Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userPhoneKey = 'user_phone';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String lastKnownLocationKey = 'last_known_location';
  static const String savedAddressesKey = 'saved_addresses';
  static const String preferredPaymentMethodKey = 'preferred_payment_method';
  static const String darkModeEnabledKey = 'dark_mode_enabled';

  // Map API
  static const String googleMapsApiKey =
      ''; // Empty key for development purposes

  // Default Values
  static const double defaultMapZoom = 14.0;
  static const double defaultLatitude = 37.7749; // Example: San Francisco
  static const double defaultLongitude = -122.4194;
  static const int otpTimeout = 60; // Seconds
  static const int locationUpdateInterval = 5; // Seconds
  static const int rideStatusPollingInterval = 10; // Seconds

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your internet connection.';
  static const String authFailedMessage =
      'Authentication failed. Please try again.';
  static const String locationPermissionDeniedMessage =
      'Location permission denied. Please enable location services to use this app.';
  static const String rideRequestFailedMessage =
      'Failed to request ride. Please try again.';
  static const String rideNotFoundMessage =
      'Ride not found or has been cancelled.';
  static const String paymentFailedMessage =
      'Payment failed. Please try again or use a different payment method.';

  // UI Related
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const int splashScreenDuration = 3; // Seconds
}

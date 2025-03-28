class AppConstants {
  // App Info
  static const String appName = 'SpaceCab';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Keys
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Default Location (San Francisco)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double defaultMapZoom = 15.0;

  // API Endpoints
  static const String baseUrl = 'https://api.spacecab.com';
  static const String apiVersion = 'v1';
  static const int apiTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Map Settings
  static const double defaultZoomLevel = 15.0;
  static const double maxZoomLevel = 20.0;
  static const double minZoomLevel = 10.0;
  static const int locationUpdateInterval = 5000; // 5 seconds

  // Ride Settings
  static const int maxRideHistoryItems = 50;
  static const int maxFavoriteLocations = 10;
  static const double minimumFare = 5.0;
  static const double maximumFare = 1000.0;

  // Payment Settings
  static const List<String> supportedPaymentMethods = [
    'credit_card',
    'debit_card',
    'upi',
    'wallet',
  ];
  static const double minimumWalletBalance = 100.0;
  static const double maximumWalletBalance = 10000.0;

  // Support Settings
  static const String supportEmail = 'support@spacecab.com';
  static const String supportPhone = '+1234567890';
  static const String supportWhatsApp = '+1234567890';
  static const String supportHours = '24/7';

  // Asset Paths
  static const String imagePath = 'assets/images';
  static const String iconPath = 'assets/icons';
  static const String animationPath = 'assets/animations';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Please login to continue.';
  static const String locationError = 'Unable to get your location.';
  static const String paymentError = 'Payment failed. Please try again.';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logout successful!';
  static const String rideBookedSuccess = 'Ride booked successfully!';
  static const String paymentSuccess = 'Payment successful!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';

  // Validation Messages
  static const String requiredField = 'This field is required.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPhone = 'Please enter a valid phone number.';
  static const String invalidPassword =
      'Password must be at least 6 characters.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String invalidAmount = 'Please enter a valid amount.';
}

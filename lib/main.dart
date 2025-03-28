import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize shared preferences (to check if onboarding is completed)
  final prefs = await SharedPreferences.getInstance();

  // For development: uncomment to reset onboarding status
  // await prefs.setBool(AppConstants.onboardingCompletedKey, false);

  runApp(
    DevicePreview(
      enabled: true, // Enable device preview in all environments
      tools: const [...DevicePreview.defaultTools],
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpaceCab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Device Preview configuration
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // Router configuration
      routerConfig: AppRouter.router,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:softvence_app/features/onboarding/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Timezones with robust error handling
  try {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    String locationName = timeZoneName.toString();
    
    // Fix for "TimezoneInfo(Asia/Dhaka, ...)" format
    if (locationName.contains("TimezoneInfo")) {
      final parts = locationName.split('(');
      if (parts.length > 1) {
        locationName = parts[1].split(',')[0];
      }
    }
    
    debugPrint("Setting timezone to: $locationName");
    tz.setLocalLocation(tz.getLocation(locationName));
  } catch (e) {
    debugPrint("Using default timezone (UTC) due to error: $e");
    // Fallback to UTC or rely on default
    try {
      tz.setLocalLocation(tz.getLocation('UTC'));
    } catch (_) {}
  }
  
  await Hive.initFlutter();
  await Hive.openBox<String>('alarms'); 
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Softvence App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

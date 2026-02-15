import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:softvence_app/features/alarm/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class AppInitializer {
  static Future<void> init(ProviderContainer container) async {
    // 1. Initialize Timezones
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
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }

    // 2. Initialize Hive
    await Hive.initFlutter();
    await Hive.openBox<String>('alarms'); 
    
    // 3. Initialize Notifications early
    container.read(notificationServiceProvider); 
    
    // 4. Smooth UX
    await Future.delayed(const Duration(milliseconds: 500)); 
  }
}

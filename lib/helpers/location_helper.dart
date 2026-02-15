import 'package:location/location.dart';

class LocationHelper {
  /// Checks if location services are enabled and permissions are granted.
  /// returns LocationData if successful, throws exception if not.
  static Future<LocationData?> determinePosition() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 1. Check if location services are enabled.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Trigger the GMS Dialog to turn on location!
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }

    // 2. Check permissions.
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied');
      }
    }

    // 3. Get current position.
    return await location.getLocation();
  }
}

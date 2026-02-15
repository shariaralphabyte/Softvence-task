import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:softvence_app/helpers/location_helper.dart';

final locationServiceProvider = Provider((ref) => LocationService());

class LocationService {
  Future<LocationData?> determinePosition() async {
    return await LocationHelper.determinePosition();
  }
}

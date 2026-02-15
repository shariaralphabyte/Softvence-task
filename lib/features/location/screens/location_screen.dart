import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:softvence_app/features/alarm/screens/alarm_screen.dart';
import 'package:softvence_app/features/location/services/location_service.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  String _locationMessage = "Location not fetched yet";
  bool _isLoading = false;
  LocationData? _currentPosition;

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _locationMessage = "Fetching location...";
    });

    try {
      final position = await ref.read(locationServiceProvider).determinePosition();
      setState(() {
        _currentPosition = position;
        _locationMessage =
            "Lat: ${position?.latitude}, Long: ${position?.longitude}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error: $e";
        _isLoading = false;
      });
    }
  }

  void _navigateToAlarms() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AlarmScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Access")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                "We need your location to proceed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _locationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _getLocation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text("Get Location"),
                    ),
                    if (_currentPosition != null) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _navigateToAlarms,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: const Text("Continue to Alarms"),
                      ),
                    ]
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

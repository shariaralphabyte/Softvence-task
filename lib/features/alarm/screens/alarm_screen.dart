import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:softvence_app/constants/app_colors.dart';
import 'package:softvence_app/features/alarm/services/notification_service.dart';

class AlarmScreen extends ConsumerStatefulWidget {
  const AlarmScreen({super.key});

  @override
  ConsumerState<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends ConsumerState<AlarmScreen> {
  late Box<String> _alarmBox;

  @override
  void initState() {
    super.initState();
    _alarmBox = Hive.box<String>('alarms');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).requestPermissions();
    });
  }

  Future<void> _addAlarm() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    if (!mounted) return;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final scheduledTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      // Store full ISO8601 string to preserve date and time
      await _alarmBox.put(id.toString(), scheduledTime.toIso8601String());
      
      // Schedule notification
      ref.read(notificationServiceProvider).scheduleAlarm(
        id, 
        scheduledTime, 
        "Alarm", 
        "It's time!"
      );

      setState(() {});
    }
  }

  void _deleteAlarm(String key) {
    _alarmBox.delete(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar / Location Display
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.white70),
                          SizedBox(width: 12),
                          Text("Add your location", style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Alarms",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 10),

              // Alarm List
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _alarmBox.listenable(),
                  builder: (context, Box<String> box, _) {
                    if (box.isEmpty) {
                      return const Center(child: Text("No alarms set", style: TextStyle(color: Colors.white54)));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final key = box.keyAt(index) as String;
                        final alarmValue = box.get(key)!;
                        
                        DateTime alarmDateTime;
                        try {
                          alarmDateTime = DateTime.parse(alarmValue);
                        } catch (e) {
                          // Fallback for old format if any (though unlikely given recent rewrite)
                          alarmDateTime = DateTime.now();
                        }

                        final timeString = DateFormat('jm').format(alarmDateTime);
                        final dateString = DateFormat('EEE d MMM yyyy').format(alarmDateTime); 

                        return Dismissible(
                          key: Key(key),
                          onDismissed: (direction) => _deleteAlarm(key),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      timeString,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      dateString,
                                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    const SizedBox(width: 12),
                                    Switch(
                                      value: alarmDateTime.isAfter(DateTime.now()), 
                                      onChanged: (val) {}, 
                                      activeColor: Colors.white,
                                      activeTrackColor: AppColors.accentPurple,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 64,
        width: 64,
        child: FloatingActionButton(
          onPressed: _addAlarm,
          backgroundColor: AppColors.primaryPurple,
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

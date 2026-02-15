import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
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
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // If time is in the past, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final formattedTime = DateFormat('hh:mm a').format(scheduledDate);
      
      // Save to Hive
      final id = await _alarmBox.add(scheduledDate.toIso8601String());

      // Attempt to schedule
      try {
        await ref.read(notificationServiceProvider).scheduleAlarm(
              id,
              scheduledDate,
              "Alarm",
              "It's $formattedTime!",
            );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Alarm set for $formattedTime")),
          );
        }
      } catch (e) {
        if (mounted) {
           showDialog(
             context: context,
             builder: (context) => AlertDialog(
               title: const Text("Error Scheduling"),
               content: Text("Could not set alarm: $e"),
               actions: [
                 TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
               ],
             ),
           );
        }
      }
    }
  }

  Future<void> _deleteAlarm(int key) async {
    await _alarmBox.delete(key);
    ref.read(notificationServiceProvider).cancelAlarm(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alarms")),
      body: ValueListenableBuilder(
        valueListenable: _alarmBox.listenable(),
        builder: (context, Box<String> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No alarms set. Tap + to add one."),
            );
          }

          return ListView.builder(
            itemCount: box.keys.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index) as int;
              final dateString = box.getAt(index)!;
              final date = DateTime.parse(dateString);
              final formattedTime = DateFormat('hh:mm a').format(date);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    formattedTime,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Daily"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAlarm(key),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: const Icon(Icons.add),
      ),
    );
  }
}

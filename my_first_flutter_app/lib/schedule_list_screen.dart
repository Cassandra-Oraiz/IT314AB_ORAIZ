import 'package:flutter/material.dart';
import 'repositories/schedule_repository.dart';
import 'add_schedule_screen.dart';
import 'edit_schedule_screen.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  final ScheduleRepository repository = ScheduleRepository();

  List<Map<String, dynamic>> schedules = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await repository.getSchedules();

      if (!mounted) return;

      setState(() {
        schedules = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> openAddScheduleScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddScheduleScreen()),
    );

    if (result == true && mounted) {
      loadSchedules();
    }
  }

  Future<void> openEditScheduleScreen(Map<String, dynamic> schedule) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScheduleScreen(schedule: schedule),
      ),
    );

    if (result == true && mounted) {
      loadSchedules();
    }
  }

  Future<void> deleteSchedule(Map<String, dynamic> schedule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Schedule?'),
          content: Text(
            'Are you sure you want to delete the schedule for '
            '${schedule['subject_name']} on '
            '${schedule['day_of_week']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    try {
      await repository.deleteSchedule((schedule['schedule_id'] as num).toInt());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      await loadSchedules();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete schedule: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatTime(dynamic value) {
    if (value == null) return 'N/A';

    final time = value.toString();

    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time);

    if (match == null) return time;

    return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)}';
  }

  Widget buildScheduleCard(Map<String, dynamic> schedule) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.calendar_month)),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule['subject_name'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('Code: ${schedule['subject_code']}'),
                    ],
                  ),
                ),

                Text(
                  '#${schedule['schedule_id']}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const Divider(height: 24),

            Text('Day: ${schedule['day_of_week']}'),
            const SizedBox(height: 6),

            Text(
              'Time: ${formatTime(schedule['start_time'])}'
              ' - ${formatTime(schedule['end_time'])}',
            ),
            const SizedBox(height: 6),

            Text('Room: ${schedule['room']}'),
            const SizedBox(height: 6),

            Text('Slot Capacity: ${schedule['slot_capacity']} students'),

            const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    openEditScheduleScreen(schedule);
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),

                const SizedBox(width: 8),

                TextButton.icon(
                  onPressed: () {
                    deleteSchedule(schedule);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: loadSchedules,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh schedules',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: openAddScheduleScreen,
        tooltip: 'Add Schedule',
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 45,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load schedules:\n$errorMessage',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: loadSchedules,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          : schedules.isEmpty
          ? const Center(
              child: Text(
                'No schedules found.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadSchedules,
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  return buildScheduleCard(schedules[index]);
                },
              ),
            ),
    );
  }
}

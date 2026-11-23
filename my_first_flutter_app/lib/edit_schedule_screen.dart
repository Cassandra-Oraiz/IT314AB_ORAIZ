import 'package:flutter/material.dart';
import 'repositories/schedule_repository.dart';

class EditScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const EditScheduleScreen({super.key, required this.schedule});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final ScheduleRepository repository = ScheduleRepository();

  final roomController = TextEditingController();
  final capacityController = TextEditingController();

  List<Map<String, dynamic>> subjects = [];

  int? selectedSubjectId;
  String? selectedDay;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();

    selectedSubjectId = (widget.schedule['subject_id'] as num).toInt();
    selectedDay = widget.schedule['day_of_week'].toString();
    roomController.text = widget.schedule['room'].toString();
    capacityController.text = widget.schedule['slot_capacity'].toString();

    startTime = parseTime(widget.schedule['start_time']);
    endTime = parseTime(widget.schedule['end_time']);

    loadSubjects();
  }

  @override
  void dispose() {
    roomController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  TimeOfDay parseTime(dynamic value) {
    final timeString = value.toString();

    //Gets the value for hour and minute
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeString);

    if (match == null) {
      throw FormatException('Invalid schedule time: $timeString');
    }

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> loadSubjects() async {
    try {
      final data = await repository.getSubjects();

      if (!mounted) return;

      setState(() {
        subjects = data;
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

  Future<void> selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (startTime ?? const TimeOfDay(hour: 8, minute: 0))
          : (endTime ?? const TimeOfDay(hour: 9, minute: 0)),
    );

    if (picked == null || !mounted) return;

    setState(() {
      if (isStart) {
        startTime = picked;
      } else {
        endTime = picked;
      }
    });
  }

  String formatTimeForDatabase(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  String displayTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    return time.format(context);
  }

  Future<void> updateSchedule() async {
    if (selectedSubjectId == null ||
        selectedDay == null ||
        startTime == null ||
        endTime == null ||
        roomController.text.trim().isEmpty ||
        capacityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    final capacity = int.tryParse(capacityController.text.trim());

    if (capacity == null || capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid slot capacity greater than zero.'),
        ),
      );
      return;
    }

    final startMinutes = startTime!.hour * 60 + startTime!.minute;
    final endMinutes = endTime!.hour * 60 + endTime!.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be later than start time.'),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await repository.updateSchedule(
        scheduleId: (widget.schedule['schedule_id'] as num).toInt(),
        dayOfWeek: selectedDay!,
        startTime: formatTimeForDatabase(startTime!),
        endTime: formatTimeForDatabase(endTime!),
        room: roomController.text.trim(),
        slotCapacity: capacity,
        subjectId: selectedSubjectId!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update schedule: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Schedule'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    Text(
                      'Failed to load subjects:\n$errorMessage',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        loadSubjects();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Subject',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue:
                        subjects.any(
                          (subject) =>
                              (subject['subject_id'] as num).toInt() ==
                              selectedSubjectId,
                        )
                        ? selectedSubjectId
                        : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select a subject',
                    ),
                    items: subjects.map((subject) {
                      final id = (subject['subject_id'] as num).toInt();

                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(
                          '${subject['subject_code']} - '
                          '${subject['subject_name']}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedSubjectId = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Day of Week',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: days.contains(selectedDay)
                        ? selectedDay
                        : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select a day',
                    ),
                    items: days.map((day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedDay = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Start Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => selectTime(true),
                    icon: const Icon(Icons.access_time),
                    label: Text(displayTime(startTime)),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'End Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => selectTime(false),
                    icon: const Icon(Icons.access_time),
                    label: Text(displayTime(endTime)),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Room',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: roomController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter room',
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Slot Capacity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: capacityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter number of students',
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: isSaving ? null : updateSchedule,
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(isSaving ? 'Updating...' : 'Update Schedule'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

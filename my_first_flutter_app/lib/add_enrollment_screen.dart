import 'package:flutter/material.dart';
import 'repositories/enrollment_repository.dart';

class AddEnrollmentScreen extends StatefulWidget {
  const AddEnrollmentScreen({super.key});

  @override
  State<AddEnrollmentScreen> createState() => _AddEnrollmentScreenState();
}

class _AddEnrollmentScreenState extends State<AddEnrollmentScreen> {
  final EnrollmentRepository repository = EnrollmentRepository();

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> schedules = [];

  int? selectedStudentId;
  int? selectedScheduleId;

  DateTime enrolledAt = DateTime.now();
  bool status = true;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadDropdownData();
  }

  Future<void> loadDropdownData() async {
    try {
      final studentData = await repository.getStudents();
      final scheduleData = await repository.getSchedules();

      if (!mounted) return;

      setState(() {
        students = studentData;
        schedules = scheduleData;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  // GET SELECTED SCHEDULE
  Map<String, dynamic>? get selectedSchedule {
    if (selectedScheduleId == null) return null;

    return schedules.firstWhere(
      (schedule) => schedule['schedule_id'] == selectedScheduleId,
    );
  }

  Future<void> saveEnrollment() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedStudentId == null || selectedScheduleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a student and schedule.')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await repository.addEnrollment(
        studentId: selectedStudentId!,
        scheduleId: selectedScheduleId!,
        enrolledAt: enrolledAt,
        status: status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment added successfully!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add enrollment: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> selectEnrollmentDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: enrolledAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        enrolledAt = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          enrolledAt.hour,
          enrolledAt.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Enrollment'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : schedules.isEmpty || students.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  students.isEmpty
                      ? 'No students available. Add a student first.'
                      : 'No schedules available. Add a schedule first.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Student',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<int>(
                      initialValue: selectedStudentId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Choose a student',
                      ),
                      items: students.map((student) {
                        return DropdownMenuItem<int>(
                          value: student['studentid'] as int,
                          child: Text(
                            '${student['firstname']} ${student['lastname']}',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStudentId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a student.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Select Schedule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<int>(
                      initialValue: selectedScheduleId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'Choose a schedule',
                      ),
                      items: schedules.map((schedule) {
                        return DropdownMenuItem<int>(
                          value: schedule['schedule_id'] as int,
                          child: Text(
                            '${schedule['subject_code']} - '
                            '${schedule['day_of_week']} '
                            '(${schedule['room']})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedScheduleId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a schedule.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Selected Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        selectedSchedule == null
                            ? 'Subject will appear after selecting a schedule.'
                            : '${selectedSchedule!['subject_code']} - '
                                  '${selectedSchedule!['subject_name']}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Enrollment Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: selectEnrollmentDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${enrolledAt.month.toString().padLeft(2, '0')}/'
                        '${enrolledAt.day.toString().padLeft(2, '0')}/'
                        '${enrolledAt.year}',
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Enrollment Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(status ? 'Active' : 'Inactive'),
                      subtitle: const Text(
                        'Turn off to mark this enrollment inactive.',
                      ),
                      value: status,
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isSaving ? null : saveEnrollment,
                        icon: isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(isSaving ? 'Saving...' : 'Save Enrollment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

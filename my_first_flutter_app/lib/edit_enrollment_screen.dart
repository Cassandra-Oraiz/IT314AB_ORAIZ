import 'package:flutter/material.dart';
import 'repositories/enrollment_repository.dart';

class EditEnrollmentScreen extends StatefulWidget {
  final Map<String, dynamic> enrollment;

  const EditEnrollmentScreen({super.key, required this.enrollment});

  @override
  State<EditEnrollmentScreen> createState() => _EditEnrollmentScreenState();
}

class _EditEnrollmentScreenState extends State<EditEnrollmentScreen> {
  final EnrollmentRepository repository = EnrollmentRepository();
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> schedules = [];

  int? selectedStudentId;
  int? selectedScheduleId;

  late int enrollmentId;
  late DateTime enrolledAt;
  late bool status;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    enrollmentId = (widget.enrollment['enrollment_id'] as num).toInt();
    selectedStudentId = (widget.enrollment['student_id'] as num).toInt();
    selectedScheduleId = (widget.enrollment['schedule_id'] as num).toInt();

    enrolledAt =
        DateTime.tryParse(widget.enrollment['enrolled_at'].toString()) ??
        DateTime.now();

    status = widget.enrollment['status'] == true;

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

  Map<String, dynamic>? get selectedSchedule {
    if (selectedScheduleId == null) return null;

    for (final schedule in schedules) {
      if ((schedule['schedule_id'] as num).toInt() == selectedScheduleId) {
        return schedule;
      }
    }

    return null;
  }

  Future<void> updateEnrollment() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedStudentId == null || selectedScheduleId == null) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await repository.updateEnrollment(
        enrollmentId: enrollmentId,
        studentId: selectedStudentId!,
        scheduleId: selectedScheduleId!,
        enrolledAt: enrolledAt,
        status: status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment updated successfully!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
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

  String get formattedDate {
    return '${enrolledAt.month.toString().padLeft(2, '0')}/'
        '${enrolledAt.day.toString().padLeft(2, '0')}/'
        '${enrolledAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Enrollment'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty || schedules.isEmpty
          ? const Center(child: Text('Students or schedules are unavailable.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enrollment #$enrollmentId',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

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
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: students.map((student) {
                        return DropdownMenuItem<int>(
                          value: (student['studentid'] as num).toInt(),
                          child: Text(
                            '${student['firstname']} '
                            '${student['lastname']}',
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
                      ),
                      items: schedules.map((schedule) {
                        return DropdownMenuItem<int>(
                          value: (schedule['schedule_id'] as num).toInt(),
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
                            ? 'Subject unavailable.'
                            : '${selectedSchedule!['subject_code']} - '
                                  '${selectedSchedule!['subject_name']}',
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
                      label: Text(formattedDate),
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
                        onPressed: isSaving ? null : updateEnrollment,
                        icon: isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          isSaving ? 'Updating...' : 'Update Enrollment',
                        ),
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

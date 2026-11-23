import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'repositories/grade_repository.dart';

class AddGradeScreen extends StatefulWidget {
  const AddGradeScreen({super.key});

  @override
  State<AddGradeScreen> createState() => _AddGradeScreenState();
}

class _AddGradeScreenState extends State<AddGradeScreen> {
  final GradeRepository repository = GradeRepository();

  final _formKey = GlobalKey<FormState>();

  final scoreController = TextEditingController();
  final remarksController = TextEditingController();

  List<Map<String, dynamic>> enrollments = [];

  int? selectedEnrollmentId;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadEnrollments();
  }

  @override
  void dispose() {
    scoreController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> loadEnrollments() async {
    try {
      final result = await repository.getEnrollments();

      if (!mounted) return;

      setState(() {
        enrollments = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load enrollments: $e')));
    }
  }

  Future<void> saveGrade() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedEnrollmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an enrollment.')),
      );
      return;
    }

    final score = double.parse(scoreController.text.trim());

    setState(() => isSaving = true);

    try {
      await repository.addGrade(
        enrollmentId: selectedEnrollmentId!,
        score: score,
        remarks: remarksController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade added successfully!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => isSaving = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add grade: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grade'),
        backgroundColor: const Color.fromARGB(255, 183, 58, 58),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : enrollments.isEmpty
          ? const Center(child: Text('No enrollments available.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: selectedEnrollmentId,
                      decoration: const InputDecoration(
                        labelText: 'Select Enrollment',
                        border: OutlineInputBorder(),
                      ),
                      items: enrollments.map((enrollment) {
                        final id = (enrollment['enrollment_id'] as num).toInt();

                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(
                            '#$id - ${enrollment['student_name']} '
                            '(${enrollment['subject_code']})',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEnrollmentId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an enrollment.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: scoreController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Grade',
                        hintText: 'Enter grade (1.0 - 5.0)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.grade),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a grade.';
                        }

                        final grade = double.tryParse(value.trim());

                        if (grade == null) {
                          return 'Please enter a valid number.';
                        }

                        if (grade < 1.0 || grade > 5.0) {
                          return 'Grade must be between 1.0 and 5.0.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: remarksController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Remarks (Optional)',
                        hintText: 'Enter additional comments if needed',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.comment),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isSaving ? null : saveGrade,
                        icon: const Icon(Icons.save),
                        label: Text(isSaving ? 'Saving...' : 'Save Grade'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            183,
                            58,
                            58,
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(14),
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

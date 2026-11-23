import 'package:flutter/material.dart';
import 'repositories/grade_repository.dart';

class EditGradeScreen extends StatefulWidget {
  final Map<String, dynamic> grade;

  const EditGradeScreen({super.key, required this.grade});

  @override
  State<EditGradeScreen> createState() => _EditGradeScreenState();
}

class _EditGradeScreenState extends State<EditGradeScreen> {
  final GradeRepository repository = GradeRepository();

  final scoreController = TextEditingController();
  final remarksController = TextEditingController();

  List<Map<String, dynamic>> enrollments = [];

  int? selectedEnrollmentId;

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    final score = widget.grade['score'];
    if (score != null) {
      scoreController.text = (score as num).toString();
    }

    remarksController.text = widget.grade['remarks']?.toString() ?? '';

    selectedEnrollmentId = (widget.grade['enrollment_id'] as num).toInt();

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

        if (!enrollments.any(
          (e) => (e['enrollment_id'] as num).toInt() == selectedEnrollmentId,
        )) {
          selectedEnrollmentId = null;
        }
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

  Future<void> updateGrade() async {
    if (selectedEnrollmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an enrollment.')),
      );
      return;
    }

    final score = double.tryParse(scoreController.text.trim());

    if (score == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid numeric grade.')),
      );
      return;
    }

    if (score < 1.0 || score > 5.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade must be between 1.0 and 5.0.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await repository.updateGrade(
        gradeId: (widget.grade['gradeid'] as num).toInt(),
        enrollmentId: selectedEnrollmentId!,
        score: score,
        remarks: remarksController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade updated successfully!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => isSaving = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update grade: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Grade'),
        backgroundColor: const Color.fromARGB(255, 183, 58, 58),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : enrollments.isEmpty
          ? const Center(child: Text('No enrollments available.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: scoreController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Grade',
                      hintText: 'Enter grade (1.0 - 5.0)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: remarksController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Remarks (Optional)',
                      hintText: 'Enter remarks about the grade',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : updateGrade,
                      icon: const Icon(Icons.save),
                      label: Text(isSaving ? 'Updating...' : 'Update Grade'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 183, 58, 58),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

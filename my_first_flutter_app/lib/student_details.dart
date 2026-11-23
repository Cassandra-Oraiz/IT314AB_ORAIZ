import 'package:flutter/material.dart';
import 'student.dart';
import 'repositories/student_repository.dart';

class SecondRoute extends StatefulWidget {
  final Student student;

  const SecondRoute({super.key, required this.student});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final StudentRepository repository = StudentRepository();

  late Student student;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  Future<void> editStudent() async {
    final firstNameController = TextEditingController(text: student.firstName);

    final lastNameController = TextEditingController(text: student.lastName);

    final emailController = TextEditingController(text: student.email);

    final contactController = TextEditingController(
      text: student.contactNumber,
    );

    final courseController = TextEditingController(text: student.course);

    final yearController = TextEditingController(
      text: student.yearLevel.toString(),
    );

    final programController = TextEditingController(
      text: student.programId.toString(),
    );

    final formKey = GlobalKey<FormState>();

    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Edit Student',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      buildField(firstNameController, 'First Name'),
                      buildField(lastNameController, 'Last Name'),
                      buildField(emailController, 'Email'),
                      buildField(contactController, 'Contact Number'),
                      buildField(courseController, 'Course'),

                      buildField(yearController, 'Year Level', number: true),

                      buildField(programController, 'Program ID', number: true),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }

                                final year = int.parse(
                                  yearController.text.trim(),
                                );

                                final program = int.parse(
                                  programController.text.trim(),
                                );

                                setSheetState(() {
                                  isSaving = true;
                                });

                                try {
                                  final updatedStudent = Student(
                                    studentId: student.studentId,
                                    studentNumber: student.studentNumber,
                                    firstName: firstNameController.text.trim(),
                                    lastName: lastNameController.text.trim(),
                                    email: emailController.text.trim(),
                                    contactNumber: contactController.text
                                        .trim(),
                                    course: courseController.text.trim(),
                                    yearLevel: year,
                                    programId: program,
                                    createdAt: student.createdAt,
                                  );

                                  final savedStudent = await repository
                                      .updateStudent(updatedStudent);

                                  if (!mounted || !sheetContext.mounted) return;

                                  setState(() {
                                    student = savedStudent;
                                  });

                                  Navigator.pop(sheetContext, true);
                                } catch (e) {
                                  if (!sheetContext.mounted) return;

                                  ScaffoldMessenger.of(
                                    sheetContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text('Update failed: $e'),
                                    ),
                                  );

                                  setSheetState(() {
                                    isSaving = false;
                                  });
                                }
                              },
                        child: isSaving
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactController.dispose();
    courseController.dispose();
    yearController.dispose();
    programController.dispose();

    if (updated == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully in Neon!')),
      );

      Navigator.pop(context, true);
    }
  }

  Widget buildField(
    TextEditingController controller,
    String label, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }

          if (number && int.tryParse(value.trim()) == null) {
            return 'Please enter a valid number';
          }

          if (label == 'Year Level') {
            final year = int.tryParse(value.trim());
            if (year == null || year < 1 || year > 4) {
              return 'Year must be between 1 and 4';
            }
          }

          if (label == 'Email' &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
            return 'Enter a valid email';
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.fullName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text('Student ID: ${student.studentId}'),
                Text('Student Number: ${student.studentNumber}'),
                Text('Email: ${student.email}'),
                Text('Contact Number: ${student.contactNumber}'),
                Text('Course: ${student.course}'),
                Text('Year Level: ${student.yearLevel}'),
                Text('Program ID: ${student.programId}'),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: editStudent,
                    child: const Text('Edit Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

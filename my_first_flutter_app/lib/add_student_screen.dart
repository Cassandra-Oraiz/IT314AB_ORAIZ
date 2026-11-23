import 'package:flutter/material.dart';
import 'repositories/student_repository.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final courseController = TextEditingController();
  final yearLevelController = TextEditingController();

  final StudentRepository repository = StudentRepository();

  List<Map<String, dynamic>> programs = [];
  int? selectedProgramId;

  bool isLoadingPrograms = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadPrograms();
  }

  Future<void> loadPrograms() async {
    try {
      final result = await repository.getPrograms();

      if (!mounted) return;

      setState(() {
        programs = result;
        isLoadingPrograms = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingPrograms = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load programs: $e')));
    }
  }

  // SUBMIT STUDENT TO NEON
  Future<void> submitStudent() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProgramId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a program.')));
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await repository.addStudent(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        course: courseController.text.trim(),
        yearLevel: int.parse(yearLevelController.text.trim()),
        programId: selectedProgramId!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student successfully enrolled in Neon!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Enrollment failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    super.dispose();
  }

  // REUSABLE TEXT FIELD
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label.';
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
        title: const Text('Add Student'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Enrollment Form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              buildTextField(
                controller: firstNameController,
                label: 'First Name',
              ),

              buildTextField(
                controller: lastNameController,
                label: 'Last Name',
              ),

              buildTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email.';
                  }

                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(value.trim())) {
                    return 'Please enter a valid email.';
                  }

                  return null;
                },
              ),

              buildTextField(
                controller: contactNumberController,
                label: 'Contact Number',
                keyboardType: TextInputType.phone,
              ),

              buildTextField(controller: courseController, label: 'Course'),

              buildTextField(
                controller: yearLevelController,
                label: 'Year Level',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter year level.';
                  }

                  final year = int.tryParse(value.trim());

                  if (year == null || year < 1 || year > 4) {
                    return 'Year level must be from 1 to 4.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'Program',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 8),

              if (isLoadingPrograms)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<int>(
                  initialValue: selectedProgramId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Program',
                  ),
                  items: programs.map((program) {
                    return DropdownMenuItem<int>(
                      value: (program['programid'] as num).toInt(),
                      child: Text(
                        '${program['programcode']} - '
                        '${program['programname']}',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProgramId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a program.';
                    }
                    return null;
                  },
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving || isLoadingPrograms
                      ? null
                      : submitStudent,
                  child: isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Submit Enrollment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

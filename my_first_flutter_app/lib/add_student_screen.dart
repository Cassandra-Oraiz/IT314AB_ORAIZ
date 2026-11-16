import 'package:flutter/material.dart';
import 'student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController studentIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController yearLevelController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    studentIdController.dispose();
    nameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Enrollment Form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: studentIdController,
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  hintText: 'Enter Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Student ID';
                  }
                  final exists = students.any(
                    (student) =>
                        student.id.toString().toLowerCase() ==
                        value.trim().toLowerCase(),
                  );

                  if (exists) {
                    return 'Student ID already exists';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  hintText: 'Enter Student Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Name';
                  }

                  return null;
                },
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: courseController,
                decoration: InputDecoration(
                  labelText: 'Student Course',
                  hintText: 'Enter Student Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Course';
                  }
                },
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: yearLevelController,
                decoration: InputDecoration(
                  labelText: 'Student Year Level',
                  hintText: 'Enter Student Year Level',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Student Year Level';
                  }

                  final year = int.tryParse(value.trim());

                  if (year == null || year < 1 || year > 4) {
                    return 'Year Level must be from 1 to 4';
                  }

                  return null;
                },
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Student Email',
                  hintText: 'Enter Student Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an Email';
                  }

                  final validEmail = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(value.trim());

                  if (!validEmail) {
                    return 'Please enter a valid email address';
                  }

                  return null;
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Student newStudent = Student(
                      id: int.parse(studentIdController.text.trim()),
                      name: nameController.text.trim(),
                      course: courseController.text.trim(),
                      yearLevel: int.parse(yearLevelController.text.trim()),
                    );

                    students.add(newStudent);

                    await saveStudents(students);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student successfully enrolled!'),
                      ),
                    );

                    studentIdController.clear();
                    nameController.clear();
                    courseController.clear();
                    yearLevelController.clear();
                    emailController.clear();

                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

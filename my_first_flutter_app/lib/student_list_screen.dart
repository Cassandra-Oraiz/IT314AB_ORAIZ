import 'package:flutter/material.dart';
import 'student.dart';
import 'repositories/student_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StudentRepository repository = StudentRepository();

  List<Student> students = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await repository.getStudents();

      if (!mounted) return;

      setState(() {
        students = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await repository.deleteStudent(student.studentId);

      if (!mounted) return;

      setState(() {
        students.removeWhere((item) => item.studentId == student.studentId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student deleted successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  Widget buildStudentCard(Student student) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.fullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),

            const SizedBox(height: 8),

            Text('Student ID: ${student.studentId}'),
            Text('Student Number: ${student.studentNumber}'),
            Text('Email: ${student.email}'),
            Text('Contact: ${student.contactNumber}'),

            const SizedBox(height: 8),

            Text(
              student.course,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text('Year Level: ${student.yearLevel}'),
            Text('Program ID: ${student.programId}'),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/student-details',
                      arguments: student,
                    );

                    if (result == true) {
                      loadStudents();
                    }
                  },
                  child: const Text('View Details'),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => deleteStudent(student),
                  child: const Text('Delete'),
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
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: Text(widget.title),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/subject-list');
            },
            icon: const Icon(Icons.menu_book),
            tooltip: 'View Subjects',
          ),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/schedule-list');
            },
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 30,
            ),
            tooltip: 'View Schedules',
          ),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/enrollment-list');
            },
            icon: const Icon(
              Icons.assignment_ind,
              color: Colors.white,
              size: 28,
            ),
            tooltip: 'View Enrollments',
          ),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/grade-list');
            },
            icon: const Icon(Icons.grade, color: Colors.white, size: 28),
            tooltip: 'View Grades',
          ),

          IconButton(
            onPressed: loadStudents,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh students',
          ),
        ],
      ),
      //ADD/ENROLLMENT STUDENTS BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-student');

          if (result == true) {
            loadStudents();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load students.',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(errorMessage!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: loadStudents,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          : students.isEmpty
          ? const Center(
              child: Text(
                'No students found in Neon.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadStudents,
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return buildStudentCard(students[index]);
                },
              ),
            ),
    );
  }
}

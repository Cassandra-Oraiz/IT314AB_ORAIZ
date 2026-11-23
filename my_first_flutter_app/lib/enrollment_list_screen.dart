import 'package:flutter/material.dart';
import 'repositories/enrollment_repository.dart';
import 'add_enrollment_screen.dart';
import 'edit_enrollment_screen.dart';

class EnrollmentListScreen extends StatefulWidget {
  const EnrollmentListScreen({super.key});

  @override
  State<EnrollmentListScreen> createState() => _EnrollmentListScreenState();
}

class _EnrollmentListScreenState extends State<EnrollmentListScreen> {
  final EnrollmentRepository repository = EnrollmentRepository();

  List<Map<String, dynamic>> enrollments = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadEnrollments();
  }

  Future<void> loadEnrollments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await repository.getEnrollments();

      if (!mounted) return;

      setState(() {
        enrollments = data;
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

  Future<void> openAddEnrollment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEnrollmentScreen()),
    );

    if (result == true) {
      loadEnrollments();
    }
  }

  Future<void> editEnrollment(Map<String, dynamic> enrollment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEnrollmentScreen(enrollment: enrollment),
      ),
    );

    if (result == true) {
      loadEnrollments();
    }
  }

  Future<void> deleteEnrollment(Map<String, dynamic> enrollment) async {
    final enrollmentId = (enrollment['enrollment_id'] as num).toInt();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Enrollment'),
        content: Text(
          'Are you sure you want to delete enrollment #$enrollmentId?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await repository.deleteEnrollment(enrollmentId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment deleted successfully!')),
      );

      loadEnrollments();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  String formatDate(dynamic value) {
    if (value == null) return 'N/A';

    try {
      final date = DateTime.parse(value.toString());

      return '${date.month.toString().padLeft(2, '0')}/'
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  String formatTime(dynamic value) {
    if (value == null) return 'N/A';

    final time = value.toString();

    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time);

    if (match == null) return time;

    return '${match.group(1)!.padLeft(2, '0')}:${match.group(2)}';
  }

  Widget buildEnrollmentCard(Map<String, dynamic> enrollment) {
    final bool isActive = enrollment['status'] == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enrollment['student_name']?.toString() ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Enrollment #${enrollment['enrollment_id']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Text(
              'Subject: ${enrollment['subject_code']}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(enrollment['subject_name']?.toString() ?? 'N/A'),

            const SizedBox(height: 10),

            Text('Day: ${enrollment['day_of_week']}'),
            const SizedBox(height: 5),

            Text(
              'Time: ${formatTime(enrollment['start_time'])}'
              ' - ${formatTime(enrollment['end_time'])}',
            ),
            const SizedBox(height: 5),

            Text('Room: ${enrollment['room']}'),

            const SizedBox(height: 10),

            Text('Enrolled At: ${formatDate(enrollment['enrolled_at'])}'),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => editEnrollment(enrollment),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),

                const SizedBox(width: 8),

                ElevatedButton.icon(
                  onPressed: () => deleteEnrollment(enrollment),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
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
        title: const Text('Enrollments'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: loadEnrollments,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh enrollments',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddEnrollment,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Enrollment'),
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
                      'Failed to load enrollments:\n$errorMessage',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: loadEnrollments,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          : enrollments.isEmpty
          ? RefreshIndicator(
              onRefresh: loadEnrollments,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Text(
                      'No enrollments found.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadEnrollments,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 90),
                itemCount: enrollments.length,
                itemBuilder: (context, index) {
                  return buildEnrollmentCard(enrollments[index]);
                },
              ),
            ),
    );
  }
}

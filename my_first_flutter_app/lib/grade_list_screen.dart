import 'package:flutter/material.dart';
import 'repositories/grade_repository.dart';
import 'add_grade_screen.dart';
import 'edit_grade_screen.dart';

class GradeListScreen extends StatefulWidget {
  const GradeListScreen({super.key});

  @override
  State<GradeListScreen> createState() => _GradeListScreenState();
}

class _GradeListScreenState extends State<GradeListScreen> {
  final GradeRepository repository = GradeRepository();

  List<Map<String, dynamic>> grades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGrades();
  }

  Future<void> loadGrades() async {
    try {
      final result = await repository.getGrades();

      if (!mounted) return;

      setState(() {
        grades = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load grades: $e')));
    }
  }

  String getGradeStatus(dynamic score) {
    if (score == null) return 'NOT GRADED';

    final grade = (score as num).toDouble();

    return grade == 5.00 ? 'FAIL' : 'PASS';
  }

  Color getGradeColor(dynamic score) {
    if (score == null) return Colors.grey;

    final grade = (score as num).toDouble();

    return grade == 5.00 ? Colors.red : Colors.green;
  }

  Future<void> addGrade() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGradeScreen()),
    );

    if (result == true) {
      loadGrades();
    }
  }

  Future<void> editGrade(Map<String, dynamic> grade) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditGradeScreen(grade: grade)),
    );

    if (result == true) {
      loadGrades();
    }
  }

  Future<void> deleteGrade(Map<String, dynamic> grade) async {
    final gradeId = (grade['gradeid'] as num).toInt();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Grade'),
        content: const Text(
          'Are you sure you want to delete this grade record?',
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
      await repository.deleteGrade(gradeId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade deleted successfully!')),
      );

      loadGrades();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete grade: $e')));
    }
  }

  String formatDate(dynamic value) {
    if (value == null) return 'N/A';

    final date = value is DateTime ? value : DateTime.parse(value.toString());

    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grade Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 183, 58, 58),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: loadGrades,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Grades',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : grades.isEmpty
          ? const Center(
              child: Text(
                'No grade records found.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadGrades,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  final grade = grades[index];
                  final score = grade['score'];
                  final status = getGradeStatus(score);
                  final statusColor = getGradeColor(score);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grade['student_name']?.toString() ??
                                'Unknown Student',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            '${grade['subject_code']} - '
                            '${grade['subject_name']}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),

                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grade: ${score == null ? 'Not graded' : (score as num).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withAlpha(30),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Date Recorded: '
                            '${formatDate(grade['date_recorded'])}',
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => editGrade(grade),
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                              TextButton.icon(
                                onPressed: () => deleteGrade(grade),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addGrade,
        backgroundColor: const Color.fromARGB(255, 183, 58, 58),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

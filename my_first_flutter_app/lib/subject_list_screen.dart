import 'package:flutter/material.dart';
import 'repositories/subject_repository.dart';
import 'add_subject_screen.dart';
import 'edit_subject_screen.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final SubjectRepository repository = SubjectRepository();

  List<Map<String, dynamic>> subjects = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await repository.getSubjects();

      if (!mounted) return;

      setState(() {
        subjects = data;
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

  Future<void> openAddSubjectScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSubjectScreen()),
    );

    if (result == true) {
      loadSubjects();
    }
  }

  Future<void> openEditSubjectScreen(Map<String, dynamic> subject) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSubjectScreen(subject: subject),
      ),
    );

    if (result == true) {
      loadSubjects();
    }
  }

  Future<void> deleteSubject(Map<String, dynamic> subject) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text(
          'Are you sure you want to delete '
          '${subject['subject_name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await repository.deleteSubject((subject['subject_id'] as num).toInt());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subject deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      await loadSubjects();
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().contains('23503')
          ? 'Cannot delete this subject because it is '
                'currently assigned to a schedule.'
          : 'Failed to delete subject: $e';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Widget buildSubjectCard(Map<String, dynamic> subject) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.menu_book)),

        title: Text(
          subject['subject_name'].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(
          'Code: ${subject['subject_code']}'
          '\nUnits: ${subject['units']}',
        ),

        isThreeLine: true,

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Edit Subject',
              onPressed: () => openEditSubjectScreen(subject),
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete Subject',
              onPressed: () => deleteSubject(subject),
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
        title: const Text('Subjects'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: loadSubjects,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh subjects',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: openAddSubjectScreen,
        tooltip: 'Add Subject',
        child: const Icon(Icons.add),
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
                      'Failed to load subjects:\n$errorMessage',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: loadSubjects,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          : subjects.isEmpty
          ? const Center(
              child: Text('No subjects found.', style: TextStyle(fontSize: 18)),
            )
          : RefreshIndicator(
              onRefresh: loadSubjects,
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return buildSubjectCard(subjects[index]);
                },
              ),
            ),
    );
  }
}

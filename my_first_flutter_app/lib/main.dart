import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Student_List_Screen.dart';
import 'student_details.dart';
import 'add_student_screen.dart';
import 'student.dart';
import 'core/db_connection.dart';
import 'subject_list_screen.dart';
import 'schedule_list_screen.dart';
import 'enrollment_list_screen.dart';
import 'grade_list_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool dbConnected = false;
  String? connectionError;

  try {
    // Load the database credentials
    await dotenv.load(fileName: '.env');

    // This is where it connects to postgre sql
    await DbConnection.instance.connect();

    dbConnected = true;
  } catch (e) {
    connectionError = e.toString();
    debugPrint('Database connection failed: $e');
  }

  runApp(const MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          dbConnected
              ? 'Database connected successfully!'
              : 'Database connection failed: $connectionError',
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Student Management System',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 183, 58, 58),
        ),
        useMaterial3: true,
      ),

      initialRoute: '/student-list',

      routes: {
        '/student-list': (context) =>
            const MyHomePage(title: 'Student Management System'),

        '/student-details': (context) {
          final student = ModalRoute.of(context)!.settings.arguments as Student;

          return SecondRoute(student: student);
        },

        '/add-student': (context) => const AddStudentScreen(),

        '/subject-list': (context) => const SubjectListScreen(),

        '/schedule-list': (context) => const ScheduleListScreen(),

        '/enrollment-list': (context) => const EnrollmentListScreen(),

        '/grade-list': (context) => const GradeListScreen(),
      },
    );
  }
}

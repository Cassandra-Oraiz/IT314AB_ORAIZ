import 'package:flutter/material.dart';
import 'Student_List_Screen.dart';
import 'student_details.dart';
import 'add_student_screen.dart';
import 'student.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  students = await loadStudents();

  students.sort((a, b) => a.name.compareTo(b.name));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 183, 58, 58),
        ),
      ),

      initialRoute: '/student-list',

      routes: {
        '/student-list': (context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),

        '/student-details': (context) {
          final student = ModalRoute.of(context)!.settings.arguments as Student;

          return SecondRoute(student: student);
        },

        '/add-student': (context) => const AddStudentScreen(),
      },
    );
  }
}

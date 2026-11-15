import 'package:flutter/material.dart';
import 'Student_List_Screen.dart';
import 'student_details.dart';
import 'add_student_screen.dart';

void main() {
  students.sort((a, b) => a.name.compareTo(b.name));
  runApp(const MyApp());
}

class Student {
  String images;
  String name;
  String course;
  int yearLevel;
  int age;
  String hobby;
  int id;
  String likes;
  String house;
  bool fav;
  bool isActive;

  Student({
    this.images = '',
    this.name = '',
    this.course = '',
    this.yearLevel = 0,
    this.age = 0,
    this.hobby = '',
    this.id = 0,
    this.likes = '',
    this.house = '',
    this.fav = false,
    this.isActive = true,
  });
}

List<Student> createStudent() {
  return [
    Student(
      fav: false,
      isActive: true,
      id: 1,
      house: 'Ravenclaw',
      likes: 'Wala',
      name: 'Cassandra Gayle R. Oraiz',
      age: 20,
      course: 'BSIT',
      yearLevel: 3,
      hobby: 'Drawing, Gaming, Crochet',
      images: 'assets/Me.jpg',
    ),

    Student(
      fav: false,
      isActive: true,
      id: 2,
      house: 'Hufflepuff',
      likes: 'SMC',
      name: 'Pure Vanilla Cookie',
      age: 20,
      course: 'BNA',
      yearLevel: 4,
      hobby: 'Gardening',
      images: 'assets/PV.jpg',
    ),

    Student(
      fav: false,
      isActive: false,
      id: 3,
      house: 'Slytherin',
      likes: 'Ran',
      name: 'Rin Itoshi',
      age: 22,
      course: 'BSS',
      yearLevel: 3,
      hobby: 'Horror enthusiast',
      images: 'assets/67.jpg',
    ),

    Student(
      fav: false,
      isActive: true,
      id: 4,
      house: 'Gryffindor',
      likes: 'Rin',
      name: 'Theodosia "Ran" Agapov',
      age: 23,
      course: 'BCS',
      yearLevel: 3,
      hobby: 'Football, Hairstyling',
      images: 'assets/Ran.jpg',
    ),

    Student(
      fav: false,
      isActive: false,
      id: 5,
      house: 'Slytherin',
      likes: 'In denial',
      name: 'Shadow Milk Cookie',
      age: 25,
      course: 'BFA',
      yearLevel: 4,
      hobby: 'Chismis',
      images: 'assets/SMC.jpg',
    ),

    Student(
      fav: false,
      isActive: false,
      id: 6,
      house: 'Gryffindor',
      likes: 'Heheh',
      name: 'Harry Potter',
      age: 25,
      course: 'IDK',
      yearLevel: 4,
      hobby: 'Quidditch',
      images: 'assets/SMC.jpg',
    ),
  ];
}

List<Student> students = createStudent();

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

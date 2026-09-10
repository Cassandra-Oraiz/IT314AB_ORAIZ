import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rainbow_text/rainbow_text.dart';

void main() {
  runApp(const MyApp());
  students.sort((a, b) => a.name.compareTo(b.name));
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Student {
  String images;
  String name;
  String course;
  int yearLevel;
  int age;
  String hobby;
  int ID;
  String likes;
  String house;

  Student({
    this.images = '',
    this.name = '',
    this.course = '',
    this.yearLevel = 0,
    this.age = 0,
    this.hobby = '',
    this.ID = 0,
    this.likes = '',
    this.house = '',
  });
}

List<Student> students = [
  Student(
    ID: 1,
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
    ID: 2,
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
    ID: 3,
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
    ID: 4,
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
    ID: 5,
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
    ID: 6,
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget weBuildThings(Student student) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          Text(
            student.name,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.teal.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                student.course,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              SizedBox(width: 5),
              Text(
                student.yearLevel.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
            ],
          ),

          SizedBox(height: 5),

          Text('Likes: ${student.likes}'),

          SizedBox(height: 5),

          Text(student.ID.toString()),

          SizedBox(height: 5),

          Text(student.house),

          SizedBox(height: 5),

          Row(
            mainAxisAlignment: .center,
            children: [Text(student.age.toString())],
          ),
          RainbowText(
            student.hobby,
            colors: [Colors.red, Colors.blue, Colors.green],
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 5),

          Image.asset(student.images, height: 150, width: 150),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],

        title: Text(widget.title),
      ),
      body: students.isEmpty
          ? Center(child: Text('No students here :P'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return weBuildThings(students[index]);
              },
            ),
    );
  }
}

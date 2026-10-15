import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rainbow_text/rainbow_text.dart';

void main() {
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
  bool fav;
  bool isActive;

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
    this.fav = false,
    this.isActive = true,
  });
}

List<Student> createStudent() {
  return [
    Student(
      fav: false,
      isActive: true,
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
      fav: false,
      isActive: true,
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
      fav: false,
      isActive: false,
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
      fav: false,
      isActive: true,
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
      fav: false,
      isActive: false,
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
      fav: false,
      isActive: false,
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
}

List<Student> students = createStudent();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Loading Successful!')));
    });
  }

  Widget weBuildThings(Student student) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('HEY!')));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.teal.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                student.fav
                    ? Icon(Icons.star, color: Colors.amber)
                    : SizedBox.shrink(),
              ],
            ),

            student.isActive
                ? Text(
                    'Active',
                    style: TextStyle(color: Color.fromARGB(255, 14, 199, 39)),
                  )
                : Text(
                    'Offline',
                    style: TextStyle(color: Color.fromARGB(255, 158, 148, 148)),
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

            Row(
              mainAxisAlignment: .center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      students.remove(student);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Button was pressed!')),
                    );
                  },
                  child: Text('Delete'),
                ),

                SizedBox(width: 5),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      student.fav = !student.fav;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are MY favorite')),
                    );
                  },
                  child: student.fav
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                ),

                SizedBox(width: 5),

                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('EDITTING STUDENTS')),
                    );
                  },
                  child: Text('Edit'),
                ),

                SizedBox(width: 5),
              ],
            ),

            SizedBox(height: 5),
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

        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                value: 0.7,
                color: Colors.green,
                backgroundColor: Colors.grey[200],
                strokeWidth: 6.0,
              ),
            )
          : students.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No students here :P'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        students = createStudent();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Student Restored')),
                      );
                    },
                    child: Text('Restore'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return weBuildThings(students[index]);
              },
            ),
    );
  }
}

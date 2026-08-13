import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rainbow_text/rainbow_text.dart';

void main() {
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String name = '🔥Cassandra Gayle R. Oraiz🔥';
  int age = 20;
  String courseAndSection = 'BSIT III';
  String hobby = 'Drawing, Gaming, Crochet';
  String favoriteFoods = 'Palabok';
  String favoriteMovie = 'Not Provided';
  String favoriteGame = 'Null';
  double height = 149.86;
  bool isStudent = true;

  String profileImage = 'assets/Me.jpg';

  void toggleSwitch() {
    setState(() {
      isStudent = !isStudent;
    });
  }

  String name1 = '☀️Pure Vanilla Cookie☀️';
  int age1 = 20;
  String courseAndSection1 = 'BSIT III';
  String hobby1 = 'NULL';
  double height1 = 6.0;
  bool isStudent1 = true;

  String profileImage1 = 'assets/PV.jpg';

  void toggleSwitch1() {
    setState(() {
      isStudent = !isStudent;
    });
  }

  String name2 = '🦉Rin Itoshi🦉';
  int age2 = 22;
  String courseAndSection2 = 'Missing';
  String hobby2 = 'Not Provided';
  double height2 = 6.0;
  bool isStudent2 = true;

  String profileImage2 = 'assets/67.jpg';

  void toggleSwitch2() {
    setState(() {
      isStudent = !isStudent;
    });
  }

  String name3 = '✨Theodosia "Ran" Agapov✨';
  int age3 = 23;
  String courseAndSection3 = 'BSIT III';
  String hobby3 = 'Football, Hairstyling';
  double height3 = 6.3;
  bool isStudent3 = true;

  String pfp3 = 'assets/Ran.jpg';

  void toggleSwitch3() {
    setState(() {
      isStudent = !isStudent;
    });
  }

  String name4 = 'EMPTY';
  int age4 = 25;
  String courseAndSection4 = 'BSIT III';
  String hobby4 = 'Chismis';
  double height4 = 6.0;
  bool isStudent4 = false;

  String profileImage4 = 'assets/SMC.jpg';

  void toggleSwitch4() {
    setState(() {
      isStudent = !isStudent;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            Card(
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
                    name,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.teal.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text('Student: $isStudent'),

                  SizedBox(height: 10),
                  Text(
                    courseAndSection,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    'My First flutter Application',
                    style: TextStyle(fontSize: 19),
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(age.toString()),

                      SizedBox(width: 10),
                      Text('August 11 2026'),

                      SizedBox(width: 10),
                      Text('Height:'),
                      Text(height.toString()),
                    ],
                  ),
                  RainbowText(
                    hobby,
                    colors: [Colors.red, Colors.blue, Colors.green],
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 5),

                  Image.asset(profileImage, height: 150, width: 150),
                ], // Image.asset
              ),
            ),

            Card(
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
                    name1,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.teal.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text('Student: $isStudent'),

                  SizedBox(height: 10),
                  Text(
                    courseAndSection1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    'My First flutter Application',
                    style: TextStyle(fontSize: 19),
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(age1.toString()),

                      SizedBox(width: 10),
                      Text('August 11 2026'),

                      SizedBox(width: 10),
                      Text('Height:'),
                      Text(height1.toString()),
                    ],
                  ),
                  RainbowText(
                    hobby1,
                    colors: [Colors.red],
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 5),

                  Image.asset(profileImage1, height: 150, width: 150),
                ], // Image.asset
              ),
            ),

            Card(
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
                    name2,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.teal.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text('Student: $isStudent'),

                  SizedBox(height: 10),
                  Text(
                    courseAndSection2,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    'My First flutter Application',
                    style: TextStyle(fontSize: 19),
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(age2.toString()),

                      SizedBox(width: 10),
                      Text('August 11 2026'),

                      SizedBox(width: 10),
                      Text('Height:'),
                      Text(height2.toString()),
                    ],
                  ),
                  RainbowText(
                    hobby2,
                    colors: [Colors.red, Colors.blue, Colors.green],
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 5),

                  Image.asset(profileImage2, height: 150, width: 150),
                ], // Image.asset
              ),
            ),

            Card(
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
                    name3,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.teal.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text('Student: $isStudent'),

                  SizedBox(height: 10),
                  Text(
                    courseAndSection3,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    'My First flutter Application',
                    style: TextStyle(fontSize: 19),
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(age3.toString()),

                      SizedBox(width: 10),
                      Text('August 11 2026'),

                      SizedBox(width: 10),
                      Text('Height:'),
                      Text(height3.toString()),
                    ],
                  ),
                  RainbowText(
                    hobby3,
                    colors: [Colors.red, Colors.blue, Colors.green],
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 5),

                  Image.asset(pfp3, height: 150, width: 150),
                ], // Image.asset
              ),
            ),

            Card(
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
                    name4,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.teal.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text('Student: $isStudent'),

                  SizedBox(height: 10),
                  Text(
                    courseAndSection4,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Text(
                    'My First flutter Application',
                    style: TextStyle(fontSize: 19),
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(age4.toString()),

                      SizedBox(width: 10),
                      Text('August 11 2026'),

                      SizedBox(width: 10),
                      Text('Height:'),
                      Text(height4.toString()),
                    ],
                  ),
                  RainbowText(
                    hobby4,
                    colors: [Colors.red, Colors.blue, Colors.green],
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 5),

                  Image.asset(profileImage4, height: 150, width: 150),
                ], // Image.asset
              ),
            ),

            Divider(thickness: 2),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.redAccent, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('MY FAVORITES'),
                  Row(
                    children: [
                      Text(
                        'FAVORITE GAMES:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(favoriteGame),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'FAVORITE FOODS:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(favoriteFoods),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'FAVORITE MOVIE:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(favoriteMovie),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

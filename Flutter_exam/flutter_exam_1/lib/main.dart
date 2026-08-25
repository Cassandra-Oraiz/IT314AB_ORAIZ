import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Details',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 248, 248, 248),
        ),
      ),
      home: const MyHomePage(title: 'Match Details'),
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

  String map = 'assets/ascent.jpg';

  String agent1 = 'assets/brimstone.webp';
  String agent2 = 'assets/chamber.webp';
  String agent3 = 'assets/clove.webp';
  String agent4 = 'assets/cypher.webp';
  String agent5 = 'assets/phoenix.webp';
  String agent6 = 'assets/raze.webp';
  String agent7 = 'assets/reyna.webp';
  String agent8 = 'assets/sova.webp';

  String rank1 = 'assets/gold-1.webp';
  String rank2 = 'assets/gold-2.webp';
  String rank3 = 'assets/gold-3.webp';
  String rank4 = 'assets/plat-1.webp';
  String rank5 = 'assets/plat-2.webp';

  String kda1 = '23/21/6';
  String kda2 = '17/21/8';
  String kda3 = '9/8/1';
  String kda4 = '28/23/6';
  String kda5 = '21/21/10';
  String kda6 = '20/18/5';
  String kda7 = '18/21/2';
  String kda8 = '19/19/4';
  String kda9 = '23/21/5';
  String kda10 = '13/19/9';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 238, 238),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: .center,
              children: [
                Text('My Team', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 50),
                Text('12'),
                SizedBox(width: 10),
                Text('14'),
                SizedBox(width: 50),
                Text('Opponent'),
              ],
            ),
            SizedBox(height: 5),
            Image.asset(map, height: 200, width: 1500),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                Image.asset(agent5, height: 50, width: 50),
                SizedBox(width: 5),
                Text('Scyn4pse'),
                SizedBox(width: 50),
                Text('261'),
                SizedBox(width: 10),
                Text(kda1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

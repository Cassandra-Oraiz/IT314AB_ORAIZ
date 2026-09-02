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
      title: 'Social',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Social'),
    );
  }
}

class Player {
  String? name;
  String? status;

  Player({this.name, this.status});
}

List<Player> players = [
  Player(name: 'MissYouLikeKrazy', status: 'Online - VALORANT'),

  Player(name: 'bread', status: 'Online - VALORANT'),

  Player(name: 'The14th', status: 'Online - VALORANT'),

  Player(name: 'Carlvendish', status: 'Away - Riot Mobile'),

  Player(name: 'D1yah', status: 'Away - Riot Mobile'),
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(9), title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15),
                Text('Friends'),
                SizedBox(width: 15),
                Text('Messages'),
                SizedBox(width: 15),
                Text('Requests'),
              ],
            ),

            SizedBox(height: 20),

            Container(
              width: 355,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF211D1F),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(Icons.search, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text('Search'),
                ],
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text(
                  'VALORANT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(width: 10),

                Text('3', style: TextStyle(fontSize: 20)),
              ],
            ),

            SizedBox(height: 20),

            Row(
              children: [
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(0, 119, 112, 112),
                  child: Icon(Icons.person, size: 28, color: Colors.red),
                ),

                SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      players[0].name ?? "Null",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.monitor),
                        Text(players[0].status ?? "Null"),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(0, 119, 112, 112),
                  child: Icon(Icons.person, size: 28, color: Colors.red),
                ),

                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      players[1].name ?? "Null",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(players[1].status ?? "Null"),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(0, 119, 112, 112),
                  child: Icon(Icons.person, size: 28, color: Colors.red),
                ),

                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      players[2].name ?? "Null",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(players[2].status ?? "Null"),
                  ],
                ),
              ],
            ),

            SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                Text('Online', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Text('4'),
              ],
            ),

            SizedBox(height: 15),

            Row(
              children: [
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(0, 119, 112, 112),
                  child: Icon(Icons.person, size: 28),
                ),

                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      players[3].name ?? "Null",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(players[3].status ?? "Null"),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                SizedBox(width: 15),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(0, 119, 112, 112),
                  child: Icon(Icons.person, size: 28),
                ),

                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      players[4].name ?? "Null",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(players[4].status ?? "Null"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

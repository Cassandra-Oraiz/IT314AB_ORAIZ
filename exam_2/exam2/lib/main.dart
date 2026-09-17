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
  Widget weBuildThings(Player player) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('eh')));
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                      player.name ?? "Null",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.monitor),
                        Text(player.status ?? "Null"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text(widget.title)),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return weBuildThings(players[index]);
        },
      ),
    );
  }
}

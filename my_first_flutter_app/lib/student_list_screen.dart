import 'package:flutter/material.dart';
import 'package:rainbow_text/rainbow_text.dart';
import 'student_details.dart';
import 'main.dart';
import 'add_student_screen.dart';

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
        Navigator.pushNamed(context, '/student-details', arguments: student);
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

            Text(student.id.toString()),

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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-student');
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
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

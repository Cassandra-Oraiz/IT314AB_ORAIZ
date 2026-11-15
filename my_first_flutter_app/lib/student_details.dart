import 'package:flutter/material.dart';
import 'main.dart';

class SecondRoute extends StatefulWidget {
  final Student student;

  const SecondRoute({super.key, required this.student});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.student.name),
                Text(widget.student.course),
                Text("Year Level: ${widget.student.yearLevel}"),
                Text("Age: ${widget.student.age}"),
                Text("Hobby: ${widget.student.hobby}"),
                Text("House: ${widget.student.house}"),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final nameController = TextEditingController(
                      text: widget.student.name,
                    );
                    final courseController = TextEditingController(
                      text: widget.student.course,
                    );
                    final ageController = TextEditingController(
                      text: widget.student.age.toString(),
                    );
                    final hobbyController = TextEditingController(
                      text: widget.student.hobby,
                    );
                    final houseController = TextEditingController(
                      text: widget.student.house,
                    );

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 20,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Edit Student',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                  ),
                                ),

                                TextField(
                                  controller: courseController,
                                  decoration: InputDecoration(
                                    labelText: 'Course',
                                  ),
                                ),

                                TextField(
                                  controller: ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'Age'),
                                ),

                                TextField(
                                  controller: hobbyController,
                                  decoration: InputDecoration(
                                    labelText: 'Hobby',
                                  ),
                                ),

                                TextField(
                                  controller: houseController,
                                  decoration: InputDecoration(
                                    labelText: 'House',
                                  ),
                                ),

                                SizedBox(height: 20),

                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.student.name = nameController.text;
                                      widget.student.course =
                                          courseController.text;
                                      widget.student.age =
                                          int.tryParse(ageController.text) ??
                                          widget.student.age;
                                      widget.student.hobby =
                                          hobbyController.text;
                                      widget.student.house =
                                          houseController.text;
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Text('Save Changes'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Edit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> saveStudents(List<Student> students) async {
  final directory = await getApplicationDocumentsDirectory();

  final file = File('${directory.path}/students.json');

  final jsonData = students.map((student) => student.toJson()).toList();

  await file.writeAsString(jsonEncode(jsonData));
}

Future<List<Student>> loadStudents() async {
  final directory = await getApplicationDocumentsDirectory();

  final file = File('${directory.path}/students.json');

  if (await file.exists()) {
    final jsonString = await file.readAsString();

    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((data) => Student.fromJson(data)).toList();
  } else {
    List<Student> defaultStudents = createStudent();

    await saveStudents(defaultStudents);

    return defaultStudents;
  }
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

  Map<String, dynamic> toJson() {
    return {
      'images': images,
      'name': name,
      'course': course,
      'yearLevel': yearLevel,
      'age': age,
      'hobby': hobby,
      'id': id,
      'likes': likes,
      'house': house,
      'fav': fav,
      'isActive': isActive,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      images: json['images'] ?? '',
      name: json['name'] ?? '',
      course: json['course'] ?? '',
      yearLevel: json['yearLevel'] ?? 0,
      age: json['age'] ?? 0,
      hobby: json['hobby'] ?? '',
      id: json['id'] ?? 0,
      likes: json['likes'] ?? '',
      house: json['house'] ?? '',
      fav: json['fav'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }
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

class Student {
  final int studentId;
  final int studentNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String course;
  final int yearLevel;
  final int programId;
  final DateTime? createdAt;

  Student({
    required this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.course,
    required this.yearLevel,
    required this.programId,
    this.createdAt,
  });

  // Convert a database record into a Student object.
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      studentId: (map['studentid'] as num).toInt(),
      studentNumber: (map['student_number'] as num).toInt(),
      firstName: map['firstname'].toString(),
      lastName: map['lastname'].toString(),
      email: map['email'].toString(),
      contactNumber: map['contact_number'].toString(),
      course: map['course'].toString(),
      yearLevel: (map['year_level'] as num).toInt(),
      programId: (map['programid'] as num).toInt(),
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }

  // Get the student's complete name.
  String get fullName => '$firstName $lastName';
}

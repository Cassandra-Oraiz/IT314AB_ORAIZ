import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../student.dart';

class StudentRepository {
  final DbConnection _db = DbConnection.instance;

  Future<List<Student>> getStudents() async {
    final result = await _db.connection.execute(
      'SELECT * FROM students ORDER BY studentid',
    );

    return result.map((row) => Student.fromMap(row.toColumnMap())).toList();
  }

  Future<Student> addStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String contactNumber,
    required String course,
    required int yearLevel,
    required int programId,
  }) async {
    final result = await _db.connection.execute(
      Sql.named('''
        INSERT INTO students (
          firstname,
          lastname,
          email,
          contact_number,
          course,
          year_level,
          programid
        )
        VALUES (
          @firstName,
          @lastName,
          @email,
          @contactNumber,
          @course,
          @yearLevel,
          @programId
        )
        RETURNING *
      '''),
      parameters: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'contactNumber': contactNumber,
        'course': course,
        'yearLevel': yearLevel,
        'programId': programId,
      },
    );

    return Student.fromMap(result.first.toColumnMap());
  }

  Future<Student> updateStudent(Student student) async {
    final result = await _db.connection.execute(
      Sql.named('''
        UPDATE students
        SET firstname = @firstName,
            lastname = @lastName,
            email = @email,
            contact_number = @contactNumber,
            course = @course,
            year_level = @yearLevel,
            programid = @programId
        WHERE studentid = @studentId
        RETURNING *
      '''),
      parameters: {
        'firstName': student.firstName,
        'lastName': student.lastName,
        'email': student.email,
        'contactNumber': student.contactNumber,
        'course': student.course,
        'yearLevel': student.yearLevel,
        'programId': student.programId,
        'studentId': student.studentId,
      },
    );

    if (result.isEmpty) {
      throw Exception('Student not found.');
    }

    return Student.fromMap(result.first.toColumnMap());
  }

  Future<void> deleteStudent(int studentId) async {
    final result = await _db.connection.execute(
      Sql.named('DELETE FROM students WHERE studentid = @studentId'),
      parameters: {'studentId': studentId},
    );

    if (result.affectedRows == 0) {
      throw Exception('Student not found.');
    }
  }

  Future<List<Map<String, dynamic>>> getPrograms() async {
    final result = await _db.connection.execute(
      'SELECT programid, programcode, programname '
      'FROM programs ORDER BY programid',
    );

    return result.map((row) => row.toColumnMap()).toList();
  }
}

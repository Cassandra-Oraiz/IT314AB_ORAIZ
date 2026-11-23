import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';

class EnrollmentRepository {
  final DbConnection _db = DbConnection.instance;

  Future<List<Map<String, dynamic>>> getEnrollments() async {
    final result = await _db.connection.execute('''
      SELECT
        e.enrollment_id,
        e.student_id,
        e.schedule_id,
        e.subject_id,
        e.enrolled_at,
        e.status,
        CONCAT(st.firstname, ' ', st.lastname) AS student_name,
        st.email,
        sub.subject_code,
        sub.subject_name,
        s.day_of_week,
        s.start_time,
        s.end_time,
        s.room
      FROM enrollment e
      INNER JOIN students st
        ON e.student_id = st.studentid
      INNER JOIN schedule s
        ON e.schedule_id = s.schedule_id
      INNER JOIN subject sub
        ON e.subject_id = sub.subject_id
      ORDER BY e.enrollment_id
      ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final result = await _db.connection.execute('''
      SELECT
        studentid,
        firstname,
        lastname
      FROM students
      ORDER BY lastname, firstname
      ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<List<Map<String, dynamic>>> getSchedules() async {
    final result = await _db.connection.execute('''
      SELECT
        s.schedule_id,
        s.subject_id,
        s.day_of_week,
        s.start_time,
        s.end_time,
        s.room,
        sub.subject_code,
        sub.subject_name
      FROM schedule s
      INNER JOIN subject sub
        ON s.subject_id = sub.subject_id
      ORDER BY s.schedule_id
      ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<void> addEnrollment({
    required int studentId,
    required int scheduleId,
    required DateTime enrolledAt,
    required bool status,
  }) async {
    await _db.connection.execute(
      Sql.named('''
        INSERT INTO enrollment (
          student_id,
          schedule_id,
          subject_id,
          enrolled_at,
          status
        )
        SELECT
          @studentId,
          s.schedule_id,
          s.subject_id,
          CAST(@enrolledAt AS timestamp),
          @status
        FROM schedule s
        WHERE s.schedule_id = @scheduleId
      '''),
      parameters: {
        'studentId': studentId,
        'scheduleId': scheduleId,
        'enrolledAt': enrolledAt.toIso8601String(),
        'status': status,
      },
    );
  }

  Future<void> updateEnrollment({
    required int enrollmentId,
    required int studentId,
    required int scheduleId,
    required DateTime enrolledAt,
    required bool status,
  }) async {
    final result = await _db.connection.execute(
      Sql.named('''
        UPDATE enrollment e
        SET student_id = @studentId,
            schedule_id = s.schedule_id,
            subject_id = s.subject_id,
            enrolled_at = CAST(@enrolledAt AS timestamp),
            status = @status
        FROM schedule s
        WHERE e.enrollment_id = @enrollmentId
          AND s.schedule_id = @scheduleId
      '''),
      parameters: {
        'enrollmentId': enrollmentId,
        'studentId': studentId,
        'scheduleId': scheduleId,
        'enrolledAt': enrolledAt.toIso8601String(),
        'status': status,
      },
    );

    if (result.affectedRows == 0) {
      throw Exception('Enrollment or selected schedule not found.');
    }
  }

  Future<void> deleteEnrollment(int enrollmentId) async {
    try {
      final result = await _db.connection.execute(
        Sql.named('DELETE FROM enrollment WHERE enrollment_id = @enrollmentId'),
        parameters: {'enrollmentId': enrollmentId},
      );

      if (result.affectedRows == 0) {
        throw Exception('Enrollment not found.');
      }
    } on ServerException catch (e) {
      if (e.code == '23503') {
        throw Exception(
          'Cannot delete this enrollment because it is being '
          'used by an existing grade record.',
        );
      }

      rethrow;
    }
  }
}

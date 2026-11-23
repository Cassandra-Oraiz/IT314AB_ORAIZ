import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';

class GradeRepository {
  final DbConnection _db = DbConnection.instance;

  Future<List<Map<String, dynamic>>> getGrades() async {
    final result = await _db.connection.execute('''
      SELECT
        g.gradeid,
        g.score,
        g.remarks,
        g.date_recorded,
        g.enrollment_id,
        CONCAT(st.firstname, ' ', st.lastname) AS student_name,
        sub.subject_code,
        sub.subject_name
      FROM grades g
      INNER JOIN enrollment e
        ON g.enrollment_id = e.enrollment_id
      INNER JOIN students st
        ON e.student_id = st.studentid
      INNER JOIN subject sub
        ON e.subject_id = sub.subject_id
      ORDER BY g.gradeid
    ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<List<Map<String, dynamic>>> getEnrollments() async {
    final result = await _db.connection.execute('''
      SELECT
        e.enrollment_id,
        CONCAT(st.firstname, ' ', st.lastname) AS student_name,
        sub.subject_code,
        sub.subject_name
      FROM enrollment e
      INNER JOIN students st
        ON e.student_id = st.studentid
      INNER JOIN subject sub
        ON e.subject_id = sub.subject_id
      ORDER BY e.enrollment_id
    ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<void> addGrade({
    required int enrollmentId,
    required double score,
    required String remarks,
  }) async {
    await _db.connection.execute(
      Sql.named('''
        INSERT INTO grades (
          enrollment_id,
          score,
          remarks
        )
        VALUES (
          @enrollmentId,
          @score,
          @remarks
        )
      '''),
      parameters: {
        'enrollmentId': enrollmentId,
        'score': score,
        'remarks': remarks,
      },
    );
  }

  Future<void> updateGrade({
    required int gradeId,
    required int enrollmentId,
    required double score,
    required String remarks,
  }) async {
    final result = await _db.connection.execute(
      Sql.named('''
        UPDATE grades
        SET enrollment_id = @enrollmentId,
            score = @score,
            remarks = @remarks
        WHERE gradeid = @gradeId
      '''),
      parameters: {
        'gradeId': gradeId,
        'enrollmentId': enrollmentId,
        'score': score,
        'remarks': remarks,
      },
    );

    if (result.affectedRows == 0) {
      throw Exception('Grade record not found.');
    }
  }

  Future<void> deleteGrade(int gradeId) async {
    final result = await _db.connection.execute(
      Sql.named('DELETE FROM grades WHERE gradeid = @gradeId'),
      parameters: {'gradeId': gradeId},
    );

    if (result.affectedRows == 0) {
      throw Exception('Grade record not found.');
    }
  }
}

import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';

class SubjectRepository {
  final DbConnection _db = DbConnection.instance;

  Future<List<Map<String, dynamic>>> getSubjects() async {
    final result = await _db.connection.execute(
      'SELECT * FROM subject ORDER BY subject_id',
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<void> addSubject({
    required String subjectCode,
    required String subjectName,
    required int units,
    String? description,
  }) async {
    await _db.connection.execute(
      Sql.named('''
        INSERT INTO subject (
          subject_code,
          subject_name,
          units,
          description
        )
        VALUES (
          @subjectCode,
          @subjectName,
          @units,
          @description
        )
      '''),
      parameters: {
        'subjectCode': subjectCode,
        'subjectName': subjectName,
        'units': units,
        'description': description,
      },
    );
  }

  Future<void> updateSubject({
    required int subjectId,
    required String subjectCode,
    required String subjectName,
    required int units,
    String? description,
  }) async {
    final result = await _db.connection.execute(
      Sql.named('''
        UPDATE subject
        SET subject_code = @subjectCode,
            subject_name = @subjectName,
            units = @units,
            description = @description
        WHERE subject_id = @subjectId
      '''),
      parameters: {
        'subjectId': subjectId,
        'subjectCode': subjectCode,
        'subjectName': subjectName,
        'units': units,
        'description': description,
      },
    );

    if (result.affectedRows == 0) {
      throw Exception('Subject not found.');
    }
  }

  Future<void> deleteSubject(int subjectId) async {
    final result = await _db.connection.execute(
      Sql.named('DELETE FROM subject WHERE subject_id = @subjectId'),
      parameters: {'subjectId': subjectId},
    );

    if (result.affectedRows == 0) {
      throw Exception('Subject not found.');
    }
  }
}

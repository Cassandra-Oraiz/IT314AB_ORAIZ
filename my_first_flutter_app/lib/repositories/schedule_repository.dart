import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';

class ScheduleRepository {
  final DbConnection _db = DbConnection.instance;

  Future<List<Map<String, dynamic>>> getSchedules() async {
    final result = await _db.connection.execute('''
      SELECT
        s.schedule_id,
        s.day_of_week,
        s.start_time,
        s.end_time,
        s.room,
        s.slot_capacity,
        s.subject_id,
        sub.subject_code,
        sub.subject_name
      FROM schedule s
      INNER JOIN subject sub
        ON s.subject_id = sub.subject_id
      ORDER BY s.schedule_id
      ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    final result = await _db.connection.execute('''
      SELECT
        subject_id,
        subject_code,
        subject_name
      FROM subject
      ORDER BY subject_name
      ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<void> addSchedule({
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required String room,
    required int slotCapacity,
    required int subjectId,
  }) async {
    await _db.connection.execute(
      Sql.named('''
        INSERT INTO schedule (
          day_of_week,
          start_time,
          end_time,
          room,
          slot_capacity,
          subject_id
        )
        VALUES (
          @dayOfWeek,
          CAST(@startTime AS time),
          CAST(@endTime AS time),
          @room,
          @slotCapacity,
          @subjectId
        )
      '''),
      parameters: {
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'slotCapacity': slotCapacity,
        'subjectId': subjectId,
      },
    );
  }

  Future<void> updateSchedule({
    required int scheduleId,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required String room,
    required int slotCapacity,
    required int subjectId,
  }) async {
    final result = await _db.connection.execute(
      Sql.named('''
        UPDATE schedule
        SET day_of_week = @dayOfWeek,
            start_time = CAST(@startTime AS time),
            end_time = CAST(@endTime AS time),
            room = @room,
            slot_capacity = @slotCapacity,
            subject_id = @subjectId
        WHERE schedule_id = @scheduleId
      '''),
      parameters: {
        'scheduleId': scheduleId,
        'dayOfWeek': dayOfWeek,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'slotCapacity': slotCapacity,
        'subjectId': subjectId,
      },
    );

    if (result.affectedRows == 0) {
      throw Exception('Schedule not found.');
    }
  }

  Future<void> deleteSchedule(int scheduleId) async {
    try {
      final result = await _db.connection.execute(
        Sql.named('DELETE FROM schedule WHERE schedule_id = @scheduleId'),
        parameters: {'scheduleId': scheduleId},
      );

      if (result.affectedRows == 0) {
        throw Exception('Schedule not found.');
      }
    } on ServerException catch (e) {
      if (e.code == '23503') {
        throw Exception(
          'Cannot delete this schedule because it is being used '
          'by an existing enrollment. Keep this schedule or '
          'manage its enrollments first.',
        );
      }

      rethrow;
    }
  }
}

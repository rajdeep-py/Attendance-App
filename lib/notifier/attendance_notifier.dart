import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../services/attendance_services.dart';

class AttendanceNotifier extends StateNotifier<Map<DateTime, Attendance>> {


  final AttendanceServices _attendanceServices = AttendanceServices();
  AttendanceNotifier() : super({});

  Future<void> fetchAttendanceByEmployee(int employeeId) async {
    final records = await _attendanceServices.getAttendanceByEmployee(employeeId);
    if (records.isEmpty) {
      state = {};
    } else {
      final map = {for (var a in records) _dateOnly(a.checkIn ?? DateTime.now()): a};
      state = map;
    }
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  void setAttendance(DateTime date, Attendance attendance) {
    final key = _dateOnly(date);
    state = {
      ...state,
      key: attendance,
    };
  }

  Attendance? getAttendance(DateTime date) {
    final key = _dateOnly(date);
    return state[key];
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';

class AttendanceNotifier extends StateNotifier<Map<DateTime, Attendance>> {
  AttendanceNotifier()
      : super({
          _dateOnly(DateTime(2026, 3, 18)): Attendance(
            checkIn: DateTime(2026, 3, 18, 9, 15),
            checkOut: DateTime(2026, 3, 18, 18, 0),
            location: 'Office HQ',
          ),
          _dateOnly(DateTime(2026, 3, 19)): Attendance(
            checkIn: DateTime(2026, 3, 19, 9, 30),
            checkOut: DateTime(2026, 3, 19, 17, 45),
            location: 'Remote',
          ),
          _dateOnly(DateTime(2026, 3, 20)): Attendance(
            checkIn: DateTime(2026, 3, 20, 10, 0),
            checkOut: DateTime(2026, 3, 20, 16, 30),
            location: 'Office HQ',
          ),
        });

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

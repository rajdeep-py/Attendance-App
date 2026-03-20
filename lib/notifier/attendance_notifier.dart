import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';

class AttendanceNotifier extends StateNotifier<Map<DateTime, Attendance>> {
  AttendanceNotifier() : super({});

  void setAttendance(DateTime date, Attendance attendance) {
    state = {
      ...state,
      date: attendance,
    };
  }

  Attendance? getAttendance(DateTime date) {
    return state[date];
  }
}

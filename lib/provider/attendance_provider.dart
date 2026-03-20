import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../notifier/attendance_notifier.dart';

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, Map<DateTime, Attendance>>(
  (ref) => AttendanceNotifier(),
);

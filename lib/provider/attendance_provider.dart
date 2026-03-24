import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../notifier/attendance_notifier.dart';
import 'auth_provider.dart';

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, Map<DateTime, Attendance>>(
  (ref) {
    final user = ref.watch(authProvider);
    final notifier = AttendanceNotifier();
    if (user?.employeeId != null) {
      notifier.fetchAttendanceByEmployee(user!.employeeId!);
    }
    return notifier;
  },
);

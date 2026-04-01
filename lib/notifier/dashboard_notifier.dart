import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../services/attendance_services.dart';
import '../widgets/background_location_service.dart';

class DashboardNotifier extends StateNotifier<Attendance> {
  // Public method to fetch and set the latest attendance for a given employee
  Future<void> fetchLatestAttendance(int employeeId) async {
    final records = await _attendanceServices.getAttendanceByEmployee(
      employeeId,
    );
    if (records.isNotEmpty) {
      final now = DateTime.now();
      try {
        final todayRecord = records.firstWhere((r) {
          if (r.checkIn == null) return false;
          final localCheckIn = r.checkIn!.toLocal();
          return localCheckIn.year == now.year &&
              localCheckIn.month == now.month &&
              localCheckIn.day == now.day;
        });
        state = todayRecord;
        return;
      } catch (_) {
        // No record for today
      }
    }
    // Reset state if no record for today
    state = Attendance();
  }

  final AttendanceServices _attendanceServices = AttendanceServices();
  DashboardNotifier() : super(Attendance());

  Future<void> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    await _attendanceServices.checkIn(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photo: File(photoPath),
    );
    // Fetch latest attendance and update state
    await fetchLatestAttendance(employeeId);

	// Start background tracking after a successful check-in.
	await BackgroundLocationService.startTracking(employeeId: employeeId);
  }

  Future<void> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required String photoPath,
  }) async {
    await _attendanceServices.checkOut(
      employeeId: employeeId,
      latitude: latitude,
      longitude: longitude,
      photo: File(photoPath),
    );
    // Fetch latest attendance and update state
    await fetchLatestAttendance(employeeId);

	// Stop background tracking after a successful check-out.
	await BackgroundLocationService.stopTracking();
  }
}

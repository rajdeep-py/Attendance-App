import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

import '../models/attendance.dart';
import '../services/attendance_services.dart';

class DashboardNotifier extends StateNotifier<Attendance> {
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
		// Optionally, fetch latest attendance and update state
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
		// Optionally, fetch latest attendance and update state
	}
}

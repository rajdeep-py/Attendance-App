import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';

import '../models/attendance.dart';
import '../services/attendance_services.dart';

class DashboardNotifier extends StateNotifier<Attendance> {

		// Public method to fetch and set the latest attendance for a given employee
		Future<void> fetchLatestAttendance(int employeeId) async {
			final records = await _attendanceServices.getAttendanceByEmployee(employeeId);
			if (records.isNotEmpty) {
				state = records.first;
			} else {
				state = Attendance();
			}
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
		final records = await _attendanceServices.getAttendanceByEmployee(employeeId);
		if (records.isNotEmpty) {
			// Assuming the latest record is the first one
			state = records.first;
		}
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
		final records = await _attendanceServices.getAttendanceByEmployee(employeeId);
		if (records.isNotEmpty) {
			// Assuming the latest record is the first one
			state = records.first;
		}
	}
}

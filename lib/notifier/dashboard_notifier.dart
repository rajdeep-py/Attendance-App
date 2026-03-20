import '../models/attendance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends StateNotifier<Attendance> {
	DashboardNotifier() : super(Attendance());

	void checkIn(DateTime time, String location) {
		state = state.copyWith(checkIn: time, location: location);
	}

	void checkOut(DateTime time) {
		state = state.copyWith(checkOut: time);
	}
}

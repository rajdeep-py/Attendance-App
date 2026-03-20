import 'package:flutter_riverpod/legacy.dart';

import '../models/attendance.dart';

class DashboardNotifier extends StateNotifier<Attendance> {
	DashboardNotifier() : super(Attendance());

	void checkIn(DateTime time, String location, String selfiePath) {
		state = state.copyWith(checkIn: time, location: location, checkInSelfie: selfiePath);
	}

	void checkOut(DateTime time, String selfiePath) {
		state = state.copyWith(checkOut: time, checkOutSelfie: selfiePath);
	}
}

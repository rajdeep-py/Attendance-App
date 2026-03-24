import 'package:flutter_riverpod/legacy.dart';
import '../notifier/dashboard_notifier.dart';
import '../models/attendance.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, Attendance>(
	(ref) {
		// Optionally, use user context here if needed in the future
		return DashboardNotifier();
	},
);

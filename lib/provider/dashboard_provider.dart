import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/dashboard_notifier.dart';
import '../models/attendance.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, Attendance>(
	(ref) => DashboardNotifier(),
);

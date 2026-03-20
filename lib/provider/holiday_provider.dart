import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/holiday_notifier.dart';
import '../models/holiday.dart';

final holidayProvider = StateNotifierProvider<HolidayNotifier, Map<DateTime, Holiday>>(
  (ref) => HolidayNotifier(),
);

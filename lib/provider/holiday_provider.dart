
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/holiday.dart';
import '../notifier/holiday_notifier.dart';

final holidayProvider = StateNotifierProvider<HolidayNotifier, Map<DateTime, Holiday>>(
  (ref) => HolidayNotifier(),
);

/// Provides access to the full HolidayNotifier for loading, error, and requests state
final holidayNotifierProvider = Provider<HolidayNotifier>((ref) {
  return ref.read(holidayProvider.notifier);
});


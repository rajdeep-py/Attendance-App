
import 'package:flutter_riverpod/legacy.dart';

import '../models/holiday.dart';
import '../notifier/holiday_notifier.dart';

final holidayProvider = StateNotifierProvider<HolidayNotifier, Map<DateTime, Holiday>>(
  (ref) => HolidayNotifier(),
);


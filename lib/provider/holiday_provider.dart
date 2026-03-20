import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifier/holiday_notifier.dart';
import '../models/holiday_request.dart';
import '../models/holiday.dart';

final holidayProvider = StateNotifierProvider<HolidayNotifier, Map<DateTime, Holiday>>(
  (ref) => HolidayNotifier(),
);
final holidayRequestProvider = Provider<List<HolidayRequest>>((ref) {
  final notifier = ref.read(holidayProvider.notifier);
  return notifier.requests;
});


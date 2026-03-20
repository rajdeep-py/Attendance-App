import 'package:flutter_riverpod/legacy.dart';
import '../models/holiday.dart';
import '../models/holiday_request.dart';

class HolidayNotifier extends StateNotifier<Map<DateTime, Holiday>> {
  List<HolidayRequest> requests = [];

  HolidayNotifier()
      : super({
          _dateOnly(DateTime(2026, 3, 25)): Holiday(
            date: DateTime(2026, 3, 25),
            name: 'Holi',
            occasion: 'Festival of Colors',
          ),
          _dateOnly(DateTime(2026, 4, 14)): Holiday(
            date: DateTime(2026, 4, 14),
            name: 'Ambedkar Jayanti',
            occasion: 'Birth anniversary of Dr. B.R. Ambedkar',
          ),
          _dateOnly(DateTime(2026, 5, 1)): Holiday(
            date: DateTime(2026, 5, 1),
            name: 'May Day',
            occasion: 'International Workers Day',
          ),
        });
  void addRequest(HolidayRequest request) {
    requests.add(request);
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  void setHoliday(DateTime date, Holiday holiday) {
    final key = _dateOnly(date);
    state = {
      ...state,
      key: holiday,
    };
  }

  Holiday? getHoliday(DateTime date) {
    final key = _dateOnly(date);
    return state[key];
  }
}

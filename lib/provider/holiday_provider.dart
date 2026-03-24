
import 'package:flutter_riverpod/legacy.dart';
import '../models/holiday.dart';
import '../notifier/holiday_notifier.dart';
import 'auth_provider.dart';

final holidayProvider = StateNotifierProvider<HolidayNotifier, Map<DateTime, Holiday>>(
  (ref) {
    final user = ref.watch(authProvider);
    final notifier = HolidayNotifier();
    if (user?.adminId != null) {
      notifier.fetchHolidaysByAdmin(user!.adminId!);
    }
    return notifier;
  },
);


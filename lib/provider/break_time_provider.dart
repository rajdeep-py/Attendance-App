import 'package:flutter_riverpod/legacy.dart';
import '../notifier/break_time_notifier.dart';
import '../models/break_time.dart';

final breakTimeProvider =
    StateNotifierProvider<BreakTimeNotifier, List<BreakTime>>((ref) {
      return BreakTimeNotifier();
    });

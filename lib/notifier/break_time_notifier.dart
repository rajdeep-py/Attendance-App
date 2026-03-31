import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
// Note: using flutter_riverpod as it exports StateNotifier in older versions. If it's pure dart use riverpod.
// In the other file legacy.dart is used, we can fallback to that if compilation fails.
// We will use standard flutter_riverpod.dart here.

import '../models/break_time.dart';
import '../services/break_time_services.dart';

class BreakTimeNotifier extends StateNotifier<List<BreakTime>> {
  final BreakTimeServices _breakTimeServices = BreakTimeServices();

  BreakTimeNotifier() : super([]);

  // Fetch all breaks and filter for today's active ones (or just expose all for today)
  Future<void> fetchTodayBreaks(int employeeId) async {
    try {
      final records = await _breakTimeServices.getBreaksByEmployee(employeeId);
      final now = DateTime.now();

      // Filter the records that happen today
      final todayBreaks = records.where((r) {
        if (r.breakInTime == null) return false;
        final localBreakIn = r.breakInTime!.toLocal();
        return localBreakIn.year == now.year &&
            localBreakIn.month == now.month &&
            localBreakIn.day == now.day;
      }).toList();

      state = todayBreaks;
    } catch (e) {
      state = [];
      // Ignore or log error
    }
  }

  Future<void> startBreak({
    required int employeeId,
    required String photoPath,
  }) async {
    await _breakTimeServices.checkInBreak(
      employeeId: employeeId,
      photo: File(photoPath),
    );
    // Fetch latest breaks to update state
    await fetchTodayBreaks(employeeId);
  }

  Future<void> endBreak({
    required int employeeId,
    required String photoPath,
  }) async {
    await _breakTimeServices.checkOutBreak(
      employeeId: employeeId,
      photo: File(photoPath),
    );
    // Fetch latest breaks to update state
    await fetchTodayBreaks(employeeId);
  }

  // Helper method to get the current active break, if any
  BreakTime? getActiveBreak() {
    if (state.isEmpty) return null;

    // An active break has a breakInTime but no breakOutTime
    for (var b in state) {
      if (b.breakInTime != null && b.breakOutTime == null) {
        return b;
      }
    }

    // As a fallback, sort by descending time and check the latest
    // The backend limits 1 active break per attendance session.
    return null;
  }
}

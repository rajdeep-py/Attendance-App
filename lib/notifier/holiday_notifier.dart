import 'package:flutter_riverpod/legacy.dart';
import '../models/holiday.dart';
import '../models/holiday_request.dart';
import '../services/leave_request_services.dart';
import '../services/holiday_services.dart';

class HolidayNotifier extends StateNotifier<Map<DateTime, Holiday>> {
  final LeaveRequestServices _leaveRequestServices = LeaveRequestServices();
  final HolidayServices _holidayServices = HolidayServices();
  List<HolidayRequest> _requests = [];
  bool _loading = false;
  String? _error;

  List<HolidayRequest> get requests => _requests;
  bool get loading => _loading;
  String? get error => _error;

  HolidayNotifier() : super({});

  Future<void> fetchHolidaysByAdmin(int adminId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final holidays = await _holidayServices.getHolidaysByAdmin(adminId);
      final holidayMap = {for (var h in holidays) _dateOnly(h.date): h};
      state = holidayMap;
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchRequests(int employeeId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _requests = await _leaveRequestServices.getLeaveRequestsByEmployee(employeeId);
    } catch (e) {
      _error = e.toString();
      _requests = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> createRequest({
    required int adminId,
    required int employeeId,
    required DateTime date,
    required String reason,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _leaveRequestServices.createLeaveRequest(
        adminId: adminId,
        employeeId: employeeId,
        date: date,
        reason: reason,
      );
      await fetchRequests(employeeId);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteRequest(int leaveId, int employeeId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _leaveRequestServices.deleteLeaveRequest(leaveId);
      await fetchRequests(employeeId);
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
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
  // Helper to notify listeners for legacy StateNotifier
  void notifyListeners() {
    state = {...state};
  }
}

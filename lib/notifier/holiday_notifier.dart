import 'package:flutter_riverpod/legacy.dart';
import '../models/holiday.dart';
import '../models/holiday_request.dart';
import '../services/leave_request_services.dart';

class HolidayNotifier extends StateNotifier<Map<DateTime, Holiday>> {
  final LeaveRequestServices _leaveRequestServices = LeaveRequestServices();
  List<HolidayRequest> _requests = [];
  bool _loading = false;
  String? _error;

  List<HolidayRequest> get requests => _requests;
  bool get loading => _loading;
  String? get error => _error;

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

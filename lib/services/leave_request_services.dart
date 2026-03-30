import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/holiday_request.dart';
import 'api_url.dart';

class LeaveRequestServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<void> createLeaveRequest({
    required int adminId,
    required int employeeId,
    required DateTime date,
    required String reason,
  }) async {
    final response = await _dio.post(
      ApiUrl.createLeaveRequest,
      data: {
        'admin_id': adminId,
        'employee_id': employeeId,
        'date': date.toIso8601String(),
        'reason': reason,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create leave request');
    }
  }

  Future<List<HolidayRequest>> getLeaveRequestsByEmployee(
    int employeeId,
  ) async {
    final response = await _dio.get(
      '${ApiUrl.getLeaveRequestsByEmployee}$employeeId',
    );
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as List;
      return data.map((json) => HolidayRequest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch leave requests');
    }
  }

  Future<void> deleteLeaveRequest(int leaveId) async {
    final response = await _dio.delete('${ApiUrl.deleteLeaveRequest}$leaveId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete leave request');
    }
  }
}

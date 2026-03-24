import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/attendance.dart';
import 'api_url.dart';

class AttendanceServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<List<Attendance>> getAttendanceByEmployee(int employeeId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAttendanceByEmployee}$employeeId');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        return data.map((json) => Attendance.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }

  Future<List<Attendance>> getAttendanceByAdminAndEmployee(int adminId, int employeeId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAttendanceByAdminAndEmployee}$adminId/employee/$employeeId');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        return data.map((json) => Attendance.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }

  Future<void> checkIn({
    required int employeeId,
    required double latitude,
    required double longitude,
    required File photo,
  }) async {
    final formData = FormData.fromMap({
      'latitude': latitude,
      'longitude': longitude,
      'photo': await MultipartFile.fromFile(photo.path, filename: photo.path.split('/').last),
    });
    try {
      final response = await _dio.post('${ApiUrl.attendanceCheckIn}$employeeId', data: formData);
      if (response.statusCode != 200) {
        throw Exception('Check-in failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No attendance record found for check-in.');
      }
      rethrow;
    }
  }

  Future<void> checkOut({
    required int employeeId,
    required double latitude,
    required double longitude,
    required File photo,
  }) async {
    final formData = FormData.fromMap({
      'latitude': latitude,
      'longitude': longitude,
      'photo': await MultipartFile.fromFile(photo.path, filename: photo.path.split('/').last),
    });
    try {
      final response = await _dio.post('${ApiUrl.attendanceCheckOut}$employeeId', data: formData);
      if (response.statusCode != 200) {
        throw Exception('Check-out failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No attendance record found for check-out.');
      }
      rethrow;
    }
  }
}

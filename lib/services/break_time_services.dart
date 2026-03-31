import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/break_time.dart';
import 'api_url.dart';

class BreakTimeServices {
  final Dio _dio;

  BreakTimeServices() : _dio = Dio() {
    _dio.options.baseUrl = ApiUrl.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<BreakTime> checkInBreak({
    required int employeeId,
    required File photo,
  }) async {
    final String url = '${ApiUrl.breakCheckIn}$employeeId';

    FormData formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split('/').last,
      ),
    });

    try {
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // The backend returns a success message and basic info. Wait, the backend returns:
        // {"message": "Break check-in successful", "break_id": ..., "break_in_time": ...}
        // It's not a full BreakTime object. We will just return an empty BreakTime or what we can.
        // Actually, returning a parsed instance using what's available is fine, or we just rely on fetch.
        return BreakTime(
          breakId: response.data['break_id'],
          breakInTime: response.data['break_in_time'] != null
              ? DateTime.parse(response.data['break_in_time']).toLocal()
              : null,
        );
      } else {
        throw Exception('Failed to check in for break');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['detail'] ?? 'Failed to complete break check-in',
        );
      }
      throw Exception(e.message);
    }
  }

  Future<BreakTime> checkOutBreak({
    required int employeeId,
    required File photo,
  }) async {
    final String url = '${ApiUrl.breakCheckOut}$employeeId';

    FormData formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split('/').last,
      ),
    });

    try {
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BreakTime(
          breakId: response.data['break_id'],
          breakOutTime: response.data['break_out_time'] != null
              ? DateTime.parse(response.data['break_out_time']).toLocal()
              : null,
        );
      } else {
        throw Exception('Failed to check out from break');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(
          e.response?.data['detail'] ?? 'Failed to complete break check-out',
        );
      }
      throw Exception(e.message);
    }
  }

  Future<List<BreakTime>> getBreaksByEmployee(int employeeId) async {
    final String url = '${ApiUrl.getBreaksByEmployee}$employeeId';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => BreakTime.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch breaks');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['detail'] ?? 'Failed to fetch breaks');
      }
      throw Exception(e.message);
    }
  }
}

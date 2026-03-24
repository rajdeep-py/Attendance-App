import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/holiday.dart';
import 'api_url.dart';

class HolidayServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<List<Holiday>> getHolidaysByAdmin(int adminId) async {
    final response = await _dio.get('${ApiUrl.getHolidaysByAdmin}$adminId');
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as List;
      return data.map((json) => Holiday.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch holidays');
    }
  }

  Future<Holiday> getHolidayByAdminAndId(int holidayId, int adminId) async {
    final response = await _dio.get('${ApiUrl.getHolidayByAdminAndId}$holidayId/admin/$adminId');
    if (response.statusCode == 200 && response.data != null) {
      return Holiday.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch holiday');
    }
  }
}

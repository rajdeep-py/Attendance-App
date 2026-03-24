import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/salary_slip.dart';
import 'api_url.dart';

class SalarySlipServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<List<SalarySlip>> getSalarySlipsByEmployee(int employeeId) async {
    final response = await _dio.get('${ApiUrl.getSalarySlipsByEmployee}$employeeId');
    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as List;
      return data.map((json) => SalarySlip.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch salary slips');
    }
  }
}

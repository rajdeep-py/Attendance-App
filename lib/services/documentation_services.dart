import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/documentation.dart';
import 'api_url.dart';

class DocumentationServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<List<Documentation>> getAllDocumentation() async {
    try {
      final response = await _dio.get(ApiUrl.getDocumentation);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as List;
        return data
            .map(
              (json) =>
                  Documentation.fromJson((json as Map).cast<String, dynamic>()),
            )
            .toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }
}

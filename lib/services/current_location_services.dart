

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';


class CurrentLocationService {
	final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl))
		..interceptors.add(PrettyDioLogger(
			requestHeader: true,
			requestBody: true,
			responseHeader: true,
			responseBody: true,
			error: true,
			compact: true,
			maxWidth: 90,
		));

	Future<void> postCurrentLocation({
		required int employeeId,
		required double latitude,
		required double longitude,
		String? timestamp,
	}) async {
		final url = '${ApiUrl.postCurrentLocation}$employeeId';
		final effectiveTimestamp =
			timestamp ?? DateTime.now().toUtc().toIso8601String();
		final data = {
			'latitude': latitude,
			'longitude': longitude,
			'timestamp': effectiveTimestamp,
		};
		await _dio.post(url, data: data);
	}
}

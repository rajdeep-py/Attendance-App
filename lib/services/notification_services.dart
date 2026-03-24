
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/notification.dart';
import 'api_url.dart';

class NotificationServices {
	final Dio _dio = Dio(
		BaseOptions(
			baseUrl: ApiUrl.baseUrl,
			connectTimeout: const Duration(seconds: 10),
			receiveTimeout: const Duration(seconds: 10),
		),
	)..interceptors.add(PrettyDioLogger());

	Future<List<AppNotification>> getNotificationsForEmployee(int employeeId) async {
		final response = await _dio.get('${ApiUrl.getNotificationsForEmployee}$employeeId');
		if (response.statusCode == 200 && response.data != null) {
			final data = response.data as List;
			return data.map((json) => AppNotification.fromJson(json)).toList();
		} else {
			throw Exception('Failed to fetch notifications');
		}
	}
}

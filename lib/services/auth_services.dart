import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/user.dart';
import 'api_url.dart';

class AuthServices {
	final Dio _dio = Dio(
		BaseOptions(
			baseUrl: ApiUrl.baseUrl,
			connectTimeout: const Duration(seconds: 10),
			receiveTimeout: const Duration(seconds: 10),
		),
	)..interceptors.add(PrettyDioLogger());

	Future<User> loginEmployee({required String phoneNo, required String password}) async {
		final response = await _dio.post(
			ApiUrl.loginEmployee,
			data: {
				'phone_no': phoneNo,
				'password': password,
			},
		);
		if (response.statusCode == 200 && response.data != null) {
			// The backend returns employee_id, admin_id, full_name, etc.
			return User.fromJson(response.data);
		} else {
			throw Exception('Login failed');
		}
	}

	Future<User> getEmployeeById(int employeeId) async {
		final response = await _dio.get('${ApiUrl.getEmployeeById}$employeeId');
		if (response.statusCode == 200 && response.data != null) {
			return User.fromJson(response.data);
		} else {
			throw Exception('Failed to fetch profile');
		}
	}

	Future<User> updateEmployeeProfile({
		required int employeeId,
		String? fullName,
		String? phoneNo,
		String? email,
		String? address,
		String? designation,
		String? password,
		String? bankAccountNo,
		String? bankName,
		String? branchName,
		String? ifscCode,
		String? profilePhotoPath,
	}) async {
		final formData = FormData.fromMap({
			'full_name': ?fullName,
			'phone_no': ?phoneNo,
			'email': ?email,
			'address': ?address,
			'designation': ?designation,
			'password': ?password,
			'bank_account_no': ?bankAccountNo,
			'bank_name': ?bankName,
			'branch_name': ?branchName,
			'ifsc_code': ?ifscCode,
			if (profilePhotoPath != null)
				'profile_photo': await MultipartFile.fromFile(profilePhotoPath, filename: profilePhotoPath.split('/').last),
		});
		final response = await _dio.put(
			'${ApiUrl.updateEmployeeById}$employeeId',
			data: formData,
		);
		if (response.statusCode == 200 && response.data != null) {
			return User.fromJson(response.data);
		} else {
			throw Exception('Failed to update profile');
		}
	}
}

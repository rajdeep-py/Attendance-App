import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthNotifier extends StateNotifier<User?> {
	final AuthServices _authServices = AuthServices();

	AuthNotifier() : super(null);

	Future<void> login(String phoneNo, String password) async {
		try {
			final user = await _authServices.loginEmployee(phoneNo: phoneNo, password: password);
			state = user;
		} catch (e) {
			state = null;
			rethrow;
		}
	}

	void logout() {
		state = null;
	}
}

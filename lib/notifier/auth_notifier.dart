import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class AuthNotifier extends StateNotifier<User?> {
	AuthNotifier() : super(null);

	void login(String phone, String password) {
		// Simulate login
		state = User(
			id: '1',
			phone: phone,
			name: 'Demo User',
			password: password,
		);
	}

	void logout() {
		state = null;
	}
}

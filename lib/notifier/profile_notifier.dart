import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class ProfileNotifier extends StateNotifier<User> {
  ProfileNotifier()
      : super(User(
          id: '1',
          phone: '+91 9876543210',
          name: 'Rajdeep Dey',
          password: 'password123',
        ));

  void updateProfile({String? name, String? phone, String? password}) {
    state = state.copyWith(
      name: name,
      phone: phone,
      password: password,
    );
  }
}

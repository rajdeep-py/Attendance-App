import 'package:flutter_riverpod/legacy.dart';
import '../notifier/auth_notifier.dart';
import '../models/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>(
	(ref) => AuthNotifier(),
);

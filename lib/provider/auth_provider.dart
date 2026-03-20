import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/auth_notifier.dart';
import '../models/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>(
	(ref) => AuthNotifier(),
);

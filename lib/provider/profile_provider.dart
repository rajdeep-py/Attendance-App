
import 'package:flutter_riverpod/legacy.dart';
import '../notifier/profile_notifier.dart';
import '../models/user.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, User>(
  (ref) => ProfileNotifier(),
);

import 'package:flutter_riverpod/legacy.dart';
import '../notifier/about_us_notifier.dart';
import '../models/about_us.dart';

final aboutUsProvider = StateNotifierProvider<AboutUsNotifier, AboutUs>(
  (ref) => AboutUsNotifier(),
);

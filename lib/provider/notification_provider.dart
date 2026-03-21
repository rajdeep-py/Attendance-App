import 'package:flutter_riverpod/legacy.dart';
import '../notifier/notification_notifier.dart';
import '../models/notification.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<AppNotification>>(
  (ref) => NotificationNotifier(),
);

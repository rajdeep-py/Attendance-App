import 'package:flutter_riverpod/legacy.dart';
import '../models/notification.dart';
import '../services/notification_services.dart';

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  final NotificationServices _notificationServices = NotificationServices();

  NotificationNotifier() : super([]);

  Future<void> fetchNotificationsForEmployee(int employeeId) async {
    try {
      final notifications = await _notificationServices.getNotificationsForEmployee(employeeId);
      state = notifications;
    } catch (e) {
      // Optionally handle error
      state = [];
    }
  }

  void addNotification(AppNotification notification) {
    state = [...state, notification];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  void markAllAsRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true)
    ];
  }

  void removeNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

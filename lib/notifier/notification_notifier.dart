import 'package:flutter_riverpod/legacy.dart';
import '../models/notification.dart';
import '../services/notification_services.dart';

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  final NotificationServices _notificationServices = NotificationServices();

  NotificationNotifier() : super([]);

  Future<void> fetchNotificationsForEmployee(int employeeId) async {
    try {
      final fetched = await _notificationServices.getNotificationsForEmployee(
        employeeId,
      );

      final byId = <String, AppNotification>{for (final n in state) n.id: n};

      for (final n in fetched) {
        final existing = byId[n.id];
        byId[n.id] = existing == null ? n : n.copyWith(isRead: existing.isRead);
      }

      final merged = byId.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      state = merged;
    } catch (_) {
      // Keep existing state (includes push notifications) on error.
    }
  }

  void addNotification(AppNotification notification) {
    if (state.any((n) => n.id == notification.id)) return;
    state = [notification, ...state];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void removeNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

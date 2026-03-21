import 'package:flutter_riverpod/legacy.dart';

import '../models/notification.dart';

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier()
      : super([
          AppNotification(
            id: '1',
            title: 'Welcome to MMS Attendance!',
            message: 'Thank you for joining. Start recording your attendance today.',
            date: DateTime.now().subtract(const Duration(hours: 1)),
            isRead: false,
          ),
          AppNotification(
            id: '2',
            title: 'Leave Approved',
            message: 'Your leave request for 22 Mar 2026 has been approved.',
            date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
            isRead: true,
          ),
          AppNotification(
            id: '3',
            title: 'New Holiday Added',
            message: 'Holi has been added to the holiday calendar on 25 Mar 2026.',
            date: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
            isRead: false,
          ),
        ]);

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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/app_bar.dart';
import '../../cards/notification/notification_card.dart';
import '../../provider/notification_provider.dart';
import '../../theme/app_theme.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    return Scaffold(
      backgroundColor: kWhite,
      appBar: const PremiumAppBar(
        title: 'Notifications',
        subtitle: 'All your app alerts',
        logoAssetPath: '',
        showBackIcon: true,
        actions: [],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications yet',
                style: kDescriptionTextStyle.copyWith(color: kBrown, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    ref.read(notificationProvider.notifier).markAsRead(notification.id);
                  },
                );
              },
            ),
    );
  }
}

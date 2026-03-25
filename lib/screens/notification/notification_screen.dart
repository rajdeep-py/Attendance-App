import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_bar.dart';
import '../../cards/notification/notification_card.dart';
import '../../provider/notification_provider.dart';
import '../../provider/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/loader.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {  
  bool _fetched = false;
  final bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      final user = ref.read(profileProvider);
      if (user != null && user.employeeId != null) {
        ref.read(notificationProvider.notifier).fetchNotificationsForEmployee(user.employeeId!);
        _fetched = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        context.go('/dashboard');
      },
      child: Stack(
        children: [
          Scaffold(
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
          ),
          if (_isLoading) const AppLoader(subText: 'Loading notifications...'),
        ],
      ),
    );
  }
}

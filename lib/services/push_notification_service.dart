import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import '../models/notification.dart';
import '../provider/notification_provider.dart';

const String _pushChannelId = 'attendx24_push_notifications';
const String _pushChannelName = 'Attendance notifications';
const String _pushChannelDescription = 'Push notifications from AttendX24.';

const String _pushPrefsKey = 'push_notifications_cache_v1';
const int _maxStoredPushNotifications = 50;

String? _stringFromData(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

String _messageTitle(RemoteMessage message) {
  return message.notification?.title ??
      _stringFromData(message.data, 'title') ??
      _stringFromData(message.data, 'notification_title') ??
      'AttendX24';
}

String _messageBody(RemoteMessage message) {
  return message.notification?.body ??
      _stringFromData(message.data, 'body') ??
      _stringFromData(message.data, 'message') ??
      _stringFromData(message.data, 'subtitle') ??
      '';
}

AppNotification _toAppNotification(RemoteMessage message) {
  return AppNotification(
    id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
    title: _messageTitle(message),
    message: _messageBody(message),
    date: DateTime.now(),
    isRead: false,
  );
}

Map<String, dynamic> _notificationToMap(AppNotification n) {
  return {
    'id': n.id,
    'title': n.title,
    'message': n.message,
    'date': n.date.toIso8601String(),
    'isRead': n.isRead,
  };
}

AppNotification? _notificationFromMap(Map<String, dynamic> map) {
  final id = map['id']?.toString() ?? '';
  if (id.isEmpty) return null;
  return AppNotification(
    id: id,
    title: map['title']?.toString() ?? '',
    message: map['message']?.toString() ?? '',
    date:
        DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
    isRead: map['isRead'] == true,
  );
}

Future<List<AppNotification>> _loadStoredNotifications() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pushPrefsKey);
    if (raw == null || raw.isEmpty) return <AppNotification>[];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return <AppNotification>[];

    return decoded
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .map(_notificationFromMap)
        .whereType<AppNotification>()
        .toList();
  } catch (_) {
    return <AppNotification>[];
  }
}

Future<void> _storeNotification(AppNotification n) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final existing = await _loadStoredNotifications();

    final byId = <String, AppNotification>{
      for (final item in existing) item.id: item,
    };

    // Keep read status if the item already exists.
    final prev = byId[n.id];
    byId[n.id] = prev == null ? n : n.copyWith(isRead: prev.isRead);

    final list = byId.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final trimmed = list.length > _maxStoredPushNotifications
        ? list.sublist(0, _maxStoredPushNotifications)
        : list;

    await prefs.setString(
      _pushPrefsKey,
      jsonEncode(trimmed.map(_notificationToMap).toList()),
    );
  } catch (_) {
    // Best-effort.
  }
}

Future<FlutterLocalNotificationsPlugin> _initLocalNotifications() async {
  final plugin = FlutterLocalNotificationsPlugin();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(
    android: androidInit,
    iOS: DarwinInitializationSettings(),
    macOS: DarwinInitializationSettings(),
  );

  await plugin.initialize(settings: initSettings);

  const channel = AndroidNotificationChannel(
    _pushChannelId,
    _pushChannelName,
    description: _pushChannelDescription,
    importance: Importance.high,
  );

  await plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  if (defaultTargetPlatform == TargetPlatform.android) {
    // Android 13+: runtime notification permission.
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  return plugin;
}

Future<void> _showLocalNotification(
  FlutterLocalNotificationsPlugin plugin,
  RemoteMessage message,
) async {
  final title = _messageTitle(message);
  final body = _messageBody(message);
  if (title.isEmpty && body.isEmpty) return;

  final androidDetails = AndroidNotificationDetails(
    _pushChannelId,
    _pushChannelName,
    channelDescription: _pushChannelDescription,
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const iOSDetails = DarwinNotificationDetails();

  await plugin.show(
    // Stable-ish per message; keep within int range.
    id: DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
    title: title,
    body: body,
    notificationDetails: NotificationDetails(android: androidDetails, iOS: iOSDetails),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Ignore if already initialized.
  }

  final appNotification = _toAppNotification(message);
  await _storeNotification(appNotification);

  // Only needed for data-only messages; notification messages are shown by the OS.
  if (message.notification == null) {
    try {
      final local = await _initLocalNotifications();
      await _showLocalNotification(local, message);
    } catch (_) {
      // Best-effort.
    }
  }
}

class PushNotificationService {
  PushNotificationService._();

  static FlutterLocalNotificationsPlugin? _localNotifications;

  static Future<void> initialize(ProviderContainer container) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Load any stored notifications (e.g. received while app was backgrounded).
    final stored = await _loadStoredNotifications();
    for (final n in stored) {
      container.read(notificationProvider.notifier).addNotification(n);
    }

    if (!kIsWeb) {
      _localNotifications ??= await _initLocalNotifications();
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      debugPrint('FCM token: $token');
    }

    FirebaseMessaging.onMessage.listen((message) async {
      final n = _toAppNotification(message);
      container.read(notificationProvider.notifier).addNotification(n);
      await _storeNotification(n);

      // On Android, notification messages won't show while foreground.
      if (_localNotifications != null) {
        await _showLocalNotification(_localNotifications!, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final n = _toAppNotification(message);
      container.read(notificationProvider.notifier).addNotification(n);
      await _storeNotification(n);
    });

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      final n = _toAppNotification(initial);
      container.read(notificationProvider.notifier).addNotification(n);
      await _storeNotification(n);
    }
  }
}

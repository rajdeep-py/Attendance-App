import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_url.dart';

class BackgroundLocationService {
  static const String prefsEnabledKey = 'bg_location_enabled';
  static const String prefsEmployeeIdKey = 'bg_location_employee_id';
  static const String prefsAuthTokenKey = 'bg_location_auth_token';
  static const String prefsIntervalSecondsKey = 'bg_location_interval_seconds';

  static const String invokeStartTracking = 'startTracking';
  static const String invokeStopTracking = 'stopTracking';

  static const String notificationChannelId = 'attendx24_location_tracking';
  static const int notificationId = 24001;

  static const int defaultIntervalSeconds = 15;

  static Future<void> initialize() async {
    final FlutterLocalNotificationsPlugin localNotifications =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'Attendance location tracking',
      description: 'Shows that attendance tracking is active.',
      importance: Importance.low,
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundServiceOnStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'AttendX24',
        initialNotificationContent: 'Location tracking ready',
        foregroundServiceNotificationId: notificationId,
        foregroundServiceTypes: const [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: backgroundServiceOnStart,
        onBackground: backgroundServiceOnIosBackground,
      ),
    );
  }

  static Future<void> startTracking({
    required int employeeId,
    String? authToken,
    int intervalSeconds = defaultIntervalSeconds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsEnabledKey, true);
    await prefs.setInt(prefsEmployeeIdKey, employeeId);
    if (authToken != null && authToken.isNotEmpty) {
      await prefs.setString(prefsAuthTokenKey, authToken);
    }
    await prefs.setInt(prefsIntervalSecondsKey, intervalSeconds);

    final service = FlutterBackgroundService();
    await service.startService();
    service.invoke(invokeStartTracking, {
      'employeeId': employeeId,
      'authToken': authToken,
      'intervalSeconds': intervalSeconds,
    });
  }

  static Future<void> stopTracking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsEnabledKey, false);

    final service = FlutterBackgroundService();
    if (await service.isRunning()) {
      service.invoke(invokeStopTracking);
    }
  }

  static Future<void> ensureRunningIfEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(prefsEnabledKey) ?? false;
    if (!enabled) return;

    final service = FlutterBackgroundService();
    await service.startService();
    service.invoke(invokeStartTracking);
  }
}

Timer? _locationTimer;
bool _isPosting = false;

@pragma('vm:entry-point')
Future<bool> backgroundServiceOnIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void backgroundServiceOnStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> setNotification(String content) async {
    if (service is AndroidServiceInstance) {
      await service.setForegroundNotificationInfo(
        title: 'AttendX24 tracking',
        content: content,
      );
    }
  }

  Future<void> stopLoop() async {
    _locationTimer?.cancel();
    _locationTimer = null;
    await prefs.setBool(BackgroundLocationService.prefsEnabledKey, false);
    service.stopSelf();
  }

  Future<void> tick() async {
    final enabled =
        prefs.getBool(BackgroundLocationService.prefsEnabledKey) ?? false;
    if (!enabled) {
      await stopLoop();
      return;
    }

    if (_isPosting) return;

    final employeeId = prefs.getInt(BackgroundLocationService.prefsEmployeeIdKey);
    if (employeeId == null) {
      await setNotification('Missing employee id');
      return;
    }

    try {
      _isPosting = true;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final authToken = prefs.getString(BackgroundLocationService.prefsAuthTokenKey);
      final headers = <String, dynamic>{};
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final url = '${ApiUrl.postCurrentLocation}$employeeId';
      await dio.post(
        url,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
        options: Options(headers: headers.isEmpty ? null : headers),
      );

      await setNotification(
        'Last sent: ${DateTime.now().toLocal().toIso8601String().split('.').first}',
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Background location tick failed: $e');
        debugPrintStack(stackTrace: st);
      }
      await setNotification('Tracking error: ${e.runtimeType}');
    } finally {
      _isPosting = false;
    }
  }

  void startLoop() {
    _locationTimer?.cancel();
    final intervalSeconds = prefs.getInt(
          BackgroundLocationService.prefsIntervalSecondsKey,
        ) ??
        BackgroundLocationService.defaultIntervalSeconds;

    _locationTimer = Timer.periodic(
      Duration(seconds: intervalSeconds.clamp(10, 60)),
      (_) => tick(),
    );
    unawaited(tick());
  }

  service.on(BackgroundLocationService.invokeStopTracking).listen((_) async {
    await stopLoop();
  });

  service.on(BackgroundLocationService.invokeStartTracking).listen((event) async {
    if (event != null) {
      final employeeId = event['employeeId'];
      final authToken = event['authToken'];
      final intervalSeconds = event['intervalSeconds'];

      if (employeeId is int) {
        await prefs.setInt(BackgroundLocationService.prefsEmployeeIdKey, employeeId);
      }
      if (authToken is String && authToken.isNotEmpty) {
        await prefs.setString(BackgroundLocationService.prefsAuthTokenKey, authToken);
      }
      if (intervalSeconds is int) {
        await prefs.setInt(
          BackgroundLocationService.prefsIntervalSecondsKey,
          intervalSeconds,
        );
      }
      await prefs.setBool(BackgroundLocationService.prefsEnabledKey, true);
    }

    startLoop();
  });

  // If the service is started by the OS (boot, process restart), resume if needed.
  final enabled = prefs.getBool(BackgroundLocationService.prefsEnabledKey) ?? false;
  if (enabled) {
    startLoop();
  } else {
    // Avoid lingering if auto-started but not checked-in.
    service.stopSelf();
  }
}

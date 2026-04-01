import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundLocationPermissions {
  static Future<bool> ensureForTracking({
    bool openSettingsOnBackgroundDenied = true,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    final location = await Permission.location.request();
    if (!location.isGranted) return false;

    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        final requested = await Permission.notification.request();
        if (!requested.isGranted) return false;
      }

      final alwaysStatus = await Permission.locationAlways.status;
      if (!alwaysStatus.isGranted) {
        final requested = await Permission.locationAlways.request();
        if (!requested.isGranted) {
          if (openSettingsOnBackgroundDenied) {
            await openAppSettings();
          }
          return false;
        }
      }

      // Best-effort: strongly recommended for OEMs that aggressively kill apps.
      final ignoreBatteryOptimizations =
          await Permission.ignoreBatteryOptimizations.status;
      if (!ignoreBatteryOptimizations.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    }

    return true;
  }
}

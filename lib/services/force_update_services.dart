import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';

class ForceUpdateService {
  final Dio _dio = Dio()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

  /// Checks if there's a newer version of the APK available on the backend.
  /// Returns a Map with 'hasUpdate', 'apkUrl', and 'latestVersion'.
  Future<Map<String, dynamic>> checkForUpdate() async {
    try {
      final response = await _dio.get(
        '${ApiUrl.baseUrl}${ApiUrl.getLatestVersion}',
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final int? latestVersionRaw = data['version'] as int?;
        final String? apkUrlPath = data['apk_url'] as String?;

        if (latestVersionRaw == null || apkUrlPath == null) {
          return {'hasUpdate': false};
        }

        // Get current app version
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersionString = packageInfo.version; // e.g. "1.0.0"

        // Convert "1.0.1" to 101 for comparison
        final int currentVersion =
            int.tryParse(currentVersionString.replaceAll('.', '')) ?? 0;

        if (latestVersionRaw > currentVersion) {
          return {
            'hasUpdate': true,
            'apkUrl': '${ApiUrl.baseUrl}$apkUrlPath',
            'latestVersion': latestVersionRaw.toString(),
          };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking for update: $e');
      }
    }
    return {'hasUpdate': false};
  }

  /// Downloads the APK and triggers the install intent
  Future<void> downloadAndInstallUpdate(
    String apkUrl,
    Function(int, int) onReceiveProgress,
  ) async {
    try {
      // Prompt for storage and install permissions
      if (Platform.isAndroid) {
        // Request install packages permission (Android 8+)
        var status = await Permission.requestInstallPackages.request();
        if (!status.isGranted) {
          if (kDebugMode) {
            print("Install packages permission denied");
          }
          return;
        }
      }

      // Determine where to save the file
      Directory? tempDir;
      if (Platform.isAndroid) {
        tempDir = await getExternalStorageDirectory();
      } else {
        tempDir = await getApplicationDocumentsDirectory();
      }

      if (tempDir == null) return;

      final String savePath = '${tempDir.path}/update_app.apk';

      // Ensure old APKs are removed
      final file = File(savePath);
      if (await file.exists()) {
        await file.delete();
      }

      // Download the APK
      await _dio.download(
        apkUrl,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      // Trigger the APK installation
      if (Platform.isAndroid) {
        final result = await OpenFilex.open(savePath);
        if (result.type != ResultType.done) {
          if (kDebugMode) {
            print('Failed to open APK: ${result.message}');
          }
        }
      } else {
        // Handle iOS specific redirection if we eventually support it
        // e.g. url_launcher to the App Store
        if (kDebugMode) {
          print('iOS direct APK install not supported');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading or installing update: $e');
      }
      rethrow;
    }
  }
}

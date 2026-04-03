import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'services/push_notification_service.dart';
import 'widgets/background_location_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await PushNotificationService.initialize(container);

  await BackgroundLocationService.initialize();
  await BackgroundLocationService.flushPendingLocations();
  await BackgroundLocationService.ensureRunningIfEnabled();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AttendX24',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}

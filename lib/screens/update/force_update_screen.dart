import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/force_update_services.dart';

class ForceUpdateScreen extends StatefulWidget {
  final String apkUrl;
  final String latestVersion;

  const ForceUpdateScreen({
    super.key,
    required this.apkUrl,
    required this.latestVersion,
  });

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  bool _isDownloading = false;
  double _progress = 0.0;
  final ForceUpdateService _updateService = ForceUpdateService();

  Future<void> _startUpdate() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      await _updateService.downloadAndInstallUpdate(widget.apkUrl, (
        received,
        total,
      ) {
        if (total != -1) {
          setState(() {
            _progress = received / total;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download update: $e'),
            backgroundColor: kerror,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prevent back navigation by using PopScope
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kWhiteGrey,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: 200),
                const SizedBox(height: 40),
                Text(
                  'Update Required',
                  style: kHeaderTextStyle.copyWith(color: kBlack, fontSize: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'A new version of the app is available and requires an update to continue using the application.',
                  textAlign: TextAlign.center,
                  style: kBodyTextStyle.copyWith(
                    color: kBrown.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                if (_isDownloading)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: kGrey.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(kGreen),
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Downloading... ${(_progress * 100).toStringAsFixed(1)}%',
                        style: kBodyTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: _startUpdate,
                    style: kPremiumButtonStyle.copyWith(
                      minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 56),
                      ),
                    ),
                    child: const Text(
                      'Update Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

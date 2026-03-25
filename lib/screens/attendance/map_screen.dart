import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../services/attendance_services.dart';
import '../../provider/profile_provider.dart';
import '../../widgets/app_bar.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  List<Map<String, dynamic>>? _locationMatrices;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLocationMatrices();
  }

  Future<void> _fetchLocationMatrices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = ref.read(profileProvider);
      final adminId = user?.adminId;
      if (adminId == null) {
        setState(() {
          _error = 'Admin ID not found for current user.';
          _isLoading = false;
        });
        return;
      }
      final matrices = await AttendanceServices().getLocationMatrixByAdmin(adminId);
      setState(() {
        _locationMatrices = matrices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch location matrices: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        
          context.go('/dashboard');
        },
      child:
    Scaffold(
      appBar: PremiumAppBar(
              title: 'My Stores',
              subtitle: 'View your store locations on the map',
              logoAssetPath: '',
              actions: [
              ],
              showBackIcon: true,
            ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildMap(),
    ),
    );
  }

  Widget _buildMap() {
    // Default center: India
    final defaultCenter = LatLng(22.9734, 78.6569);
    final markers = <Marker>[];
    final circles = <CircleMarker>[];
    if (_locationMatrices != null) {
      for (final matrix in _locationMatrices!) {
        if (matrix['latitude'] != null && matrix['longitude'] != null) {
          final latLng = LatLng(
            (matrix['latitude'] as num).toDouble(),
            (matrix['longitude'] as num).toDouble(),
          );
          markers.add(
            Marker(
              width: 40,
              height: 40,
              point: latLng,
              child: const Icon(Icons.location_on, color: Colors.red, size: 36),
            ),
          );
          circles.add(
            CircleMarker(
              point: latLng,
              color: Colors.green.withAlpha(20),
              borderStrokeWidth: 2,
              borderColor: Colors.green,
              useRadiusInMeter: true,
              radius: 20, // 20 meters
            ),
          );
        }
      }
    }
    // India's bounding box: Southwest (6.4627, 68.1097), Northeast (35.5133, 97.3954)
    final indiaBounds = LatLngBounds(
      LatLng(6.4627, 68.1097), // Southwest
      LatLng(35.5133, 97.3954), // Northeast
    );
    return FlutterMap(
      options: MapOptions(
        initialCenter: markers.isNotEmpty ? markers.first.point : defaultCenter,
        initialZoom: 18.5,
        maxBounds: indiaBounds,
        // Optionally, restrict panning strictly inside bounds:
        // keepAlive: true,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.attendance_app',
        ),
        MarkerLayer(markers: markers),
        if (circles.isNotEmpty)
          CircleLayer(circles: circles),
      ],
    );
  }
}

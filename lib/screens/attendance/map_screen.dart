import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
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
  LatLng? _pointerLatLng;

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
    return Scaffold(
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
    );
  }

  Widget _buildMap() {
    // Default center: India
    final defaultCenter = LatLng(22.9734, 78.6569);
    final markers = <Marker>[];
    if (_locationMatrices != null) {
      for (final matrix in _locationMatrices!) {
        if (matrix['latitude'] != null && matrix['longitude'] != null) {
          markers.add(
            Marker(
              width: 40,
              height: 40,
              point: LatLng(
                (matrix['latitude'] as num).toDouble(),
                (matrix['longitude'] as num).toDouble(),
              ),
              child: const Icon(Icons.location_on, color: Colors.red, size: 36),
            ),
          );
        }
      }
    }
    if (_pointerLatLng != null) {
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: _pointerLatLng!,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 36),
        ),
      );
    }
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: markers.isNotEmpty ? markers.first.point : defaultCenter,
            initialZoom: 5.5,
            onTap: (tapPosition, latlng) {
              setState(() {
                _pointerLatLng = latlng;
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.attendance_app',
            ),
            MarkerLayer(markers: markers),
            if (_pointerLatLng != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _pointerLatLng!,
                    color: Colors.green.withAlpha(20),
                    borderStrokeWidth: 2,
                    borderColor: Colors.green,
                    useRadiusInMeter: true,
                    radius: 20, // 20 meters
                  ),
                ],
              ),
          ],
        ),
        if (_pointerLatLng != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Text(
                'Selected: Lat: ${_pointerLatLng!.latitude.toStringAsFixed(6)}, Lng: ${_pointerLatLng!.longitude.toStringAsFixed(6)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../components/my_button.dart';

class MapLocation {
  final double lat;
  final double lon;
  final String placeName; // we’ll store "lat, lon" here
  MapLocation({required this.lat, required this.lon, required this.placeName});
}

class MapPage extends StatefulWidget {
  final double initialLat;
  final double initialLon;
  final String placeName;

  const MapPage({
    super.key,
    required this.initialLat,
    required this.initialLon,
    required this.placeName,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  late LatLng _currentLocation;
  String _currentPlace = '';

  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(widget.initialLat, widget.initialLon);
    _currentPlace =
    '${_currentLocation.latitude.toStringAsFixed(4)}, ${_currentLocation.longitude.toStringAsFixed(4)}';
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      if (kIsWeb) {
        // Browser will prompt on first call; not fatal if it fails
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (!mounted) return;
        setState(() {
          _currentLocation = LatLng(pos.latitude, pos.longitude);
          _currentPlace =
          '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
        });
        return;
      }

      // Mobile (Android/iOS): use Geolocator permission APIs (not permission_handler)
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (!mounted) return;
        setState(() {
          _currentLocation = LatLng(pos.latitude, pos.longitude);
          _currentPlace =
          '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
        });
      } else {
        // Keep defaults; user can still tap the map
        if (!mounted) return;
        setState(() {
          _currentPlace =
          '${_currentLocation.latitude.toStringAsFixed(4)}, ${_currentLocation.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _currentPlace =
        '${_currentLocation.latitude.toStringAsFixed(4)}, ${_currentLocation.longitude.toStringAsFixed(4)}';
      });
    }
  }

  void _onTap(LatLng p) {
    setState(() {
      _currentLocation = p;
      _currentPlace =
      '${p.latitude.toStringAsFixed(4)}, ${p.longitude.toStringAsFixed(4)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location'), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mapHeight = constraints.maxHeight * 0.75;
            return Column(
              children: [
                SizedBox(
                  height: mapHeight,
                  width: double.infinity,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation,
                      initialZoom: 13,
                      onTap: (tapPos, point) => _onTap(point),
                    ),
                    children: [
                      // Use any tile source you like. Example with MapTiler:
                      TileLayer(
                        urlTemplate:
                        'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}@2x.png?key=pQvjv1JPdMUaSm7SKI7N&language=en',
                        userAgentPackageName: 'com.example.geofence',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40,
                            height: 40,
                            point: _currentLocation,
                            child: const Icon(
                              Icons.location_pin,
                              size: 36,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom controls
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '📍 $_currentPlace',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: MyButton(
                            text: "Confirm Location",
                            onTap: () {
                              final mapLocation = MapLocation(
                                lat: _currentLocation.latitude,
                                lon: _currentLocation.longitude,
                                placeName:
                                _currentPlace, // stores "lat, lon" text
                              );
                              Navigator.pop(context, mapLocation);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

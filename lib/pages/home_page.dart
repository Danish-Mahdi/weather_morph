import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence/components/my_button.dart';
import 'package:geofence/components/my_drawer.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';
import 'map_page.dart'; // <-- We use MapLocation from here

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _formKey = GlobalKey<FormState>();

  // Store the selected map location (returned from MapPage)
  MapLocation? selectedLocation;

  String place = 'Karachi, PK';
  double lat = 24.8607;
  double lon = 67.0011;
  DateTime date = DateTime.now().add(const Duration(days: 1));
  bool isButtonEnabled = false;

  void _updateButtonState() {
    final validDate = date.isAfter(DateTime.now().subtract(const Duration(days: 1)));
    setState(() {
      isButtonEnabled = validDate && selectedLocation != null;
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user can't dismiss
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // close the loading dialog
    }
  }


  // Open map in a tall bottom sheet and receive MapLocation back
  void _openMap() async {
    final result = await showModalBottomSheet<MapLocation>(
      context: context,
      isScrollControlled: true, // allow near full-height
      useSafeArea: true,        // respect notches and system UI
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final h = MediaQuery.of(ctx).size.height;
        return Container(
          height: h * 0.92, // ~full screen minus app bar
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: MapPage(initialLat: lat, initialLon: lon, placeName: place),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedLocation = result; // keep the MapLocation object
        lat = result.lat;          // keep your existing fields in sync (optional)
        lon = result.lon;
        place = result.placeName;
      });
      _updateButtonState();
    }
  }

  // Call ApiService via provider; then navigate to results
  // Call ApiService via provider; then print API response

// ...

  Future<void> _fetchData() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (selectedLocation == null) return;

    final api = ref.read(apiServiceProvider);

    _showLoadingDialog(); // if you added the spinner helper
    try {
      final response = await api.fetchClimatology(
        lat: selectedLocation!.lat,
        lon: selectedLocation!.lon,
        date: date,
      );

      print('✅ API Response: $response');

      if (!mounted) return;
      context.pushNamed('result_page', extra: response); // <— pass data here
    } catch (e) {
      print('❌ API error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed: $e')),
        );
      }
    } finally {
      if (mounted) _hideLoadingDialog(); // if using the spinner
    }
  }





  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.10,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ListView(
              padding: const EdgeInsets.only(right: 16, bottom: 24),
              children: [
                const SectionHeader(
                  title: 'Pick your parade details',
                  subtitle: 'Choose place and date. We’ll estimate the rain risk and readiness.',
                ),
                const SizedBox(height: 12),

                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: place,
                          decoration: const InputDecoration(
                            labelText: 'Place (city or area)',
                            hintText: 'e.g., Karachi, PK',
                            prefixIcon: Icon(Icons.place_outlined),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                          onSaved: (v) => place = v!.trim(),
                        ),

                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.date_range_outlined),
                          label: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Date: ${date.toIso8601String().split("T").first}'),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: cs.outlineVariant),
                            foregroundColor: cs.onSurface,
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              initialDate: date,
                            );
                            if (picked != null) {
                              setState(() => date = picked);
                              _updateButtonState(); // re-check enabled state
                            }
                          },
                        ),

                        const SizedBox(height: 12),
                        // Map button to open map panel
                        MyButton(text: "Select location on Map", onTap: _openMap),

                        const SizedBox(height: 18),

                        // Fetch Data button (enabled only when date valid + location selected)
                        MyButton(
                          text: "Fetch Data",
                          onTap: isButtonEnabled ? _fetchData : () {},
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed("about_page");
                    },
                    child: const Text('About & Data Sources'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}

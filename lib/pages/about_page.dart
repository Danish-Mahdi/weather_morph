import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('GPM IMERG', 'https://gpm.nasa.gov/data'),
      ('MERRA-2', 'https://gmao.gsfc.nasa.gov/reanalysis/MERRA-2/'),
      ('GEOS-FP', 'https://gmao.gsfc.nasa.gov/GEOS_systems/GEOS-FP/'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About'
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const ListTile(
            title: Text('Will it rain on my parade?'),
            subtitle: Text('Hackathon demo. NASA datasets + simple forecast blend.'),
          ),
          const Divider(),
          ...items.map((e) => ListTile(
            leading: const Icon(Icons.link),
            title: Text(e.$1),
            subtitle: Text(e.$2),
            onTap: () => launchUrl(Uri.parse(e.$2)),
          )),
        ],
      ),
    );
  }
}

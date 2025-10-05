import 'package:flutter/material.dart';
import '../models/models.dart';

class RiskCard extends StatelessWidget {
  final RiskResponse r;
  const RiskCard({super.key, required this.r});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final emoji = {'GO':'🎉','CAUTION':'⛅','PLAN B':'☔'}[r.readinessIndex] ?? '⛅';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [cs.primary.withOpacity(.10), cs.surface],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('$emoji  ${r.readinessIndex}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                _Badge(text: r.locationName),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _pill('Climo: ${(r.rainProbClimo * 100).toStringAsFixed(0)}%'),
                const SizedBox(width: 8),
                if (r.rainProbForecast != null)
                  _pill('Forecast: ${(r.rainProbForecast! * 100).toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 12,
              children: [
                _metric(context, 'P50 rain', '${r.p50Intensity.toStringAsFixed(1)} mm/hr', Icons.water_drop_outlined),
                _metric(context, 'P90 rain', '${r.p90Intensity.toStringAsFixed(1)} mm/hr', Icons.invert_colors),
                _metric(context, 'Cloudiness', '${(r.cloudiness*100).toStringAsFixed(0)}%', Icons.cloud_queue),
                _metric(context, 'Heat risk', r.heatRisk, Icons.thermostat),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.06),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _metric(BuildContext context, String title, String value, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width >= 600 ? 160 : 150,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(.75))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withOpacity(.35)),
      ),
      child: Text(text, style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
    );
  }
}

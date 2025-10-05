import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const ResultScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data?['status'];
    final summary = data?['summary'] as Map<String, dynamic>?;
    final List<dynamic> daily =
        (data?['daily_forecasts'] as List<dynamic>?) ?? const [];

    // Extract nested summary text and alerts safely
    final content = summary?['content'] as Map<String, dynamic>?;
    final summaryText = content?['summary'] ?? 'No summary available';
    final alerts = (content?['alerts'] as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: data == null
            ? const Center(child: Text('No data received'))
            : ListView(
          children: [
            Text(
              'Status: $status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // 🌤️ Summary Card
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny_outlined,
                            color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Weather Summary',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      summaryText.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    if (alerts.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        '⚠️ Alerts:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...alerts.map((alert) {
                        final date = alert['date'];
                        final conditions =
                            (alert['conditions'] as List?)?.join(', ') ??
                                '';
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('• $date → $conditions'),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🌦️ Daily Forecasts
            Text(
              'Daily Forecasts (${daily.length}):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...daily.map((e) {
              final m = e as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: Text('${m['date']} — ${m['title']}'),
                  subtitle: Text(
                    'value: ${m['value']} | status: ${m['status']} | probability: ${m['probability']}',
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

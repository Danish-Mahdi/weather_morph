import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class ThemePickerButton extends ConsumerWidget {
  const ThemePickerButton({super.key, required bool iconOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final controller = ref.read(themeModeProvider.notifier);

    return Material( // Ensure Material ancestor is present
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Wrap with SingleChildScrollView to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Theme:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Radio<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: mode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        controller.setMode(value);
                      }
                    },
                  ),
                  const Text('Light', style: TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Radio<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: mode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        controller.setMode(value);
                      }
                    },
                  ),
                  const Text('Dark', style: TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: mode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        controller.setMode(value);
                      }
                    },
                  ),
                  const Text('System', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

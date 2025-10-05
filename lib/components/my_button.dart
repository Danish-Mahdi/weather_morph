import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool busy;
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: busy ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,      // button fill
          foregroundColor: cs.inversePrimary,    // text and icon color
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: busy
            ? const SizedBox(
            width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(text),
      ),
    );
  }
}

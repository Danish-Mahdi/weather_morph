import 'package:flutter/material.dart';

class Sparkline extends StatelessWidget {
  const Sparkline({super.key, required this.values, this.min, this.max, this.strokeWidth = 2});
  final List<double> values;
  final double? min;
  final double? max;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(values, min: min, max: max, color: Theme.of(context).colorScheme.primary, strokeWidth: strokeWidth),
      size: Size.infinite,
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, {this.min, this.max, required this.color, required this.strokeWidth});
  final List<double> values;
  final double? min;
  final double? max;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final mn = min ?? values.reduce((a, b) => a < b ? a : b);
    final mx = max ?? values.reduce((a, b) => a > b ? a : b);
    final span = (mx - mn).abs() < 1e-6 ? 1.0 : (mx - mn);

    final stepX = size.width / (values.length - 1);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * stepX;
      final yNorm = (values[i] - mn) / span;
      final y = size.height - yNorm * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

import 'package:flutter/material.dart';
import "dart:math" as math;

class CircleArc extends CustomPainter {
  final double size;
  final double strokeWidth;
  final Color color;
  final double startDegree;
  final double endDegree;

  CircleArc({
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.startDegree,
    required this.endDegree,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: this.size / 2,
    );

    final startAngle = math.pi * startDegree / 180;
    final sweepAngle = math.pi * (endDegree - startDegree) / 180;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

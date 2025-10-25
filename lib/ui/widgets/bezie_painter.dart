import 'package:flutter/material.dart';
import 'dart:math';

// =========================================================================
// Класс для рисования CustomPainter
// =========================================================================

class HyperbolicCurvePainter extends CustomPainter {
  final Offset start; // Начальная точка
  final Offset end; // Конечная точка
  final Color color;
  final double strokeWidth;
  final double vScrollPosition;
  final double hScrollPosition;

  HyperbolicCurvePainter({
    required this.start,
    required this.end,
    this.color = Colors.blue,
    this.strokeWidth = 3.0,
    required this.vScrollPosition,
    required this.hScrollPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset _end = Offset(end.dx + hScrollPosition, end.dy + vScrollPosition);
    Offset _start = Offset(start.dx + hScrollPosition, start.dy + vScrollPosition);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dx = _end.dx - _start.dx;
    final dy = _end.dy - _start.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // Величина смещения контрольных точек (настраиваемый параметр)
    final offsetMagnitude = min(distance * 0.4, 70.0);

    // Нормаль (перпендикуляр) к отрезку (для создания изгиба)
    // Используем нормализованный вектор (-dy, dx) для перпендикуляра
    final normalX = -dy / distance;
    final normalY = dx / distance;

    // Она смещена на 1/4 пути от start.
    final quarterX = _start.dx + dx * 0.25;
    final quarterY = _start.dy + dy * 0.25;

    // Смещаем ее, чтобы создать первый изгиб (например, "вверх")
    final controlPoint1 = Offset(quarterX + normalX * offsetMagnitude, quarterY + normalY * offsetMagnitude);

    // Она смещена на 3/4 пути от start.
    final threeQuarterX = _start.dx + dx * 0.75;
    final threeQuarterY = _start.dy + dy * 0.75;

    // Смещаем ее в противоположном направлении, чтобы создать S-образный ("гиперболический") изгиб
    final controlPoint2 = Offset(
      threeQuarterX - normalX * offsetMagnitude, // Обратите внимание на минус (-)
      threeQuarterY - normalY * offsetMagnitude,
    );

    final path = Path()
      ..moveTo(_start.dx, _start.dy)
      // Рисуем кубическую кривую Безье
      // controlPoint1 и controlPoint2 управляют формой
      ..cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, _end.dx, _end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HyperbolicCurvePainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end || oldDelegate.color != color;
  }
}

class HyperbolicCurvePainterPath extends CustomPainter {
  final List<Offset> offsets;
  final Color color;
  final double strokeWidth;

  HyperbolicCurvePainterPath({required this.offsets, this.color = Colors.blue, this.strokeWidth = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < offsets.length; i++) {
      Offset start = offsets[i - 1];
      Offset end = offsets[i];

      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final distance = sqrt(dx * dx + dy * dy);

      // Величина смещения контрольных точек (настраиваемый параметр)
      final offsetMagnitude = min(distance * 0.4, 70.0);

      // Нормаль (перпендикуляр) к отрезку (для создания изгиба)
      // Используем нормализованный вектор (-dy, dx) для перпендикуляра
      final normalX = -dy / distance;
      final normalY = dx / distance;

      // Она смещена на 1/4 пути от start.
      final quarterX = start.dx + dx * 0.25;
      final quarterY = start.dy + dy * 0.25;

      // Смещаем ее, чтобы создать первый изгиб (например, "вверх")
      final controlPoint1 = Offset(quarterX + normalX * offsetMagnitude, quarterY + normalY * offsetMagnitude);

      // Она смещена на 3/4 пути от start.
      final threeQuarterX = start.dx + dx * 0.75;
      final threeQuarterY = start.dy + dy * 0.75;

      // Смещаем ее в противоположном направлении, чтобы создать S-образный ("гиперболический") изгиб
      final controlPoint2 = Offset(
        threeQuarterX - normalX * offsetMagnitude, // Обратите внимание на минус (-)
        threeQuarterY - normalY * offsetMagnitude,
      );

      final path = Path()
        ..moveTo(start.dx, start.dy)
        // Рисуем кубическую кривую Безье
        // controlPoint1 и controlPoint2 управляют формой
        ..cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HyperbolicCurvePainterPath oldDelegate) {
    return oldDelegate.offsets != offsets || oldDelegate.color != color;
  }
}

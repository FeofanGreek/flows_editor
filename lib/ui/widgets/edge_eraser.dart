import 'dart:math';

import 'package:flutter/material.dart';

import 'circle_button.dart';

class EdgeEraser extends StatefulWidget {
  const EdgeEraser({super.key, required this.onChanged, required this.end, required this.start});
  final Offset end;
  final Offset start;
  final Function() onChanged;

  @override
  State<EdgeEraser> createState() => EdgeEraserState();
}

class EdgeEraserState extends State<EdgeEraser> {
  late Offset center;
  @override
  void initState() {
    super.initState();
    center = getHyperbolicCurveCenter(widget.start, widget.end);
  }

  Offset getHyperbolicCurveCenter(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // Величина смещения контрольных точек (настраиваемый параметр)
    final offsetMagnitude = min(distance * 0.4, 70.0);

    // Нормаль (перпендикуляр) к отрезку (для создания изгиба)
    final normalX = -dy / distance;
    final normalY = dx / distance;

    // Первая контрольная точка смещена на 1/4 пути от start
    final quarterX = start.dx + dx * 0.25;
    final quarterY = start.dy + dy * 0.25;
    final controlPoint1 = Offset(quarterX + normalX * offsetMagnitude, quarterY + normalY * offsetMagnitude);

    // Вторая контрольная точка смещена на 3/4 пути от start
    final threeQuarterX = start.dx + dx * 0.75;
    final threeQuarterY = start.dy + dy * 0.75;
    final controlPoint2 = Offset(threeQuarterX - normalX * offsetMagnitude, threeQuarterY - normalY * offsetMagnitude);

    // Используем параметр t = 0.5 для кубической кривой Безье
    // Формула: B(t) = (1-t)³·P0 + 3(1-t)²·t·P1 + 3(1-t)·t²·P2 + t³·P3
    const t = 0.5;
    final mt = 1 - t;

    final centerX =
        mt * mt * mt * start.dx +
        3 * mt * mt * t * controlPoint1.dx +
        3 * mt * t * t * controlPoint2.dx +
        t * t * t * end.dx;

    final centerY =
        mt * mt * mt * start.dy +
        3 * mt * mt * t * controlPoint1.dy +
        3 * mt * t * t * controlPoint2.dy +
        t * t * t * end.dy;

    return Offset(centerX, centerY);
  }

  @override
  Widget build(BuildContext context) {
    center = getHyperbolicCurveCenter(widget.start, widget.end);
    return Positioned(
      top: center.dy - 10,
      left: center.dx - 10,
      child: CircleButton(onTap: () => widget.onChanged(), icon: Icons.clear, tooltip: 'Remove edge'),
    );
  }
}

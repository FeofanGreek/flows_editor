import 'package:flutter/material.dart';

/// CustomPainter для отрисовки линии пути
class PathPainterold extends CustomPainter {
  PathPainterold({
    required this.vScrollPosition,
    required this.hScrollPosition,
    required this.path,
    this.lineColor = Colors.blue,
    this.lineWidth = 4.0,
  });

  final List<Offset> path;
  final Color lineColor;
  final double lineWidth;
  final double vScrollPosition;
  final double hScrollPosition;

  @override
  void paint(Canvas canvas, Size size) {
    if (path.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      //..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round;

    if (path.length == 1) {
      canvas.drawCircle(path[0], lineWidth * 2, paint);
      return;
    }

    for (var i = 0; i < path.length - 1; i++) {
      Offset pointS = Offset(path[i].dx + hScrollPosition, path[i].dy + vScrollPosition);
      Offset pointE = Offset(path[i + 1].dx + hScrollPosition, path[i + 1].dy + vScrollPosition);
      canvas.drawLine(pointS, pointE, paint);
    }
  }

  @override
  bool shouldRepaint(PathPainterold oldDelegate) =>
      oldDelegate.path != path || oldDelegate.lineColor != lineColor || oldDelegate.lineWidth != lineWidth;
}

/// CustomPainter для отрисовки гладкой линии Катмулла-Рома
class PathPainter extends CustomPainter {
  PathPainter({
    required this.vScrollPosition,
    required this.hScrollPosition,
    required this.path,
    this.lineColor = Colors.blue,
    this.lineWidth = 4.0,
    this.tension = 0.5, // Параметр для настройки "натяжения" (гладкости) сплайна
  });

  final List<Offset> path;
  final Color lineColor;
  final double lineWidth;
  final double vScrollPosition;
  final double hScrollPosition;
  final double tension;

  // Вспомогательная функция для расчета пути с использованием сплайнов Катмулла-Рома
  Path _getCatmullRomPath(List<Offset> points) {
    final Path drawPath = Path();

    if (points.length < 2) return drawPath;

    // Сдвигаем начальную точку
    drawPath.moveTo(points[0].dx + hScrollPosition, points[0].dy + vScrollPosition);

    // Для сглаживания нам нужна "окрестность" из 4 точек для каждого сегмента: P0, P1, P2, P3.
    // Сегмент рисуется от P1 до P2.
    for (int i = 0; i < points.length - 1; i++) {
      // P1 и P2 - конечные точки текущего сегмента
      final Offset p1 = points[i];
      final Offset p2 = points[i + 1];

      // P0 - предыдущая точка (для первого сегмента берем P1)
      final Offset p0 = (i > 0) ? points[i - 1] : p1;

      // P3 - следующая точка (для последнего сегмента берем P2)
      final Offset p3 = (i < points.length - 2) ? points[i + 2] : p2;

      // Алгоритм Catmull-Rom преобразуется в кубическую кривую Безье (cubicTo)
      // через две контрольные точки (CP1 и CP2)

      // Контрольная точка 1 (Control Point 1)
      final double cp1x = p1.dx + (p2.dx - p0.dx) / 6.0 * tension;
      final double cp1y = p1.dy + (p2.dy - p0.dy) / 6.0 * tension;

      // Контрольная точка 2 (Control Point 2)
      final double cp2x = p2.dx - (p3.dx - p1.dx) / 6.0 * tension;
      final double cp2y = p2.dy - (p3.dy - p1.dy) / 6.0 * tension;

      // Применяем сдвиг скролла к контрольным и конечным точкам
      drawPath.cubicTo(
        cp1x + hScrollPosition,
        cp1y + vScrollPosition,
        cp2x + hScrollPosition,
        cp2y + vScrollPosition,
        p2.dx + hScrollPosition,
        p2.dy + vScrollPosition,
      );
    }
    return drawPath;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (path.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle
          .stroke // Изменено: для Path нам нужен только обводка
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round;

    // 1. Обработка случая с одной точкой
    if (path.length == 1) {
      canvas.drawCircle(
        Offset(path[0].dx + hScrollPosition, path[0].dy + vScrollPosition),
        lineWidth / 2, // Отрисовываем точку поменьше для линии
        paint,
      );
      return;
    }

    // 2. Генерация гладкого пути
    final smoothPath = _getCatmullRomPath(path);

    // 3. Отрисовка пути
    canvas.drawPath(smoothPath, paint);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) =>
      oldDelegate.path != path ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.lineWidth != lineWidth ||
      oldDelegate.vScrollPosition != vScrollPosition ||
      oldDelegate.hScrollPosition != hScrollPosition ||
      oldDelegate.tension != tension; // Добавлена проверка скроллов и натяжения
}

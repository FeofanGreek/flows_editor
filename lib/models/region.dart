import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:flutter/material.dart';

import 'block_node.dart';
import 'net_cell.dart';

///область которая заполнена ячейками
class Region {
  ///область которая заполнена ячейками
  Region({required this.height, required this.width}) {
    _init();
  }

  //размер рабочей области редактора flow
  final double width;
  final double height;

  int _rows = 0;
  int _columns = 0;

  //ячейки индикаторы расположения над ними блока нода
  List<List<NetCell>> cells = [];

  List<NetCell> get lineCells => cells.expand((list) => list).toList();

  ///определитель для предотвращения выхода блоков за пределы региона
  Rect get regionRegion => Rect.fromLTWH(0, 0, width, height);

  //Инициализируем контроллер и заполняем его ячейками индикаторами
  void _init() {
    // Получаем размер одной ячейки (10x10)
    final double cellWidth = NetCell.size.width;
    final double cellHeight = NetCell.size.height;
    // Вычисляем количество ячеек по ширине и высоте
    // Используем ceil для округления вверх, чтобы покрыть всю область
    _columns = (width / cellWidth).ceil();
    _rows = (height / cellHeight).ceil();
    cells = List.generate(
      _rows,
      (row) => List.generate(
        _columns,
        (col) => NetCell(cellCoords: (row, col), coords: Offset(col * cellWidth, row * cellHeight)),
      ),
    );
  }

  ///Маркируем микроячейки региона редактирования.
  ///Если над ней есть блок-нод она становится занятой и не даст
  ///через себя нарисовать линию прохождения ребра между нодами
  void markCells(List<NodeBloc> nodes) {
    print('Внимание отключен markCells');
    return;
    for (final cellRow in cells) {
      for (final cell in cellRow) {
        cell.bisy = false;
      }
    }

    for (final node in nodes) {
      //print(node.offset);
      for (final cellRow in cells) {
        for (final cell in cellRow) {
          //cell.bisy = false;
          if (node.blockRegion.overlaps(cell.cellRegion)) {
            //print('Ячейка пересекает нод');
            cell.bisy = true;
          } else {
            //cell.bisy = false;
          }
        }
      }
    }
  }

  //Получаем ячейки свободного кратчайшего пути по ячейкам, алгоритм A*
  Iterable<(int, int)> getPath((int, int) start, (int, int) end) {
    Iterable<(int, int)> result = AStar(
      rows: _rows,
      columns: _columns,
      start: start,
      end: end,
      barriers: lineCells.where((c) => c.bisy).toList().map((cl) => cl.cellCoords).toList(),
      withDiagonal: false,
    ).findThePath();
    return result;
  }

  /// Возвращает координаты ячейки (столбец, строка) для заданной точки.
  ///
  /// [point] - Координаты точки (Offset) внутри области.
  /// [cellWidth] - Ширина одной ячейки.
  /// [cellHeight] - Высота одной ячейки.
  (int, int) getCellCoordinates(Offset point) {
    final double cellWidth = NetCell.size.width;
    final double cellHeight = NetCell.size.height;
    // Координата столбца (column):
    // Поскольку ячейки нумеруются с 0,
    // мы просто делим координату x на ширину ячейки и отбрасываем дробную часть (truncating division).
    // point.dx / cellWidth даст нам сколько полных ячеек
    // прошло до этой точки. int conversion (~) выполняет это.
    int column = (point.dx / cellWidth).truncate();
    if (column > _columns) {
      column = _columns;
    }
    // Координата строки (row):
    // Аналогично для координаты y и высоты ячейки.
    int row = (point.dy / cellHeight).truncate();
    if (row > _rows) {
      row = _rows;
    }
    return (column, row);
  }
}

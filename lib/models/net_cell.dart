import 'package:flutter/material.dart';

///класс виртуальной ячейки-маркера, для понимания занято это место на экране чем то или нет
class NetCell {
  ///класс виртуальной ячейки-маркера, для понимания занято это место на экране чем то или нет
  NetCell({required this.coords, required this.cellCoords});
  static const Size size = Size(40, 40);
  //оффсет ячейки по которому строится сетка
  final Offset coords;
  //центр ячейки по которому будем рисовать линии
  Offset get center => cellRegion.center;
  //Ячейка будет занята, если над ней есть нод
  bool bisy = false;
  //координаты ячейки в матрице Region
  (int, int) cellCoords;
  //прямоугольник ячейки - класс по которому происходят вычисления занятости, центра и прочее
  Rect get cellRegion => Rect.fromLTWH(coords.dx, coords.dy, size.width, size.height);
}

import 'package:flutter/material.dart';

class ColorCycle {
  // Массив из 20 Material цветов
  static final List<Color> materialColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  // Функция, которая возвращает цвет по индексу с зацикливанием
  static Color getColorByIndex(int index) {
    if (materialColors.isEmpty) {
      return Colors.transparent; // На случай пустого списка
    }

    // Используем оператор взятия остатка для зацикливания
    int cyclicIndex = index % materialColors.length;
    return materialColors[cyclicIndex];
  }
}

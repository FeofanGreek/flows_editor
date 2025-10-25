import 'package:flutter/material.dart';

// Пример использования в виджете StatefulWidget или StatelessWidget
class ElevatedRoundButton extends StatelessWidget {
  const ElevatedRoundButton({super.key, required this.title, required this.onPressed});

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.indigo),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // 5 пикселей
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(title, style: TextStyle(fontSize: 12.0, color: Colors.white)),
    );
  }
}

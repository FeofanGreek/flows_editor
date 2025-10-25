import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({ super.key, required this.onTap, this.color = Colors.blueAccent, required this.icon, required this.tooltip });
  final Function() onTap;
  final Color color;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child:
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: color,
              width: 2.0,
            ),
          ),
          child: Icon(icon, size: 16, color: Colors.white,),
        ),
      ),
    );
  }
}
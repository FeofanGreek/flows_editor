import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key, required this.currentValue, required this.onChanged, required this.title});
  final String title;
  final bool currentValue;
  final Function(bool?) onChanged;

  @override
  State<CheckBoxWidget> createState() => CheckBoxWidgetState();
}

class CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.black, width: 0.3),
      ),
      title: Text(widget.title, style: TextStyle(color: Colors.black, fontSize: 12)),
      value: widget.currentValue,
      onChanged: widget.onChanged,
    );
  }
}

import 'package:flutter/material.dart';

class DropDownMenu<T> extends StatefulWidget {
  const DropDownMenu({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    required this.getTitle,
  });
  final T selectedItem;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) getTitle;

  @override
  State<DropDownMenu<T>> createState() => DropDownMenuState<T>();
}

class DropDownMenuState<T> extends State<DropDownMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      //height: 37,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text('Выберите значение', style: TextStyle(fontSize: 12)),
          value: widget.selectedItem,
          items: widget.items.map((T mode) {
            return DropdownMenuItem<T>(
              value: mode,
              child: SizedBox(
                width: 300,
                child: Text(
                  widget.getTitle(mode),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ), // Отображение имени
              ),
            );
          }).toList(),
          selectedItemBuilder: (context) => widget.items.map((T mode) {
            return DropdownMenuItem<T>(
              value: mode,
              child: SizedBox(
                width: 300,
                child: Text(widget.getTitle(mode), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
          dropdownColor: Colors.white,
          focusColor: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}

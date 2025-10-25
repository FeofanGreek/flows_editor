import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/flow_function_schema.dart';

class SchemaPlate extends StatelessWidget {
  const SchemaPlate({super.key, required this.a, required this.onTap, required this.remove});

  final FunctionSchema a;
  final Function() onTap;
  final Function() remove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.3),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.grey,
        ),
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        child: IntrinsicWidth(
          child: Row(
            spacing: 10,
            children: [
              Text(a.name, style: TextStyle(color: Colors.white, fontSize: 10)),
              InkWell(
                onTap: remove,
                child: Icon(Icons.clear, color: Colors.white, size: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

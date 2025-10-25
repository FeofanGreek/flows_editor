import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/action_model.dart' as action;

class ActionPlate extends StatelessWidget {
  const ActionPlate({super.key, required this.a, required this.onTap, required this.remove});

  final action.Action a;
  final Function() onTap;
  final Function() remove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
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
              Expanded(
                child: Text(a.type.description, style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
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

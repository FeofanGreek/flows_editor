import 'package:flutter/material.dart';
import '../../ui/widgets/text_field_gpt.dart';
import 'package:flutter/cupertino.dart';
import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import 'circle_button.dart';

class ArrayPropertyWidget extends StatefulWidget {
  const ArrayPropertyWidget({
    super.key,
    required this.setProperty,
    required this.property,
    required this.removeProperty,
  });

  final Function(ArrayPropertyModel) setProperty;
  final ArrayPropertyModel property;
  final Function(ArrayPropertyModel) removeProperty;

  @override
  State<ArrayPropertyWidget> createState() => ArrayPropertyWidgetState();
}

class ArrayPropertyWidgetState extends State<ArrayPropertyWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      spacing: 5,
      children: [
        SizedBox(
          child: Row(
            spacing: 5,
            children: [
              Expanded(flex: 3, child: Text('${loc.listValue}: ${widget.property.key}')),
              Spacer(),

              Text(loc.isRequired),
              Checkbox(value: true, onChanged: (value) {}),
              CircleButton(
                onTap: () => widget.removeProperty(widget.property),
                icon: Icons.delete_forever,
                color: Colors.red,
                tooltip: loc.removeProperty,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Icon(!expanded ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up),
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 0.3, color: Colors.grey),
        if (expanded) ...[
          Text(loc.propertyDescriptionForLLM),
          TextFieldGpt(
            value: widget.property.description,
            callBack: (String p1) {},
            hintText: loc.description,
            isNumber: false,
            onlyLatin: false,
          ),

          Text('Объект JSON Schema, описывающий тип каждого элемента в массиве.'),
          Text(''''"items": {
    "type": "string",
    "enum": ["extra_cheese", "mushrooms", "olives"]
  },'''),

          Text(loc.minimumAndMaximumNumberElementsInArray),
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.minItems.toString(),
                  callBack: (String p1) {},
                  hintText: loc.minIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.maxItems.toString(),
                  callBack: (String p1) {},
                  hintText: loc.maxIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

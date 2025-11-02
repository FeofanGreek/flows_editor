import 'package:PipeCatFlowEditor/utils/list_extension.dart';
import 'package:flutter/material.dart';
import '../../ui/widgets/text_field_gpt.dart';
import 'package:flutter/cupertino.dart';
import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../utils/enums_lib.dart';
import 'circle_button.dart';
import 'drop_down_menu.dart';

class ArrayPropertyWidget extends StatefulWidget {
  const ArrayPropertyWidget({
    super.key,
    required this.setProperty,
    required this.property,
    required this.removeProperty,
    required this.required,
  });

  final Function(ArrayPropertyModel) setProperty;
  final ArrayPropertyModel property;
  final Function(ArrayPropertyModel) removeProperty;
  final List<String> required;

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
              Checkbox(
                value: widget.required.contains(widget.property.key),
                onChanged: (value) {
                  widget.setProperty(widget.property);
                },
              ),
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
          //Общие для всех параметры
          TextFieldGpt(
            value: widget.property.description,
            callBack: (String p1) {
              widget.property.description = p1;
            },
            hintText: loc.description,
            isNumber: false,
            onlyLatin: false,
          ),
          Text('Объект JSON Schema, описывающий тип каждого элемента в массиве.'),
          Row(
            spacing: 5,
            children: [
              DropDownMenu<VariableTypes>(
                selectedItem:
                    VariableTypes.values.firstWhereOrNull((e) => e.json == widget.property.items['type']) ??
                    VariableTypes.string,
                items: VariableTypes.values,
                onChanged: (value) {
                  widget.property.items['type'] = value?.json;
                  setState(() {});
                },
                getTitle: (type) {
                  return type.json;
                },
              ),
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.items['enum'] != null ? widget.property.items['enum']!.join(', ') : '',
                  callBack: (String p1) {
                    switch (widget.property.items['type']) {
                      case 'integer':
                        {
                          widget.property.items['enum'] = p1.split(',').map((e) => num.parse(e)).toList();
                        }
                      case 'number':
                        {
                          widget.property.items['enum'] = p1.split(',').map((e) => num.parse(e)).toList();
                        }
                      case 'string':
                        {
                          widget.property.items['enum'] = p1.split(',').map((e) => e).toList();
                        }
                    }
                  },
                  hintText: loc.listValues,
                  isNumber: widget.property.items['type'] == 'string',
                  onlyLatin: false,
                ),
              ),
            ],
          ),
          Text(loc.minimumAndMaximumNumberElementsInArray),
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.minItems.toString(),
                  maxLength: 10,
                  callBack: (String p1) {
                    widget.property.minItems = int.tryParse(p1);
                  },
                  hintText: loc.minIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.maxItems.toString(),
                  maxLength: 10,
                  callBack: (String p1) {
                    widget.property.maxItems = int.tryParse(p1);
                    //setState(() {});
                  },
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

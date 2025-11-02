import 'package:flutter/material.dart';
import '../../ui/widgets/text_field_gpt.dart';
import 'package:flutter/cupertino.dart';
import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';
import 'circle_button.dart';

class NumberPropertyWidget extends StatefulWidget {
  const NumberPropertyWidget({
    super.key,
    required this.setProperty,
    required this.property,
    required this.removeProperty,
  });

  final Function(NumberPropertyModel) setProperty;
  final NumberPropertyModel property;
  final Function(NumberPropertyModel) removeProperty;

  @override
  State<NumberPropertyWidget> createState() => NumberPropertyWidgetState();
}

class NumberPropertyWidgetState extends State<NumberPropertyWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        SizedBox(
          child: Row(
            spacing: 5,
            children: [
              Expanded(flex: 3, child: Text('${loc.integerValue}: ${widget.property.key}')),
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
          Text(loc.possibleValuesForLLMChoose),
          TextFieldGpt(
            value: widget.property.enums != null ? widget.property.enums!.join(', ') : '',
            callBack: (String p1) {},
            hintText: loc.listValues,
            isNumber: false,
            onlyLatin: false,
          ),
          Text(loc.defaultValueIfLLMCannotMakeChoice),
          Text('TODO тут селектор из имеющихся'),
          TextFieldGpt(
            value: (widget.property.default_value ?? 0).toString(),
            callBack: (String p1) {},
            hintText: 'List of values',
            isNumber: false,
            onlyLatin: false,
          ),
          Text(loc.minimumAndMaximumAllowedValues),
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.minimun.toString(),
                  callBack: (String p1) {},
                  hintText: loc.minIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.maximum.toString(),
                  callBack: (String p1) {},
                  hintText: loc.maxIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
            ],
          ),
          Text(loc.valueMustStrictlyGreaterLessSpecifiedValue),
          Row(
            children: [
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.exlusiveMinimum.toString(),
                  callBack: (String p1) {},
                  hintText: loc.minIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
              Expanded(
                child: TextFieldGpt(
                  value: widget.property.exlusiveMaximum.toString(),
                  callBack: (String p1) {},
                  hintText: loc.maxIntegerValue,
                  isNumber: true,
                  onlyLatin: false,
                ),
              ),
            ],
          ),
          Text(loc.valueMustMultipleSpecifiedNumber),
          TextFieldGpt(
            value: widget.property.multipleOf.toString(),
            callBack: (String p1) {},
            hintText: loc.integerValue,
            isNumber: true,
            onlyLatin: false,
          ),
        ],
      ],
    );
  }
}

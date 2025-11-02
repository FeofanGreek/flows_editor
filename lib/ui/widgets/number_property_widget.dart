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
    required this.required,
  });

  final Function(NumberPropertyModel) setProperty;
  final NumberPropertyModel property;
  final Function(NumberPropertyModel) removeProperty;
  final List<String> required;

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
          Text(loc.possibleValuesForLLMChoose),
          TextFieldGpt(
            value: widget.property.enums != null ? widget.property.enums!.join(', ') : '',
            callBack: (String p1) {
              widget.property.enums = p1.split(',').map((e) => num.tryParse(e) ?? 0).toList();
              setState(() {});
            },
            hintText: loc.listValues,
            isNumber: false,
            onlyLatin: false,
          ),
          Text(loc.defaultValueIfLLMCannotMakeChoice),
        ],

        Wrap(
          children: [
            ...(widget.property.enums ?? []).map(
              (el) => SizedBox(
                width: (30 + (el.toString().length * 12)).toDouble(),
                child: Row(
                  spacing: 5,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.property.default_value = el;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                        ),
                        height: 20,
                        width: 20,
                        padding: EdgeInsets.all(3),
                        child: el == widget.property.default_value
                            ? Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(color: Colors.deepPurpleAccent, shape: BoxShape.circle),
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                    Text('$el'),
                  ],
                ),
              ),
            ),
          ],
        ),

        Text(loc.minimumAndMaximumAllowedValues),
        Row(
          spacing: 5,
          children: [
            Expanded(
              child: TextFieldGpt(
                value: widget.property.minimun.toString(),
                maxLength: 10,
                callBack: (String p1) {
                  widget.property.minimun = num.tryParse(p1);
                },
                hintText: loc.minIntegerValue,
                isNumber: true,
                onlyLatin: false,
              ),
            ),
            Expanded(
              child: TextFieldGpt(
                value: widget.property.maximum.toString(),
                maxLength: 10,
                callBack: (String p1) {
                  widget.property.maximum = num.tryParse(p1);
                  //setState(() {});
                },
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
                maxLength: 10,
                callBack: (String p1) {
                  widget.property.exlusiveMinimum = num.tryParse(p1);
                  //setState(() {});
                },
                hintText: loc.minIntegerValue,
                isNumber: true,
                onlyLatin: false,
              ),
            ),
            Expanded(
              child: TextFieldGpt(
                value: widget.property.exlusiveMaximum.toString(),
                maxLength: 10,
                callBack: (String p1) {
                  widget.property.exlusiveMaximum = num.tryParse(p1);
                  //setState(() {});
                },
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
          maxLength: 10,
          callBack: (String p1) {
            widget.property.multipleOf = num.tryParse(p1);
          },
          hintText: loc.integerValue,
          isNumber: true,
          onlyLatin: false,
        ),
      ],
    );
  }
}

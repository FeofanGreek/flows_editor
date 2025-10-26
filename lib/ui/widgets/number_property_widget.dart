import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/widgets/text_field_gpt.dart';

import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';

class NumberPropertyWidget extends StatefulWidget {
  const NumberPropertyWidget({super.key, required this.setProperty});

  final Function(NumberPropertyModel) setProperty;

  @override
  State<NumberPropertyWidget> createState() => NumberPropertyWidgetState();
}

class NumberPropertyWidgetState extends State<NumberPropertyWidget> {
  final property = NumberPropertyModel(description: '', enums: [], default_value: null);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      spacing: 5,
      children: [
        Text(loc.propertyDescriptionForLLM),
        TextFieldGpt(
          value: property.description,
          callBack: (String p1) {},
          hintText: loc.description,
          isNumber: false,
          onlyLatin: false,
        ),
        Text(loc.possibleValuesForLLMChoose),
        TextFieldGpt(
          value: property.enums != null ? property.enums!.join(', ') : '',
          callBack: (String p1) {},
          hintText: loc.listValues,
          isNumber: false,
          onlyLatin: false,
        ),
        Text(loc.defaultValueIfLLMCannotMakeChoice),
        Text('TODO тут селектор из имеющихся'),
        TextFieldGpt(
          value: (property.default_value ?? 0).toString(),
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
                value: property.minimun.toString(),
                callBack: (String p1) {},
                hintText: loc.minIntegerValue,
                isNumber: true,
                onlyLatin: false,
              ),
            ),
            Expanded(
              child: TextFieldGpt(
                value: property.maximum.toString(),
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
                value: property.exlusiveMinimum.toString(),
                callBack: (String p1) {},
                hintText: loc.minIntegerValue,
                isNumber: true,
                onlyLatin: false,
              ),
            ),
            Expanded(
              child: TextFieldGpt(
                value: property.exlusiveMaximum.toString(),
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
          value: property.multipleOf.toString(),
          callBack: (String p1) {},
          hintText: loc.integerValue,
          isNumber: true,
          onlyLatin: false,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/widgets/text_field_gpt.dart';

import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';

class ArrayPropertyWidget extends StatefulWidget {
  const ArrayPropertyWidget({super.key, required this.setProperty});

  final Function(ArrayPropertyModel) setProperty;

  @override
  State<ArrayPropertyWidget> createState() => ArrayPropertyWidgetState();
}

class ArrayPropertyWidgetState extends State<ArrayPropertyWidget> {
  final property = ArrayPropertyModel(description: '', items: {});

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
                value: property.minItems.toString(),
                callBack: (String p1) {},
                hintText: loc.minIntegerValue,
                isNumber: true,
                onlyLatin: false,
              ),
            ),
            Expanded(
              child: TextFieldGpt(
                value: property.maxItems.toString(),
                callBack: (String p1) {},
                hintText: loc.maxIntegerValue,
                isNumber: true,
                onlyLatin: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

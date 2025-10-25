import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/widgets/text_field_gpt.dart';

import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';

class ArrayPropertyWidget extends StatefulWidget {
  const ArrayPropertyWidget({super.key, required this.setProperty});

  final Function(ArrayPropertyModel) setProperty;

  @override
  State<ArrayPropertyWidget> createState() => ArrayPropertyWidgetState();
}

class ArrayPropertyWidgetState extends State<ArrayPropertyWidget> {
  final property = ArrayPropertyModel(description: '', enums: [], default_value: '', items: {});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Описание для настройки для LLM'),
        TextFieldGpt(value: property.description, callBack: (String p1) {}),
        Text('Возможные значения из которых LLM сделает выбор (поле может быть пустым)'),
        TextFieldGpt(value: property.enums.toString(), callBack: (String p1) {}),
        Text('Значение по умолчанию, если выбор не может быть сделан'),
        TextFieldGpt(value: property.default_value, callBack: (String p1) {}),
        Text('Объект JSON Schema, описывающий **тип каждого элемента** в массиве. **Обязательно** для `array`.'),
        Text(''''"items": {
    "type": "string",
    "enum": ["extra_cheese", "mushrooms", "olives"]
  },'''),

        Text('Минимальное и максимальное количество элементов в массиве. (поле может быть пустым)'),
        Row(
          children: [
            TextFieldGpt(value: property.minItems.toString(), callBack: (String p1) {}),
            TextFieldGpt(value: property.maxItems.toString(), callBack: (String p1) {}),
          ],
        ),
      ],
    );
  }
}

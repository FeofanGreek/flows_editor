import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/widgets/text_field_gpt.dart';

import '../../models/flowschema_properties_models/number_property_model.dart';

class NumberPropertyWidget extends StatefulWidget {
  const NumberPropertyWidget({super.key, required this.setProperty});

  final Function(NumberPropertyModel) setProperty;

  @override
  State<NumberPropertyWidget> createState() => NumberPropertyWidgetState();
}

class NumberPropertyWidgetState extends State<NumberPropertyWidget> {
  final property = NumberPropertyModel(description: '', enums: [], default_value: '');

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
        Text('Минимальное и максимально допустимое значение (включительно). (поле может быть пустым)'),
        Row(
          children: [
            TextFieldGpt(value: property.minimun.toString(), callBack: (String p1) {}),
            TextFieldGpt(value: property.maximum.toString(), callBack: (String p1) {}),
          ],
        ),
        Text('Значение должно быть строго больше или меньше, чем указанное.(поле может быть пустым)'),
        Row(
          children: [
            TextFieldGpt(value: property.exlusiveMinimum.toString(), callBack: (String p1) {}),
            TextFieldGpt(value: property.exlusiveMaximum.toString(), callBack: (String p1) {}),
          ],
        ),
        Text('Значение должно быть кратно указанному числу (например, `0.5`) (поле может быть пустым)'),
        TextFieldGpt(value: property.multipleOf.toString(), callBack: (String p1) {}),
      ],
    );
  }
}

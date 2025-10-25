import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/widgets/text_field_gpt.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_state_controller.dart';
import '../../models/flowschema_properties_models/string_property_model.dart';

class StringPropertyWidget extends StatefulWidget {
  const StringPropertyWidget({super.key, required this.setProperty});

  final Function(StringPropertyModel) setProperty;

  @override
  State<StringPropertyWidget> createState() => StringPropertyWidgetState();
}

class StringPropertyWidgetState extends State<StringPropertyWidget> {
  final property = StringPropertyModel(description: '', enums: [], default_value: '', format: '');

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppStateController>();
    return Container(
      constraints: BoxConstraints(minWidth: 400, maxWidth: appState.leftSide),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Описание для настройки для LLM'),
          TextFieldGpt(value: property.description, callBack: (String p1) {}),
          Text('Возможные значения из которых LLM сделает выбор (поле может быть пустым)'),
          TextFieldGpt(value: property.enums.toString(), callBack: (String p1) {}),
          Text('Значение по умолчанию, если выбор не может быть сделан'),
          TextFieldGpt(value: property.default_value, callBack: (String p1) {}),
          Text('Ограничитель длины строки (поля могут быть пустыми)'),
          Row(
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: appState.leftSide / 2),
                child: TextFieldGpt(value: property.minLength.toString(), callBack: (String p1) {}),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: appState.leftSide / 2),
                child: TextFieldGpt(value: property.maxLenght.toString(), callBack: (String p1) {}),
              ),
            ],
          ),

          Text('Regex паттерн (поле может быть пустым)'),
          TextFieldGpt(value: property.pattern ?? '', callBack: (String p1) {}),
          Text(
            'Форматирование полученного ответа (поле может быть пустым, но форматирование может пригодиться вам для последующей обработки)',
          ),
          TextFieldGpt(value: property.format, callBack: (String p1) {}),
        ],
      ),
    );
  }
}

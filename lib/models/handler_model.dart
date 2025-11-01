import '../../utils/string_extention.dart';
import 'package:flutter/material.dart';

import '../utils/enums_lib.dart';
import 'addon_properties_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'handler_model.g.dart';

///описание хэндлера внутри FlowFunctionSchema
@JsonSerializable()
class HandlerModel {
  String get name {
    return '${flowResultName}_handler';
  }

  String flowResultName;

  ///описание параметров из которых будет идти выбор и формирование результата
  ///{
  //             "size": {
  //                 "type": "string",
  //                 "enum": ["small", "medium", "large"],
  //                 "description": "Size of the pizza",
  //             },
  //             "type_pizza": {
  //                 "type": "string",
  //                 "enum": ["pepperoni", "cheese", "supreme", "vegetarian"],
  //                 "description": "Type of pizza",
  //             },
  //         }
  Map<String, dynamic> properties;

  ///указатель, какие парметры в properties обязательные. Пока модель не получит ответ на обязательные параметры, она не перейдет на следующий нод
  List<String> required = [];

  List<AddonPropertiesModel> addonProperties = [];

  ///Список ююидов нодов на которые эта схема может переключить по результатам работы хэндлера
  List<String> nextNodeUuid = [];

  //GLobalKey для визуального отображения связи хэндлера с нодом
  @JsonKey(includeFromJson: false, includeToJson: false)
  final GlobalKey key = GlobalKey();

  HandlerModel({required this.required, required this.flowResultName, required this.properties});

  factory HandlerModel.fromJson(Map<String, dynamic> json) => _$HandlerModelFromJson(json);
  Map<String, dynamic> toJson() => _$HandlerModelToJson(this);

  Map<String, dynamic> toSaveJson() {
    return {
      'flowResultName': flowResultName,
      'properties': properties,
      'addonProperties': addonProperties.map((add) => add).toList(),
      'outNode': nextNodeUuid,
    };
  }

  String returnClassBody() {
    return properties.entries
        .map((entry) {
          return '            ${entry.key}: ${VariableTypes.values.firstWhere((value) => value.json == entry.value['type']).python}';
        })
        .join('\n');
  }

  String returnFlowResultBody() {
    return properties.entries
        .map((entry) {
          return '            ${entry.key}=result["${entry.key}"]';
        })
        .join(',\n');
  }

  String returnAddonPropertiesToClass() {
    return '''
${addonProperties.map((prop) => '${prop.name}: ${prop.type.python}').join('\n')}
    ''';
  }

  String returnAddonPropertiesToHandler() {
    return '''
${addonProperties.map((prop) => '${prop.name}: ${prop.type.python}').join('\n')}
    ''';
  }

  String toPython() {
    return '''
    #создаем класс
    class ${flowResultName.toCapitalized()}(FlowResult):
${returnClassBody()}
${returnAddonPropertiesToClass()}
    
    async def $name(args: FlowArgs, flow_manager: FlowManager) -> tuple[${flowResultName.toCapitalized()}, NodeConfig]:
      #вот тут что-то отправляем в АПИ и получаем структурированый ответ
      #определяем следующий узел
      result, next_node = router(args, "$name")

      #объявляем класс для последующей предачи
      flow_result = ${flowResultName.toCapitalized()}(
${returnFlowResultBody()}
${returnAddonPropertiesToHandler()}
      )
      return flow_result, next_node
''';
  }

  // Функция для получения глобальной позиции виджета
  Offset? getPosition() {
    final context = key.currentContext;

    if (context == null) {
      return null;
    }
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}

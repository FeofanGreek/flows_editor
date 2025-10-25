import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'handler_model.dart';

part 'flow_function_schema.g.dart';

/// Модель для FlowsFunctionSchema (схема функции/инструмента)
@JsonSerializable()
class FunctionSchema {
  String uuid;

  ///имя функции с которой будет оперировать LLM для простоты лучше делать равной handlerName и в формате snake_case
  String get name => '${handler.name}_schema';

  ///хэндлер этой схемы
  HandlerModel handler;

  ///Описание должно быть максимально точным, ясным и кратким, чтобы LLM могла правильно оценить намерение пользователя и понять, когда именно следует вызвать этот инструмент, а когда — нет
  String description;

  FunctionSchema({required this.uuid, required this.description, required this.handler});

  factory FunctionSchema.fromJson(Map<String, dynamic> json) => _$FunctionSchemaFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionSchemaToJson(this);

  Map<String, dynamic> toSaveJson() {
    return {'handler': handler.toSaveJson(), 'description': description};
  }

  String toPython() {
    return '''
    $name = FlowsFunctionSchema(
      name="${handler.name}",
      handler=${handler.name},
      description="$description",
      properties=${jsonEncode(handler.properties)},
      required=${jsonEncode(handler.properties.keys.toList())},
    )
''';
  }

  ///гнерерируем код роутера - преключателя на нужный нод
  String returnManyNodesLogic() {
    print('ТУТ Логическая ошибка ПЕРЕДЕЛАТЬ');
    final buffer = StringBuffer();
    // for (int i = 0; i < nodes.length; i++) {
    //   for (int ii = 0; ii < nodes[i].functions.length; ii++) {
    //     for (int iii = 0; iii < nodes[i].functions[ii].handler.nextNodeUuid.length; iii++) {
    //       String prefix;
    //       if (iii == 0) {
    //         prefix = '        if';
    //       } else if (iii == nodes[i].functions[ii].handler.nextNodeUuid.length - 1) {
    //         prefix = '        else';
    //       } else {
    //         prefix = '        elif';
    //       }
    //       buffer.write(prefix);
    //       buffer.write(' #настройте_условие:\n');
    //       //TODO найти аргументы
    //       buffer.write('          return (arg, ${nodes[i].functions[ii].handler.nextNodeUuid[iii]}())\n');
    //     }
    //   }
    // }
    return buffer.toString();
  }

  String toRouterPython() {
    return '''
${returnManyNodesLogic()}    
''';
  }
}

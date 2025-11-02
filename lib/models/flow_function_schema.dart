import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'handler_model.dart';

part 'flow_function_schema.g.dart';

/// Модель для FlowsFunctionSchema (схема функции/инструмента)
@JsonSerializable()
class FunctionSchema {
  String uuid;

  ///имя функции с которой будет оперировать LLM для простоты лучше делать равной handlerName и в формате snake_case
  String get name => '${handler.latinName}_schema';

  ///хэндлер этой схемы
  HandlerModel handler;

  ///Описание должно быть максимально точным, ясным и кратким, чтобы LLM могла правильно оценить намерение пользователя и понять, когда именно следует вызвать этот инструмент, а когда — нет
  String description;

  FunctionSchema({required this.uuid, required this.description, required this.handler});

  factory FunctionSchema.fromJson(Map<String, dynamic> json) => _$FunctionSchemaFromJson(json);
  Map<String, dynamic> toJson() => _$FunctionSchemaToJson(this);

  String toPython() {
    return '''
    $name = FlowsFunctionSchema(
      name="${handler.latinName}",
      handler=${handler.latinName},
      description="$description",
      properties=${jsonEncode(handler.properties)},
      required=${jsonEncode(handler.properties.keys.toList())},
    )
''';
  }
}

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../utils/enums_lib.dart';
import '../utils/transliterator.dart';
import 'action_model.dart';
import 'flow_function_schema.dart';
import 'message_model.dart';

part 'node_config_model.g.dart';

/// Основной класс NodeConfig, представляющий узел в Pipecat Flow
@JsonSerializable()
class NodeConfig {
  String name;

  ///Описание этого узла (что он получает на вход и чем определяет направление выхода)
  String description = '';

  String get latinName => transliterateRussian(name);

  /// Сообщения роли/системные инструкции (только в стартовом узле)
  Message? roleMessage;

  /// Инструкции для LLM на текущем шаге (что делать)
  Message taskMessage;

  /// Функции/Инструменты
  List<FunctionSchema> functions = []; // Список функций, доступных LLM в этом узле
  /// Действия, выполняемые ДО генерации LLM (например, "Минуточку...")
  List<Action> preActions = [];

  /// Действия, выполняемые ПОСЛЕ ответа LLM (например, завершить разговор)
  List<Action> postActions = [];

  /// Должна ли LLM начать генерировать ответ сразу (true) или ждать ввода пользователя (false)
  bool respondImmediately;

  ///стратегия обработки контекста
  ContextStrategy context_strategy = ContextStrategy.APPEND;

  NodeConfig({
    required this.name,
    required this.taskMessage,
    // По умолчанию LLM должна начать говорить, если есть taskMessages
    this.respondImmediately = false,
  });

  factory NodeConfig.fromJson(Map<String, dynamic> json) => _$NodeConfigFromJson(json);
  Map<String, dynamic> toJson() => _$NodeConfigToJson(this);

  String toPython() {
    return '''
def ${latinName}_node() -> NodeConfig:

${functions.map((e) => e.handler.toPython()).join('\n')}

${functions.map((e) => e.toPython()).join('\n')}
    
    return NodeConfig(
      name="$name",
      role_messages=[
          {
            "role": "${roleMessage!.role}",
            "content": "${roleMessage!.content}"
          }    
        ],
      task_messages=[
          {
            "role": "${taskMessage.role}",
            "content": "${taskMessage.content}"
          }
        ],
      pre_actions=${preActions.map((action) => '{"type":"${action.type.name}", "handler": ${action.handlerName != null ? "${action.handlerName}" : 'None'}, "text": "${action.text}"}').toList()},
      post_actions=${postActions.map((action) => '{"type":"${action.type.name}", "handler": ${action.handlerName != null ? "${action.handlerName}" : 'None'}, "text": "${action.text}"}').toList()},
      functions=${jsonEncode(functions.map((schema) => schema.name).toList())},
      respond_immediately= ${respondImmediately ? 'True' : 'False'},
      context_strategy=ContextStrategyConfig(strategy=$context_strategy),
    )
''';
  }
}

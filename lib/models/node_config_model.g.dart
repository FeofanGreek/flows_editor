// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeConfig _$NodeConfigFromJson(Map<String, dynamic> json) =>
    NodeConfig(
        name: json['name'] as String,
        taskMessage: Message.fromJson(
          json['taskMessage'] as Map<String, dynamic>,
        ),
        respondImmediately: json['respondImmediately'] as bool? ?? true,
      )
      ..roleMessage = json['roleMessage'] == null
          ? null
          : Message.fromJson(json['roleMessage'] as Map<String, dynamic>)
      ..functions = (json['functions'] as List<dynamic>)
          .map((e) => FunctionSchema.fromJson(e as Map<String, dynamic>))
          .toList()
      ..preActions = (json['preActions'] as List<dynamic>)
          .map((e) => Action.fromJson(e as Map<String, dynamic>))
          .toList()
      ..postActions = (json['postActions'] as List<dynamic>)
          .map((e) => Action.fromJson(e as Map<String, dynamic>))
          .toList()
      ..context_strategy = $enumDecode(
        _$ContextStrategyEnumMap,
        json['context_strategy'],
      );

Map<String, dynamic> _$NodeConfigToJson(NodeConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'roleMessage': instance.roleMessage,
      'taskMessage': instance.taskMessage,
      'functions': instance.functions,
      'preActions': instance.preActions,
      'postActions': instance.postActions,
      'respondImmediately': instance.respondImmediately,
      'context_strategy': _$ContextStrategyEnumMap[instance.context_strategy]!,
    };

const _$ContextStrategyEnumMap = {
  ContextStrategy.APPEND: 'APPEND',
  ContextStrategy.RESET: 'RESET',
  ContextStrategy.RESET_WITH_SUMMARY: 'RESET_WITH_SUMMARY',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
  type: $enumDecode(_$ActionTypesEnumMap, json['type']),
  text: json['text'] as String?,
  handlerName: json['handlerName'] as String?,
)..codeSnipet = json['codeSnipet'] as String?;

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
  'type': _$ActionTypesEnumMap[instance.type]!,
  'text': instance.text,
  'handlerName': instance.handlerName,
  'codeSnipet': instance.codeSnipet,
};

const _$ActionTypesEnumMap = {
  ActionTypes.tts_say: 'tts_say',
  ActionTypes.end_conversation: 'end_conversation',
  ActionTypes.function: 'function',
};

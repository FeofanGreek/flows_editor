// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_function_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunctionSchema _$FunctionSchemaFromJson(Map<String, dynamic> json) =>
    FunctionSchema(
      uuid: json['uuid'] as String,
      description: json['description'] as String,
      required: (json['required'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      handler: HandlerModel.fromJson(json['handler'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FunctionSchemaToJson(FunctionSchema instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'handler': instance.handler,
      'description': instance.description,
      'required': instance.required,
    };

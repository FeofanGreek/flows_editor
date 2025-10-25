// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handler_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandlerModel _$HandlerModelFromJson(Map<String, dynamic> json) =>
    HandlerModel(
        flowResultName: json['flowResultName'] as String,
        properties: json['properties'] as Map<String, dynamic>,
        description: json['description'] as String,
      )
      ..addonProperties = (json['addonProperties'] as List<dynamic>)
          .map((e) => AddonPropertiesModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..nextNodeUuid = (json['nextNodeUuid'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

Map<String, dynamic> _$HandlerModelToJson(HandlerModel instance) =>
    <String, dynamic>{
      'flowResultName': instance.flowResultName,
      'properties': instance.properties,
      'description': instance.description,
      'addonProperties': instance.addonProperties,
      'nextNodeUuid': instance.nextNodeUuid,
    };

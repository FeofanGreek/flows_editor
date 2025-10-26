// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NumberPropertyModel _$NumberPropertyModelFromJson(Map<String, dynamic> json) =>
    NumberPropertyModel(
      description: json['description'] as String,
      enums: (json['enums'] as List<dynamic>?)?.map((e) => e as num).toList(),
      default_value: json['default_value'] as num?,
      minimun: json['minimun'] as num?,
      maximum: json['maximum'] as num?,
      exlusiveMinimum: json['exlusiveMinimum'] as num?,
      exlusiveMaximum: json['exlusiveMaximum'] as num?,
      multipleOf: json['multipleOf'] as num?,
    );

Map<String, dynamic> _$NumberPropertyModelToJson(
  NumberPropertyModel instance,
) => <String, dynamic>{
  'description': instance.description,
  'enums': instance.enums,
  'default_value': instance.default_value,
  'minimun': instance.minimun,
  'maximum': instance.maximum,
  'exlusiveMinimum': instance.exlusiveMinimum,
  'exlusiveMaximum': instance.exlusiveMaximum,
  'multipleOf': instance.multipleOf,
};

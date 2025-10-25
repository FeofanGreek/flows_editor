// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringPropertyModel _$StringPropertyModelFromJson(Map<String, dynamic> json) =>
    StringPropertyModel(
      description: json['description'] as String,
      enums: (json['enums'] as List<dynamic>).map((e) => e as String).toList(),
      default_value: json['default_value'] as String,
      minLength: (json['minLength'] as num?)?.toInt(),
      maxLenght: (json['maxLenght'] as num?)?.toInt(),
      pattern: json['pattern'] as String?,
      format: json['format'] as String,
    );

Map<String, dynamic> _$StringPropertyModelToJson(
  StringPropertyModel instance,
) => <String, dynamic>{
  'description': instance.description,
  'enums': instance.enums,
  'default_value': instance.default_value,
  'minLength': instance.minLength,
  'maxLenght': instance.maxLenght,
  'pattern': instance.pattern,
  'format': instance.format,
};

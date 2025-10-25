// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'array_property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArrayPropertyModel _$ArrayPropertyModelFromJson(Map<String, dynamic> json) =>
    ArrayPropertyModel(
      description: json['description'] as String,
      enums: (json['enums'] as List<dynamic>).map((e) => e as num).toList(),
      default_value: json['default_value'] as String,
      items: json['items'] as Map<String, dynamic>,
      minItems: (json['minItems'] as num?)?.toInt(),
      maxItems: (json['maxItems'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ArrayPropertyModelToJson(ArrayPropertyModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'enums': instance.enums,
      'default_value': instance.default_value,
      'items': instance.items,
      'minItems': instance.minItems,
      'maxItems': instance.maxItems,
    };

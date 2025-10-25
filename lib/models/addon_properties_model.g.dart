// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addon_properties_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddonPropertiesModel _$AddonPropertiesModelFromJson(
  Map<String, dynamic> json,
) => AddonPropertiesModel(
  name: json['name'] as String,
  type: $enumDecode(_$VariableTypesEnumMap, json['type']),
);

Map<String, dynamic> _$AddonPropertiesModelToJson(
  AddonPropertiesModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': _$VariableTypesEnumMap[instance.type]!,
};

const _$VariableTypesEnumMap = {
  VariableTypes.string: 'string',
  VariableTypes.integer: 'integer',
  VariableTypes.number: 'number',
  VariableTypes.boolean: 'boolean',
  VariableTypes.array: 'array',
  VariableTypes.object: 'object',
};

import 'package:json_annotation/json_annotation.dart';

part 'array_property_model.g.dart';

@JsonSerializable()
class ArrayPropertyModel {
  final String description;
  final List<num> enums;
  final String default_value;
  final Map items;
  final int? minItems;
  final int? maxItems;

  ArrayPropertyModel({
    required this.description,
    required this.enums,
    required this.default_value,
    required this.items,
    this.minItems,
    this.maxItems,
  });

  factory ArrayPropertyModel.fromJson(Map<String, dynamic> json) => _$ArrayPropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArrayPropertyModelToJson(this);
}

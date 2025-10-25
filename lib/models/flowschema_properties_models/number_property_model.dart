import 'package:json_annotation/json_annotation.dart';

part 'number_property_model.g.dart';

@JsonSerializable()
class NumberPropertyModel {
  final String description;
  final List<num> enums;
  final String default_value;
  final num? minimun;
  final num? maximum;
  final num? exlusiveMinimum;
  final num? exlusiveMaximum;
  final num? multipleOf;

  NumberPropertyModel({
    required this.description,
    required this.enums,
    required this.default_value,
    this.minimun,
    this.maximum,
    this.exlusiveMinimum,
    this.exlusiveMaximum,
    this.multipleOf,
  });

  factory NumberPropertyModel.fromJson(Map<String, dynamic> json) => _$NumberPropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$NumberPropertyModelToJson(this);
}

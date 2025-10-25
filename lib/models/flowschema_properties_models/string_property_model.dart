import 'package:json_annotation/json_annotation.dart';

part 'string_property_model.g.dart';

@JsonSerializable()
class StringPropertyModel {
  final String description;
  final List<String> enums;
  final String default_value;
  final int? minLength;
  final int? maxLenght;
  final String? pattern;
  final String format;

  StringPropertyModel({
    required this.description,
    required this.enums,
    required this.default_value,
    this.minLength,
    this.maxLenght,
    this.pattern,
    required this.format,
  });

  factory StringPropertyModel.fromJson(Map<String, dynamic> json) => _$StringPropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$StringPropertyModelToJson(this);
}

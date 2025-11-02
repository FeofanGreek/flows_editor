import 'package:json_annotation/json_annotation.dart';

part 'number_property_model.g.dart';

@JsonSerializable()
class NumberPropertyModel {
  String description;
  List<num>? enums;
  num? default_value;
  num? minimun;
  num? maximum;
  num? exlusiveMinimum;
  num? exlusiveMaximum;
  num? multipleOf;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String key = '';
  @JsonKey(includeFromJson: false, includeToJson: false)
  String typeLabel = 'integer';

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

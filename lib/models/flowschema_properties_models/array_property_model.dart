import 'package:json_annotation/json_annotation.dart';

part 'array_property_model.g.dart';

@JsonSerializable()
class ArrayPropertyModel {
  String description;
  Map items;
  int? minItems;
  int? maxItems;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String key = '';

  ArrayPropertyModel({required this.description, required this.items, this.minItems, this.maxItems});

  factory ArrayPropertyModel.fromJson(Map<String, dynamic> json) => _$ArrayPropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArrayPropertyModelToJson(this);
}

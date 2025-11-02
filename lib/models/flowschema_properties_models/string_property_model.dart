import 'package:json_annotation/json_annotation.dart';

part 'string_property_model.g.dart';

@JsonSerializable()
class StringPropertyModel {
  String description;
  List<String>? enums;
  String? default_value;
  int? minLength;
  int? maxLenght;
  String? pattern;
  String? format;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String key = '';
  @JsonKey(includeFromJson: false, includeToJson: false)
  String typeLabel = 'string';

  StringPropertyModel({
    required this.description,
    required this.enums,
    required this.default_value,
    this.minLength,
    this.maxLenght,
    this.pattern,
    this.format,
  });

  static StringPropertyModel empty() => StringPropertyModel(
    description: '',
    enums: [],
    default_value: '',
    minLength: null,
    maxLenght: null,
    pattern: null,
    format: '',
  );

  factory StringPropertyModel.fromJson(Map<String, dynamic> json) => _$StringPropertyModelFromJson(json);
  Map<String, dynamic> toJson() => _$StringPropertyModelToJson(this);
}

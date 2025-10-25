import '../utils/enums_lib.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addon_properties_model.g.dart';

///Дополнительные параметры для класса FlowResult
@JsonSerializable()
class AddonPropertiesModel {
  String name;
  VariableTypes type;

  AddonPropertiesModel({required this.name, required this.type});

  factory AddonPropertiesModel.fromJson(Map<String, dynamic> json) => _$AddonPropertiesModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddonPropertiesModelToJson(this);
}

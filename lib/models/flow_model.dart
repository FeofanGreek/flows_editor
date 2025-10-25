import 'block_node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flow_model.g.dart';

@JsonSerializable()
class FlowModel {
  String projectName;
  String projectDescription;

  ///массив блоков с нодами
  List<NodeBloc> nodes = [];

  FlowModel({required this.projectName, required this.projectDescription});

  factory FlowModel.fromJson(Map<String, dynamic> json) => _$FlowModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlowModelToJson(this);

  Map<String, dynamic> toSaveJson() {
    return {
      'projectName': projectName,
      'projectDescription': projectDescription,
      'nodes': nodes.map((node) => node.nodeData.toSaveJson()).toList(),
    };
  }
}

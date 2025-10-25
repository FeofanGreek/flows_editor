// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlowModel _$FlowModelFromJson(Map<String, dynamic> json) =>
    FlowModel(
        projectName: json['projectName'] as String,
        projectDescription: json['projectDescription'] as String,
      )
      ..nodes = (json['nodes'] as List<dynamic>)
          .map((e) => NodeBloc.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$FlowModelToJson(FlowModel instance) => <String, dynamic>{
  'projectName': instance.projectName,
  'projectDescription': instance.projectDescription,
  'nodes': instance.nodes,
};

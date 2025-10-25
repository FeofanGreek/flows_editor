// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeBloc _$NodeBlocFromJson(Map<String, dynamic> json) => NodeBloc(
  nodeData: NodeConfig.fromJson(json['nodeData'] as Map<String, dynamic>),
  uuid: json['uuid'] as String,
)..offset = _offsetFromJson(json['offset'] as Map<String, dynamic>);

Map<String, dynamic> _$NodeBlocToJson(NodeBloc instance) => <String, dynamic>{
  'offset': _offsetToJson(instance.offset),
  'nodeData': instance.nodeData,
  'uuid': instance.uuid,
};

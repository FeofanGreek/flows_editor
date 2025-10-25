import 'package:flutter/material.dart';

import 'node_config_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block_node.g.dart';

///Ячейка нода с данными внутри нее
@JsonSerializable()
class NodeBloc {
  ///Ячейка нода с данными внутри нее
  NodeBloc({required this.nodeData, required this.uuid});
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double width = 200;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final double height = 80;

  ///GlobalKey для отрисовки связки между нодом и хэндлером
  @JsonKey(includeFromJson: false, includeToJson: false)
  final GlobalKey key = GlobalKey();

  ///Координаты нода на экране
  @JsonKey(fromJson: _offsetFromJson, toJson: _offsetToJson)
  Offset offset = Offset.zero;

  ///Uuid этого узла, по нему привязываемся графом

  ///Запретная область занятая блоком, в эту область нельзя добавить новый блок, эта область скажет нам, что NetCell bisy
  Rect get blockRegion => Rect.fromLTWH(offset.dx, offset.dy, width, height);

  //Данные нода, который лежит в этой ячейке
  NodeConfig nodeData;

  //Ююид нода для связки с хэндлером внутри flouwfunction schema
  String uuid;

  factory NodeBloc.fromJson(Map<String, dynamic> json) => _$NodeBlocFromJson(json);
  Map<String, dynamic> toJson() => _$NodeBlocToJson(this);

  // Функция для получения координаты визуального входа в нод
  Offset? getPosition() {
    final context = key.currentContext;

    if (context == null) {
      return null;
    }
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }
}

Offset _offsetFromJson(Map<String, dynamic> json) {
  // Гарантируем, что мы приводим значения к double
  return Offset((json['dx'] as num).toDouble(), (json['dy'] as num).toDouble());
}

Map<String, dynamic> _offsetToJson(Offset offset) {
  return {'dx': offset.dx, 'dy': offset.dy};
}

import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/models/flow_function_schema.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/block_node.dart';
import '../../models/handler_model.dart';

class NodeDraggablePlate extends StatefulWidget {
  const NodeDraggablePlate({super.key, required this.n});
  final NodeBloc n;

  @override
  State<NodeDraggablePlate> createState() => NodeDraggablePlateState();
}

class NodeDraggablePlateState extends State<NodeDraggablePlate> {
  late NodeBloc n;

  @override
  void initState() {
    n = widget.n;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.read<AppStateController>();
    final loc = AppLocalizations.of(context)!;
    return Positioned(
      top: n.offset.dy,
      left: n.offset.dx,
      child: GestureDetector(
        onTap: () {
          controller.setEdge(null, n.uuid);
        },
        onPanUpdate: (d) {
          final offset = Offset(
            d.globalPosition.dx + appState.horizontalScrollController.position.pixels - appState.leftSide,
            d.globalPosition.dy + appState.verticalScrollController.position.pixels,
          );
          n.offset = offset;
          controller.update();
        },
        onPanEnd: (v) {
          controller.region.markCells(controller.nodes);
          controller.update();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 0.3),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          width: n.width,
          height: n.height,
          child: Stack(
            children: [
              //заголовок (Название) нода
              Container(
                height: 15,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(4), topLeft: Radius.circular(4)),
                ),
                child: Text(n.nodeData.name, style: TextStyle(color: Colors.white, fontSize: 12, height: 1)),
              ),
              //Описание нода
              Positioned(
                top: 17,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('${n.offset}', style: TextStyle(fontSize: 10)),
                ),
              ),
              //FlowFunctionSchems
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  spacing: 5,
                  children: [
                    ///отображаем шарики FlowFunctionSchema
                    ...n.nodeData.functions.map(
                      (h) => Badge(
                        backgroundColor: Colors.transparent,
                        smallSize: 12,
                        largeSize: 12,
                        alignment: const Alignment(1, -1.25),
                        padding: EdgeInsets.zero,
                        label: n.nodeData.functions.length > 1
                            ? InkWell(
                                onTap: () {
                                  if (n.nodeData.functions.length > 1) {
                                    n.nodeData.functions.removeWhere((e) => e == h);
                                    controller.update();
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                  child: const Icon(Icons.remove, color: Colors.white, size: 12),
                                ),
                              )
                            : SizedBox.shrink(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                          height: 23,
                          padding: EdgeInsets.all(3),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.setEdge(h.uuid, null);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                                  ),
                                  height: 20,
                                  width: 20,
                                  padding: EdgeInsets.all(3),
                                  child: h.handler.nextNodeUuid.isNotEmpty
                                      ? Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurpleAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ),
                              Positioned(bottom: 0, child: SizedBox(key: h.handler.key, width: 1, height: 1)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (n.nodeData.functions.length < 4) {
                            n.nodeData.functions.add(
                              FunctionSchema(
                                uuid: Uuid().v4(),
                                description: loc.descriptTaskForCompliting,
                                handler: HandlerModel(
                                  required: [],
                                  flowResultName: 'switch_to_${n.nodeData.functions.length}',
                                  properties: {},
                                ),
                              ),
                            );
                            controller.update();
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              //Плавающая точка входа в нод
              Positioned(
                top: 0,
                left: (n.width / 2) - 5,
                child: Container(key: n.key, color: Colors.transparent, width: 10, height: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

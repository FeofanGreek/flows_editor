import 'package:flutter/material.dart';
import '../../ui/widgets/node_draggable_plate.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../models/color_cycle.dart';
import '../widgets/bezie_painter.dart';
import '../widgets/edge_eraser.dart';

///Рабочая область редактирования flow
class NetworkLineRouter extends StatefulWidget {
  ///Рабочая область редактирования flow
  const NetworkLineRouter({super.key});

  @override
  State<NetworkLineRouter> createState() => NetworkLineRouterState();
}

///Рабочая область редактирования flow
class NetworkLineRouterState extends State<NetworkLineRouter> {
  @override
  void initState() {
    super.initState();

    final controller = context.read<FLowEditController>();

    // Откладываем вызов setRegion до конца текущего кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(listener);
      controller.setRegion(context);
    });
  }

  ///листенер обновления экрана
  void listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.read<AppStateController>();

    return SizedBox(
      width: MediaQuery.of(context).size.width - appState.leftSide,
      height: MediaQuery.of(context).size.height,
      child: Scrollbar(
        controller: appState.verticalScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: appState.verticalScrollController,
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            controller: appState.horizontalScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: appState.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.grey.withValues(alpha: 0.1),
                width: controller.region.width,
                height: controller.region.height,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (controller.region.width ~/ 50).round(),
                        (i) => VerticalDivider(width: 1, thickness: 0.3, color: Colors.grey),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (controller.region.height ~/ 50).round(),
                        (i) => Divider(height: 1, thickness: 0.3, color: Colors.grey),
                      ),
                    ),
                    // Слой для отрисовки пути
                    if (appState.horizontalScrollController.hasClients)
                      ...controller.edges.map(
                        (node) => IgnorePointer(
                          child: CustomPaint(
                            painter: HyperbolicCurvePainter(
                              start: node.$1 - Offset(appState.leftSide, 0),
                              end: node.$2 - Offset(appState.leftSide, 0),
                              hScrollPosition: appState.horizontalScrollController.position.pixels,
                              vScrollPosition: appState.verticalScrollController.position.pixels,
                              strokeWidth: 8,
                              color: ColorCycle.getColorByIndex(controller.edges.indexWhere((el) => el == node)),
                            ),
                          ),
                        ),
                      ),
                    if (appState.horizontalScrollController.hasClients)
                      ...controller.edges.map(
                        (node) => EdgeEraser(
                          start:
                              node.$1 -
                              Offset(appState.leftSide, 0) +
                              Offset(
                                appState.horizontalScrollController.position.pixels,
                                appState.verticalScrollController.position.pixels,
                              ),
                          end:
                              node.$2 -
                              Offset(appState.leftSide, 0) +
                              Offset(
                                appState.horizontalScrollController.position.pixels,
                                appState.verticalScrollController.position.pixels,
                              ),
                          onChanged: () {
                            final filteredNode = controller.nodes.firstWhere((e) => e.uuid == node.$4);
                            final filteredHandler = filteredNode.nodeData.functions.firstWhere(
                              (e) => e.handler.nextNodeUuid.contains(node.$3) && e.handler.getPosition() == node.$1,
                            );
                            filteredHandler.handler.nextNodeUuid.removeWhere((e) => e == node.$3);
                            controller.update();
                          },
                        ),
                      ),

                    ///Блоки нодов
                    ...controller.nodes.map((n) => NodeDraggablePlate(n: n)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

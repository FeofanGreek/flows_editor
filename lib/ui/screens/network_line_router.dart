import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/widgets/node_draggable_plate.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../models/color_cycle.dart';
import '../../models/net_cell.dart';
import '../../models/path_painter.dart';
import '../widgets/bezie_painter.dart';

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
                    //if (false)
                    // ...controller.edges.map(
                    //   (edge) => IgnorePointer(
                    //     child: CustomPaint(
                    //       painter: PathPainter(
                    //         vScrollPosition: appState.verticalScrollController.position.pixels,
                    //         hScrollPosition: appState.horizontalScrollController.position.pixels,
                    //         path: [edge.outPoint.getPosition()!, ...edge.line!, edge.inPoint.getPosition()!],
                    //         lineWidth: 8,
                    //         lineColor: ColorCycle.getColorByIndex(controller.edges.indexWhere((el) => el == edge)),
                    //       ),
                    //       size: Size(controller.region.width, controller.region.height),
                    //     ),
                    //   ),
                    // ),
                    if (true)
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
                    // ...controller.edges.map(
                    //   (edge) => IgnorePointer(
                    //     child: CustomPaint(
                    //       painter: HyperbolicCurvePainterPath(
                    //         offsets: edge.line!,
                    //         strokeWidth: 8,
                    //         color: ColorCycle.getColorByIndex(controller.edges.indexWhere((el) => el == edge)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    if (false)
                      ...controller.region.lineCells.map(
                        (c) => Positioned(
                          top: c.coords.dy,
                          left: c.coords.dx,
                          child: Container(
                            decoration: BoxDecoration(
                              color: c.bisy ? Colors.red.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
                              border: Border.all(),
                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                            ),
                            width: NetCell.size.width,
                            height: NetCell.size.height,
                          ),
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

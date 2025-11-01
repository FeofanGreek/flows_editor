import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/block_node.dart';
import 'circle_button.dart';

class ListNodesPlate extends StatelessWidget {
  const ListNodesPlate({super.key, required this.node, required this.index});

  final NodeBloc node;
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();
    final loc = AppLocalizations.of(context)!;
    return GestureDetector(
      // onTap: () => Navigator.of(
      //   context,
      // ).push(MaterialPageRoute(builder: (_) => NodeSettings(node: node))).whenComplete(() => controller.update()),
      onTap: () {
        appState.stage = FillStages.nodeSettings;
        appState.currentNodeBlock = node;
        controller.update();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        child: Row(
          spacing: 5,
          children: [
            Text(node.nodeData.name != '' ? node.nodeData.name : 'Нет названия', style: TextStyle(fontSize: 12)),
            Spacer(),
            CircleButton(
              onTap: () {
                controller.removeNode(index);
              },
              icon: Icons.delete_forever,
              color: Colors.red,
              tooltip: loc.removeNode,
            ),
            CircleButton(
              onTap: () {
                appState.stage = FillStages.nodeSettings;
                appState.currentNodeBlock = node;
                controller.update();
              },
              icon: Icons.edit,
              color: Colors.orange,
              tooltip: loc.editNode,
            ),
            SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}

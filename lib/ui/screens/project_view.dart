import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pipecatflowseditor/ui/screens/project_settings.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import 'action_settings.dart';
import 'flow_schema_settings.dart';
import 'network_line_router.dart';
import '../widgets/circle_button.dart';
import 'node_settings.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => ProjectViewState();
}

class ProjectViewState extends State<ProjectView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            switch (appState.stage) {
              FillStages.projectSettings => ProjectSettings(),
              FillStages.nodeSettings => NodeSettings(node: appState.currentNodeBlock!),
              FillStages.preActionSettings => ActionSettings(
                isPreAction: true,
                selectedAction: appState.currentAction!,
              ),
              FillStages.postActionSettings => ActionSettings(
                isPreAction: false,
                selectedAction: appState.currentAction!,
              ),
              FillStages.flowSchemaSettings => FlowSchemaSettings(selectedSchema: appState.currentSchema!),
            },
            Positioned(left: appState.leftSide, child: NetworkLineRouter()),
            Positioned(
              left: appState.leftSide - 5,
              top: MediaQuery.of(context).size.height / 2 - 25,
              child: GestureDetector(
                onHorizontalDragUpdate: (v) {
                  if (v.globalPosition.dx >= 400) {
                    appState.leftSide = v.globalPosition.dx;
                    setState(() {});
                  }
                },
                child: Container(
                  width: 10,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          CircleButton(onTap: () => controller.addNode(context), icon: CupertinoIcons.add, tooltip: 'Добавить узел'),
          CircleButton(
            onTap: () {
              appState.stage = FillStages.projectSettings;
              appState.currentAction = null;
              appState.currentSchema = null;
              controller.update();
            },
            icon: CupertinoIcons.gear,
            tooltip: loc.projectSettings,
          ),
        ],
      ),
    );
  }
}

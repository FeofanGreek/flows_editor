import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/circle_button.dart';
import '../widgets/list_nodes_plate.dart';
import '../widgets/text_field_gpt.dart';

class ProjectSettings extends StatefulWidget {
  const ProjectSettings({super.key});

  @override
  State<ProjectSettings> createState() => ProjectSettingsState();
}

class ProjectSettingsState extends State<ProjectSettings> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();
    final loc = AppLocalizations.of(context)!;

    return Container(
      constraints: BoxConstraints(minWidth: 400, maxWidth: appState.leftSide),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Row(
              spacing: 5,
              children: [
                CircleButton(onTap: () {}, icon: Icons.file_open, tooltip: loc.openSavedProject),
                CircleButton(
                  onTap: () {
                    appState.saveProject(controller.flowModel);
                  },
                  icon: Icons.save,
                  tooltip: loc.saveProject,
                ),
                CircleButton(onTap: () {}, icon: Icons.import_contacts, tooltip: loc.exportToPython),
                CircleButton(onTap: () {}, icon: Icons.explicit, tooltip: loc.importFromPython),
              ],
            ),
            Text(loc.shortProjectName, style: TextStyle(color: Colors.black, fontSize: 12)),
            TextFieldGpt(
              value: controller.flowModel.projectName,
              maxLength: 20,
              callBack: (String value) {
                controller.flowModel.projectName = value;
              },
              hintText: loc.shortProjectName,
              isNumber: false,
              onlyLatin: false,
            ),
            SizedBox(height: 5),
            Text(loc.projectDescription, style: TextStyle(color: Colors.black, fontSize: 12)),
            TextFieldGpt(
              value: controller.flowModel.projectDescription,
              callBack: (String value) {
                controller.flowModel.projectDescription = value;
              },
              hintText: loc.projectDescription,
              isNumber: false,
              onlyLatin: false,
            ),

            Divider(height: 15, thickness: 0.5, color: Colors.grey),
            Row(
              spacing: 5,
              children: [
                Text(loc.speechStages, style: TextStyle(fontSize: 12)),
                Spacer(),
                CircleButton(
                  onTap: () {
                    controller.addNode(context);
                    controller.update();
                  },
                  icon: CupertinoIcons.add,
                  tooltip: loc.addStage,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.flowModel.nodes.length,
                itemBuilder: (contxt, index) => ListNodesPlate(node: controller.flowModel.nodes[index], index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

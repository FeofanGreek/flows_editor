import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/flow_model.dart';
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
      key: Key('${controller.flowModel.latinName}project_setting'),
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
                CircleButton(
                  onTap: () async {
                    controller.flowModel = FlowModel(projectName: 'new_project', projectDescription: '');
                    controller.update();
                  },
                  icon: CupertinoIcons.doc,
                  tooltip: 'Новый проект',
                ),
                CircleButton(
                  onTap: () async {
                    //appState.verticalScrollController.dispose();
                    //appState.horizontalScrollController.dispose();
                    final pr = await appState.loadProject(context);
                    if (pr != null) {
                      controller.flowModel = pr;
                      controller.setRegion(context);
                      controller.update();
                    }
                  },
                  icon: Icons.file_open,
                  tooltip: loc.openSavedProject,
                ),
                CircleButton(
                  onTap: () {
                    appState.saveProject(controller.flowModel);
                  },
                  icon: Icons.save,
                  tooltip: loc.saveProject,
                ),
                CircleButton(onTap: () {}, icon: Icons.import_contacts, tooltip: loc.exportToPython),
                //CircleButton(onTap: () {}, icon: Icons.explicit, tooltip: loc.importFromPython),
                CircleButton(
                  onTap: () {
                    final prompt = controller.flowModel.toPrompt();
                    appState.savePrompt(prompt, controller.flowModel.latinName);
                  },
                  icon: Icons.schema_outlined,
                  tooltip: 'Create prompt for Claude',
                ),
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

            //Divider(height: 1, thickness: 0.5, color: Colors.grey),
            //SizedBox(height: 10),
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
              child: ReorderableListView(
                shrinkWrap: true,
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = controller.flowModel.nodes.removeAt(oldIndex);
                    controller.flowModel.nodes.insert(newIndex, item);
                  });
                },
                children: List.generate(
                  controller.flowModel.nodes.length,
                  (index) => ListNodesPlate(key: Key('$index'), node: controller.flowModel.nodes[index], index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

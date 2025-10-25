import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
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
                CircleButton(onTap: () {}, icon: Icons.file_open, tooltip: 'Load project'),
                CircleButton(
                  onTap: () {
                    appState.saveProject(controller.flowModel);
                  },
                  icon: Icons.save,
                  tooltip: 'Save project',
                ),
                CircleButton(onTap: () {}, icon: Icons.import_contacts, tooltip: 'Export to Python'),
                CircleButton(onTap: () {}, icon: Icons.explicit, tooltip: 'Import from Python'),
              ],
            ),
            Text('Short project name', style: TextStyle(color: Colors.black, fontSize: 12)),
            TextFieldGpt(
              value: controller.flowModel.projectName,
              maxLength: 20,
              callBack: (String value) {
                controller.flowModel.projectName = value;
              },
            ),
            SizedBox(height: 5),
            Text('Project description', style: TextStyle(color: Colors.black, fontSize: 12)),
            TextFieldGpt(
              value: controller.flowModel.projectDescription,
              callBack: (String value) {
                controller.flowModel.projectDescription = value;
              },
            ),

            Divider(height: 15, thickness: 0.5, color: Colors.grey),
            Row(
              spacing: 5,
              children: [
                Text('Speech stages', style: TextStyle(fontSize: 12)),
                Spacer(),
                CircleButton(
                  onTap: () {
                    controller.addNode(context);
                    controller.update();
                  },
                  icon: CupertinoIcons.add,
                  tooltip: 'Add stage',
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

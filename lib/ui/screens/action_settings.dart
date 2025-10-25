import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../models/action_model.dart' as action;
import '../../utils/enums_lib.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/text_field_gpt.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';

class ActionSettings extends StatefulWidget {
  const ActionSettings({super.key, required this.isPreAction, required this.selectedAction});

  final bool isPreAction;
  final action.Action selectedAction;

  @override
  State<ActionSettings> createState() => ActionSettingsState();
}

class ActionSettingsState extends State<ActionSettings> {
  final codeController = CodeController(
    text: '''async def complete_intake(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
    """Handler to complete the intake process."""
    return None, create_end_node()''', // Initial code
    language: python,
  );

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
              children: [
                IconButton(
                  onPressed: () {
                    appState.stage = FillStages.nodeSettings;
                    appState.currentAction = null;
                    controller.update();
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                Text('Назад'),
                Spacer(),
              ],
            ),
            Text('Выберите тип действия', style: TextStyle(color: Colors.black, fontSize: 12)),
            DropDownMenu<ActionTypes>(
              selectedItem: widget.selectedAction.type,
              items: ActionTypes.values,
              onChanged: (ActionTypes? value) {
                widget.selectedAction.type = value!;
                setState(() {});
              },
              getTitle: (ActionTypes value) => value.description,
            ),
            //widget.selectedAction.text
            switch (widget.selectedAction.type) {
              ActionTypes.tts_say => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text('Фраза, которую произнесет бот', style: TextStyle(color: Colors.black, fontSize: 12)),
                  TextFieldGpt(
                    value: widget.selectedAction.text ?? '',
                    maxLength: 20,
                    callBack: (String value) {
                      widget.selectedAction.text = value;
                    },
                  ),
                ],
              ),
              ActionTypes.end_conversation => SizedBox(),
              ActionTypes.function => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    'Название функции и ее код на Python, которую выполнит бот',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  TextFieldGpt(
                    value: widget.selectedAction.handlerName ?? '',
                    maxLength: 20,
                    callBack: (String value) {
                      widget.selectedAction.handlerName = value;
                    },
                  ),
                  CodeTheme(
                    data: CodeThemeData(styles: monokaiSublimeTheme),
                    child: SingleChildScrollView(
                      child: CodeField(
                        controller: codeController,
                        textStyle: TextStyle(fontSize: 12),
                        onChanged: (value) => widget.selectedAction.codeSnipet = value,
                      ),
                    ),
                  ),
                ],
              ),
            },
            //widget.selectedAction.handlerName
            //widget.selectedAction.
          ],
        ),
      ),
    );
  }
}

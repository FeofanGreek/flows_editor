import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../models/action_model.dart' as action;
import '../../models/flow_function_schema.dart';
import '../../utils/enums_lib.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/text_field_gpt.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';

class FlowSchemaSettings extends StatefulWidget {
  const FlowSchemaSettings({super.key, required this.selectedSchema});

  final FunctionSchema selectedSchema;

  @override
  State<FlowSchemaSettings> createState() => FlowSchemaSettingsState();
}

class FlowSchemaSettingsState extends State<FlowSchemaSettings> {
  final controller = CodeController(
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
                    appState.currentSchema = null;
                    controller.update();
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                Text('Назад'),
                Spacer(),
              ],
            ),
            Text('Описание схемы узла', style: TextStyle(color: Colors.black, fontSize: 12)),
            TextFieldGpt(
              value: widget.selectedSchema.description,
              maxLength: 20,
              callBack: (String value) {
                widget.selectedSchema.description = value;
              },
            ),
            Text('Обработчик события', style: TextStyle(color: Colors.black, fontSize: 12)),
            //widget.selectedSchema.handler
            Text(
              'Описание ожидаемых паарметров для передачи в LLM',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            //widget.selectedSchema.properties
            Text(
              'Какие параметры требуется извлечь из разговора, чтоб продолжить flow',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            //widget.selectedSchema.required
          ],
        ),
      ),
    );
  }
}

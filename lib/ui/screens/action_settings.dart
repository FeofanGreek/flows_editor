import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
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
  String codeSnipet = '''#[START section1]
async def yor_action_func_name(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
#[END section1]
    """Handler to complete the intake process."""
    #[START section2] return None, create_end_node()#[END section2]''';

  late CodeController codeController;

  @override
  void initState() {
    codeSnipet =
        '''#[START section1]
async def ${widget.selectedAction.handlerName}(action: dict, flow_manager: FlowManager) -> None:
        #[END section1]
    """Handler to complete the intake process."""''';
    codeController = CodeController(
      text: codeSnipet,
      language: python,
      namedSectionParser: const BracketsStartEndNamedSectionParser(),
    );
    codeController.readOnlySectionNames = {'section1', 'section2'};
    //print(codeController.code.namedSections);
    super.initState();
  }

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
            InkWell(
              onTap: () {
                appState.stage = FillStages.nodeSettings;
                appState.currentAction = null;
                controller.update();
              },
              child: Row(children: [Icon(Icons.arrow_back_ios_new), Text(loc.back), Spacer()]),
            ),
            Text(loc.selectActionType, style: TextStyle(color: Colors.black, fontSize: 12)),
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
                  Text(loc.phraseWichBotSayFirst, style: TextStyle(color: Colors.black, fontSize: 12)),
                  TextFieldGpt(
                    value: widget.selectedAction.text ?? '',
                    maxLength: 20,
                    callBack: (String value) {
                      widget.selectedAction.text = value;
                    },
                    hintText: loc.phraseWichBotSayFirst,
                    isNumber: false,
                    onlyLatin: false,
                  ),
                ],
              ),
              ActionTypes.end_conversation => SizedBox(),
              ActionTypes.function => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(loc.nameFunctionAndPythonCode, style: TextStyle(color: Colors.black, fontSize: 12)),
                  TextFieldGpt(
                    value: widget.selectedAction.handlerName ?? '',
                    maxLength: 20,
                    callBack: (String value) {
                      widget.selectedAction.handlerName = value;
                      String updated = codeSnipet.replaceAll(
                        RegExp(r'(#\[START section1\]).*?(#\[END section1\])', dotAll: true),
                        '''#[START section1] 
async def $value(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]: 
                        #[END section1]''',
                      );
                      codeController = CodeController(
                        text: updated,
                        language: python,
                        namedSectionParser: const BracketsStartEndNamedSectionParser(),
                      );
                      setState(() {});
                    },
                    hintText: loc.nameOfFunction,
                    isNumber: false,
                    onlyLatin: true,
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
          ],
        ),
      ),
    );
  }
}

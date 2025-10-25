import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../models/action_model.dart' as action;
import '../../models/flow_function_schema.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';
import '../../models/flowschema_properties_models/string_property_model.dart';
import '../../utils/enums_lib.dart';
import '../widgets/array_property_widget.dart';
import '../widgets/circle_button.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/number_property_widget.dart';
import '../widgets/string_property_widget.dart';
import '../widgets/text_field_gpt.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/json.dart';

class FlowSchemaSettings extends StatefulWidget {
  const FlowSchemaSettings({super.key, required this.selectedSchema});

  final FunctionSchema selectedSchema;

  @override
  State<FlowSchemaSettings> createState() => FlowSchemaSettingsState();
}

class FlowSchemaSettingsState extends State<FlowSchemaSettings> {
  String codeSnipet = '''#[START section1]
async def yor_action_func_name(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
#[END section1]
    """Handler to complete the intake process."""
    #[START section2] return None, create_end_node()#[END section2]''';

  String jsonCodeSnipet = '''
   {
              "size": {
                  "type": "string",
                  "enum": ["small", "medium", "large"],
                  "description": "Size of the pizza",
              },
              "type_pizza": {
                  "type": "string",
                  "enum": ["pepperoni", "cheese", "supreme", "vegetarian"],
                  "description": "Type of pizza",
              },
          }
    ''';

  late CodeController codeController;

  late CodeController jsonParamsController;

  @override
  void initState() {
    codeSnipet = '''#[START section1]
async def ЧЕ ТО НАПИСАТЬ(action: dict, flow_manager: FlowManager) -> None:
        #[END section1]
    """Handler to complete the intake process."""''';

    codeController = CodeController(
      text: codeSnipet,
      language: python,
      namedSectionParser: const BracketsStartEndNamedSectionParser(),
    );
    codeController.readOnlySectionNames = {'section1', 'section2'};

    jsonParamsController = CodeController(
      text: jsonCodeSnipet,
      language: json,
      namedSectionParser: const BracketsStartEndNamedSectionParser(),
    );
    super.initState();
  }

  List properties = [];

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
            InkWell(
              onTap: () {
                appState.stage = FillStages.nodeSettings;
                appState.currentSchema = null;
                controller.update();
              },
              child: Row(children: [Icon(Icons.arrow_back_ios_new), Text('Back'), Spacer()]),
            ),
            Text('Schema description for LLM', style: TextStyle(color: Colors.black, fontSize: 12)),
            TextFieldGpt(
              value: widget.selectedSchema.description,
              maxLength: 20,
              callBack: (String value) {
                widget.selectedSchema.description = value;
              },
            ),
            Row(
              children: [
                Text('Schema properties', style: TextStyle(color: Colors.black, fontSize: 12)),
                Spacer(),
                CircleButton(
                  onTap: () {
                    setState(() {
                      properties.add(null);
                    });
                  },
                  icon: CupertinoIcons.add,
                  tooltip: 'Add propierty',
                ),
              ],
            ),
            Divider(height: 1, thickness: 0.3, color: Colors.grey),
            if (properties.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: properties.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => switch (properties[index]) {
                  null => DropDownMenu(
                    selectedItem: properties[index],
                    items: [ArrayPropertyModel, NumberPropertyModel, StringPropertyModel],
                    onChanged: (value) {
                      properties[index] = value;
                      setState(() {});
                    },
                    getTitle: (type) {
                      switch (type) {
                        case StringPropertyModel:
                          return 'Текстовое значение';
                        case NumberPropertyModel:
                          return 'Числовое значение';
                        case ArrayPropertyModel:
                          return 'Список';
                        default:
                          return 'Not selected';
                      }
                    },
                  ),
                  StringPropertyModel => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Text('Текстовое значение'),
                            Spacer(),
                            CircleButton(
                              onTap: () {
                                setState(() {
                                  properties.removeAt(index);
                                });
                              },
                              icon: CupertinoIcons.minus,
                              tooltip: 'Remove propierty',
                            ),
                          ],
                        ),
                      ),
                      StringPropertyWidget(setProperty: (StringPropertyModel p1) {}),
                    ],
                  ),
                  NumberPropertyModel => Column(
                    children: [
                      Row(
                        children: [
                          Text('Числовое значение'),
                          Spacer(),
                          CircleButton(
                            onTap: () {
                              setState(() {
                                properties.removeAt(index);
                              });
                            },
                            icon: CupertinoIcons.minus,
                            tooltip: 'Remove propierty',
                          ),
                        ],
                      ),
                      NumberPropertyWidget(setProperty: (NumberPropertyModel p1) {}),
                    ],
                  ),
                  ArrayPropertyModel => Column(
                    children: [
                      Row(
                        children: [
                          Text('Список'),
                          Spacer(),
                          CircleButton(
                            onTap: () {
                              setState(() {
                                properties.removeAt(index);
                              });
                            },
                            icon: CupertinoIcons.minus,
                            tooltip: 'Remove propierty',
                          ),
                        ],
                      ),
                      ArrayPropertyWidget(setProperty: (ArrayPropertyModel p1) {}),
                    ],
                  ),
                  _ => SizedBox(),
                },
              ),

            // Text('Schema handler', style: TextStyle(color: Colors.black, fontSize: 12)),
            // Divider(height: 1, thickness: 0.3, color: Colors.grey),
            //
            // Text('Schema parameters', style: TextStyle(color: Colors.black, fontSize: 12)),
            // CodeTheme(
            //   data: CodeThemeData(styles: monokaiSublimeTheme),
            //   child: SingleChildScrollView(
            //     child: CodeField(
            //       controller: jsonParamsController,
            //       textStyle: TextStyle(fontSize: 12),
            //       onChanged: (value) {
            //         print(value);
            //       },
            //     ),
            //   ),
            // ),
            // Text('Required parameters', style: TextStyle(color: Colors.black, fontSize: 12)),

            // Text(
            //   '${(jsonDecode(jsonEncode(jsonParamsController.code.text.replaceAll('\n', '').trim())) as Map).keys.toList()}',
            // ),
            // Text('Python code', style: TextStyle(color: Colors.black, fontSize: 12)),
            // CodeTheme(
            //   data: CodeThemeData(styles: monokaiSublimeTheme),
            //   child: SingleChildScrollView(
            //     child: CodeField(
            //       controller: codeController,
            //       textStyle: TextStyle(fontSize: 12),
            //       onChanged: (value) {
            //         print(value);
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

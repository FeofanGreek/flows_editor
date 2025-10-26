import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/flow_function_schema.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';
import '../../models/flowschema_properties_models/string_property_model.dart';
import '../widgets/add_properties_dialog.dart';
import '../widgets/circle_button.dart';
import '../widgets/string_property_widget.dart';
import '../widgets/text_field_gpt.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
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
    widget.selectedSchema.handler.properties = {
      "user_email": {
        "type": "string",
        "format": "email",
        "description": "Почтовый адрес пользователя для отправки чека.",
      },
      // "age": {
      //   "type": "integer",
      //   "minimum": 18,
      //   "maximum": 120,
      //   "description": "Возраст пользователя, должно быть целое число от 18 до 120.",
      // },
      // "add_ons": {
      //   "type": "array",
      //   "items": {
      //     "type": "string",
      //     "enum": ["extra_cheese", "mushrooms", "olives"],
      //   },
      //   "description": "Список дополнительных ингредиентов.",
      // },
    };
    setProperties();
  }

  List properties = [];

  //если параметры уже были установлены, доабвим их в виджет
  void setProperties() {
    for (final key in widget.selectedSchema.handler.properties.keys) {
      switch (widget.selectedSchema.handler.properties[key]['type']) {
        case 'array':
          properties.add(ArrayPropertyModel);
        case 'integer':
          properties.add(NumberPropertyModel);
        case 'string':
          {
            final prop = StringPropertyModel.fromJson(widget.selectedSchema.handler.properties[key]);
            prop.key = key;
            properties.add(prop);
          }
      }
    }
    setState(() {});
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
        child: SingleChildScrollView(
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
                child: Row(children: [Icon(Icons.arrow_back_ios_new), Text(loc.back), Spacer()]),
              ),
              Text(loc.schemaDescriptionForLLM, style: TextStyle(color: Colors.black, fontSize: 12)),
              TextFieldGpt(
                value: widget.selectedSchema.description,
                callBack: (String value) {
                  widget.selectedSchema.description = value;
                },
                hintText: loc.description,
                isNumber: false,
                onlyLatin: false,
              ),
              Row(
                children: [
                  Text(loc.schemaPropities, style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () async {
                      final result = await showAddPropertyDialog(context);
                      print(result);
                      widget.selectedSchema.handler.properties[result['key']] = result;
                      controller.update();
                    },
                    icon: CupertinoIcons.add,
                    tooltip: loc.addProperty,
                  ),
                ],
              ),
              Divider(height: 1, thickness: 0.3, color: Colors.grey),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.selectedSchema.handler.properties.entries.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String key = widget.selectedSchema.handler.properties.entries.toList()[index].key;
                  final prop = widget.selectedSchema.handler.properties;
                  switch (prop[key]['type']) {
                    case 'array':
                      return StringPropertyWidget(
                        setProperty: (StringPropertyModel p) {},
                        property: StringPropertyModel.fromJson(prop[key]),
                        removeProperty: (StringPropertyModel p) {},
                      );
                    case 'integer':
                      return StringPropertyWidget(
                        setProperty: (StringPropertyModel p) {},
                        property: StringPropertyModel.fromJson(prop[key]),
                        removeProperty: (StringPropertyModel p) {},
                      );
                    case 'string':
                      final _prop = StringPropertyModel.fromJson(prop[key]);
                      _prop.key = key;
                      return StringPropertyWidget(
                        setProperty: (StringPropertyModel p) {},
                        property: _prop,
                        removeProperty: (StringPropertyModel p) {},
                      );
                  }
                },
              ),

              //   ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: properties.length,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) => switch (properties[index]) {
              //       StringPropertyModel => StringPropertyWidget(
              //         setProperty: (StringPropertyModel p) {
              //           widget.selectedSchema.handler.properties[p.key] = p.toJson();
              //           controller.update();
              //         },
              //         property: properties[index],
              //         removeProperty: (StringPropertyModel p) {
              //           properties.removeAt(index);
              //           widget.selectedSchema.handler.properties[p.key] = null;
              //           controller.update();
              //         },
              //       ),
              //       NumberPropertyModel => Column(
              //         children: [
              //           Row(
              //             children: [
              //               Text(loc.integerValue),
              //               Spacer(),
              //               CircleButton(
              //                 onTap: () {
              //                   setState(() {
              //                     properties.removeAt(index);
              //                   });
              //                 },
              //                 icon: CupertinoIcons.minus,
              //                 tooltip: loc.removeProperty,
              //               ),
              //             ],
              //           ),
              //           NumberPropertyWidget(setProperty: (NumberPropertyModel p1) {}),
              //         ],
              //       ),
              //       ArrayPropertyModel => Column(
              //         children: [
              //           Row(
              //             children: [
              //               Text(loc.listValue),
              //               Spacer(),
              //               CircleButton(
              //                 onTap: () {
              //                   setState(() {
              //                     properties.removeAt(index);
              //                   });
              //                 },
              //                 icon: CupertinoIcons.minus,
              //                 tooltip: loc.removeProperty,
              //               ),
              //             ],
              //           ),
              //           ArrayPropertyWidget(setProperty: (ArrayPropertyModel p1) {}),
              //         ],
              //       ),
              //       _ => DropDownMenu(
              //         selectedItem: properties[index],
              //         items: [ArrayPropertyModel, NumberPropertyModel, StringPropertyModel],
              //         onChanged: (value) {
              //           properties[index] = value == StringPropertyModel ? StringPropertyModel.empty() : value;
              //           setState(() {});
              //         },
              //         getTitle: (type) {
              //           switch (type) {
              //             case StringPropertyModel:
              //               return loc.textValue;
              //             case NumberPropertyModel:
              //               return loc.integerValue;
              //             case ArrayPropertyModel:
              //               return loc.listValue;
              //             default:
              //               return loc.notSelected;
              //           }
              //         },
              //       ),
              //     },
              //   ),

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
      ),
    );
  }
}

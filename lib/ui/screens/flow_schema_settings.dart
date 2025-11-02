import 'package:PipeCatFlowEditor/utils/list_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/addon_properties_model.dart';
import '../../models/flow_function_schema.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';
import '../../models/flowschema_properties_models/string_property_model.dart';
import '../../utils/enums_lib.dart';
import '../widgets/add_properties_dialog.dart';
import '../widgets/array_property_widget.dart';
import '../widgets/circle_button.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/elevated_round_button.dart';
import '../widgets/number_property_widget.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();
    final loc = AppLocalizations.of(context)!;
    return Container(
      key: Key('${controller.flowModel.latinName}flow_schema_setting'),
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
                child: Row(
                  children: [Icon(Icons.arrow_back_ios_new), Text(loc.back), Spacer(), Text('FlowFunctionSchema')],
                ),
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
                      if (result.isNotEmpty) widget.selectedSchema.handler.properties[result['key']] = result;
                      controller.update();
                    },
                    icon: CupertinoIcons.add,
                    tooltip: loc.addProperty,
                  ),
                ],
              ),
              Divider(height: 1, thickness: 0.3, color: Colors.grey),
              if (widget.selectedSchema.handler.properties.isEmpty)
                Text('Не определено ни одного параметра для схемы', style: TextStyle(color: Colors.red, fontSize: 12)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.selectedSchema.handler.properties.entries.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String key = widget.selectedSchema.handler.properties.entries.toList()[index].key;
                  final prop = widget.selectedSchema.handler.properties;
                  //print(widget.selectedSchema.handler.properties);
                  switch (prop[key]['type']) {
                    case 'array':
                      final prop0 = ArrayPropertyModel.fromJson(prop[key]);
                      prop0.key = key;
                      return ArrayPropertyWidget(
                        setProperty: (ArrayPropertyModel p) {
                          if (widget.selectedSchema.handler.required.contains(p.key)) {
                            widget.selectedSchema.handler.required.removeWhere((k) => k == p.key);
                          } else {
                            widget.selectedSchema.handler.required.add(p.key);
                          }
                          controller.update();
                        },
                        property: prop0,
                        removeProperty: (ArrayPropertyModel p) {
                          prop.remove(key);
                          widget.selectedSchema.handler.required.removeWhere((k) => k == p.key);
                          controller.update();
                        },
                        required: widget.selectedSchema.handler.required,
                      );
                    case 'integer':
                      final prop0 = NumberPropertyModel.fromJson(prop[key]);
                      prop0.key = key;
                      return NumberPropertyWidget(
                        setProperty: (NumberPropertyModel p) {
                          if (widget.selectedSchema.handler.required.contains(p.key)) {
                            widget.selectedSchema.handler.required.removeWhere((k) => k == p.key);
                          } else {
                            widget.selectedSchema.handler.required.add(p.key);
                          }
                          controller.update();
                        },
                        property: prop0,
                        removeProperty: (NumberPropertyModel p) {
                          prop.remove(key);
                          widget.selectedSchema.handler.required.removeWhere((k) => k == p.key);
                          controller.update();
                        },
                        required: widget.selectedSchema.handler.required,
                      );
                    case 'string':
                      final prop0 = StringPropertyModel.fromJson(prop[key]);
                      prop0.key = key;
                      return StringPropertyWidget(
                        setProperty: (StringPropertyModel p) {
                          if (widget.selectedSchema.handler.required.contains(p.key)) {
                            widget.selectedSchema.handler.required.removeWhere((k) => k == p.key);
                          } else {
                            widget.selectedSchema.handler.required.add(p.key);
                          }
                          controller.update();
                        },
                        property: prop0,
                        removeProperty: (StringPropertyModel p) {
                          prop.remove(key);
                          widget.selectedSchema.handler.required.removeWhere((k) => k == p.key);
                          controller.update();
                        },
                        required: widget.selectedSchema.handler.required,
                      );
                  }
                  return null;
                },
              ),

              Text('FlowResult class конструктор', style: TextStyle(color: Colors.black, fontSize: 12)),
              Divider(height: 1, thickness: 0.3, color: Colors.grey),
              // ...widget.selectedSchema.handler.properties.entries.map(
              //   (el) => Row(spacing: 5, children: [Text(el.key), Text(el.value['type'].toString())]),
              // ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.selectedSchema.handler.addonProperties.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 40,
                  width: appState.leftSide,
                  child: Row(
                    spacing: 5,
                    children: [
                      DropDownMenu<VariableTypes>(
                        selectedItem:
                            VariableTypes.values.firstWhereOrNull(
                              (e) => e == widget.selectedSchema.handler.addonProperties[index].type,
                            ) ??
                            VariableTypes.string,
                        items: VariableTypes.values,
                        onChanged: (value) {
                          widget.selectedSchema.handler.addonProperties[index].type = value!;
                          setState(() {});
                        },
                        getTitle: (type) {
                          return type.json;
                        },
                      ),
                      Expanded(
                        child: TextFieldGpt(
                          value: widget.selectedSchema.handler.addonProperties[index].name,
                          callBack: (String p1) {
                            widget.selectedSchema.handler.addonProperties[index].name = p1;
                          },
                          hintText: loc.listValues,
                          maxLength: 20,
                          isNumber: false,
                          onlyLatin: true,
                        ),
                      ),
                      CircleButton(
                        onTap: () {
                          widget.selectedSchema.handler.addonProperties.removeWhere(
                            (e) => e == widget.selectedSchema.handler.addonProperties[index],
                          );
                          setState(() {});
                        },
                        icon: Icons.delete_forever,
                        color: Colors.red,
                        tooltip: loc.removeProperty,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: appState.leftSide,
                child: ElevatedRoundButton(
                  title: 'Добавить параметр',
                  onPressed: () async {
                    widget.selectedSchema.handler.addonProperties.add(
                      AddonPropertiesModel(name: 'new_parameter', type: VariableTypes.string),
                    );
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

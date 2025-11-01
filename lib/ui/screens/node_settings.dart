import 'package:flutter/material.dart';
import '../../models/flow_function_schema.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/block_node.dart';
import '../../models/handler_model.dart';
import '../../models/message_model.dart';
import '../../utils/enums_lib.dart';
import '../widgets/action_plate.dart';
import '../widgets/check_box_widget.dart';
import '../widgets/circle_button.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/schema_plate.dart';
import '../widgets/text_field_gpt.dart';
import '../../models/action_model.dart' as action;

class NodeSettings extends StatefulWidget {
  const NodeSettings({super.key, required this.node});
  final NodeBloc node;

  @override
  State<NodeSettings> createState() => NodeSettingsState();
}

class NodeSettingsState extends State<NodeSettings> {
  bool extendedSettings = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();
    final loc = AppLocalizations.of(context)!;

    return Container(
      constraints: BoxConstraints(minWidth: 400, maxWidth: appState.leftSide),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              InkWell(
                onTap: () {
                  appState.stage = FillStages.projectSettings;
                  appState.currentAction = null;
                  appState.currentSchema = null;
                  controller.update();
                },
                child: Row(children: [Icon(Icons.arrow_back_ios_new), Text(loc.back), Spacer()]),
              ),
              Text(loc.nodeName, style: TextStyle(color: Colors.black, fontSize: 12)),
              TextFieldGpt(
                value: widget.node.nodeData.name,
                maxLength: 20,
                callBack: (String value) {
                  widget.node.nodeData.name = value;
                  setState(() {});
                },
                hintText: loc.nodeName,
                isNumber: false,
                onlyLatin: false,
              ),
              SizedBox(height: 5),
              Text(loc.nodeDescription, style: TextStyle(color: Colors.black, fontSize: 12)),
              TextFieldGpt(
                value: widget.node.nodeData.description,
                callBack: (String value) {
                  widget.node.nodeData.description = value;
                  setState(() {});
                },
                hintText: loc.nodeDescription,
                isNumber: false,
                onlyLatin: false,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(loc.extendedSettings),
                  Expanded(child: Divider(height: 1, thickness: 0.3, color: Colors.black, endIndent: 10, indent: 10)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        extendedSettings = !extendedSettings;
                      });
                    },
                    child: Icon(!extendedSettings ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up),
                  ),
                ],
              ),
              if (extendedSettings) ...[
                CheckBoxWidget(
                  currentValue: widget.node.nodeData.respondImmediately,
                  onChanged: (value) {
                    widget.node.nodeData.respondImmediately = value ?? false;
                    controller.update();
                  },
                  title: loc.runWithoutWaitingUserAction,
                ),
                SizedBox(height: 5),
                Text(loc.contextProcessingStrategy, style: TextStyle(color: Colors.black, fontSize: 12)),
                DropDownMenu<ContextStrategy>(
                  selectedItem: widget.node.nodeData.context_strategy,
                  items: ContextStrategy.values,
                  onChanged: (ContextStrategy? value) {
                    widget.node.nodeData.context_strategy = value ?? ContextStrategy.APPEND;
                    controller.update();
                  },
                  getTitle: (ContextStrategy value) {
                    switch (value) {
                      case ContextStrategy.APPEND:
                        return loc.accumulateContext;
                      case ContextStrategy.RESET:
                        return loc.resetContext;
                      case ContextStrategy.RESET_WITH_SUMMARY:
                        return loc.useSomeHistory;
                    }
                  },
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(loc.actionRuningBeforeRuningNode, style: TextStyle(color: Colors.black, fontSize: 12)),
                    Spacer(),
                    CircleButton(
                      onTap: () {
                        if (widget.node.nodeData.preActions.length < 4) {
                          widget.node.nodeData.preActions.add(action.Action(type: ActionTypes.function));
                          setState(() {});
                        }
                      },
                      icon: CupertinoIcons.add,
                      tooltip: loc.addPreAction,
                    ),
                  ],
                ),
                Wrap(
                  children: widget.node.nodeData.preActions
                      .map(
                        (a) => ActionPlate(
                          a: a,
                          onTap: () {
                            appState.stage = FillStages.preActionSettings;
                            appState.currentAction = a;
                            controller.update();
                          },
                          remove: () {
                            widget.node.nodeData.preActions.removeWhere((ac) => ac == a);
                            controller.update();
                          },
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(loc.systemInstructionForLLM, style: TextStyle(color: Colors.black, fontSize: 12)),
                    Spacer(),
                    CircleButton(
                      onTap: () {
                        if (widget.node.nodeData.roleMessage == null) {
                          widget.node.nodeData.roleMessage = Message(
                            role: 'system',
                            content: loc.instructionForYourLLM,
                          );
                        } else {
                          widget.node.nodeData.roleMessage = null;
                        }
                        controller.update();
                      },
                      icon: widget.node.nodeData.roleMessage == null ? CupertinoIcons.add : CupertinoIcons.clear,
                      tooltip: widget.node.nodeData.roleMessage == null
                          ? loc.addSystemInstruction
                          : loc.removeSystemInstruction,
                    ),
                  ],
                ),
                if (widget.node.nodeData.roleMessage != null)
                  TextFieldGpt(
                    value: widget.node.nodeData.roleMessage!.content,
                    callBack: (String value) {
                      widget.node.nodeData.roleMessage!.content = value;
                    },
                    hintText: loc.instructionText,
                    isNumber: false,
                    onlyLatin: false,
                  ),
                SizedBox(height: 5),
                Text(loc.targetOnThisStage, style: TextStyle(color: Colors.black, fontSize: 12)),
                TextFieldGpt(
                  value: widget.node.nodeData.taskMessage.content,
                  callBack: (String value) {
                    widget.node.nodeData.taskMessage.content = value;
                  },
                  hintText: loc.targetDescription,
                  isNumber: false,
                  onlyLatin: true,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text(loc.routingSchemeForSwitching, style: TextStyle(color: Colors.black, fontSize: 12)),
                    Spacer(),
                    CircleButton(
                      onTap: () {
                        if (widget.node.nodeData.functions.length < 4) {
                          widget.node.nodeData.functions.add(
                            FunctionSchema(
                              description: loc.descriptTaskForCompliting,
                              handler: HandlerModel(
                                flowResultName: 'switch_to_${widget.node.nodeData.functions.length}',
                                required: [],
                                properties: {},
                              ),
                              uuid: Uuid().v4(),
                            ),
                          );
                          controller.update();
                        }
                      },
                      icon: CupertinoIcons.add,
                      tooltip: loc.addFlow,
                    ),
                  ],
                ),
                Wrap(
                  children: widget.node.nodeData.functions
                      .map(
                        (a) => SchemaPlate(
                          a: a,
                          onTap: () {
                            appState.stage = FillStages.flowSchemaSettings;
                            appState.currentSchema = a;
                            controller.update();
                          },
                          remove: () {
                            widget.node.nodeData.functions.removeWhere((ac) => ac == a);
                            controller.update();
                          },
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(loc.actionsBeforeSwitching, style: TextStyle(color: Colors.black, fontSize: 12)),
                    ),
                    Spacer(),
                    CircleButton(
                      onTap: () {
                        if (widget.node.nodeData.postActions.length < 4) {
                          widget.node.nodeData.postActions.add(action.Action(type: ActionTypes.end_conversation));
                          controller.update();
                        }
                      },
                      icon: CupertinoIcons.add,
                      tooltip: loc.addPostAction,
                    ),
                  ],
                ),
                Wrap(
                  children: widget.node.nodeData.postActions
                      .map(
                        (a) => ActionPlate(
                          a: a,
                          onTap: () {
                            appState.stage = FillStages.postActionSettings;
                            appState.currentAction = a;
                            controller.update();
                          },
                          remove: () {
                            widget.node.nodeData.postActions.removeWhere((ac) => ac == a);
                            controller.update();
                          },
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 5),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

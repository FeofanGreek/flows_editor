import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/models/flow_function_schema.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
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
import 'action_settings.dart';
import 'flow_schema_settings.dart';

class NodeSettings extends StatefulWidget {
  const NodeSettings({super.key, required this.node});
  final NodeBloc node;

  @override
  State<NodeSettings> createState() => NodeSettingsState();
}

class NodeSettingsState extends State<NodeSettings> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();

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
                child: Row(children: [Icon(Icons.arrow_back_ios_new), Text('Back'), Spacer()]),
              ),
              Text('Node name', style: TextStyle(color: Colors.black, fontSize: 12)),
              TextFieldGpt(
                value: widget.node.nodeData.name,
                maxLength: 20,
                callBack: (String value) {
                  widget.node.nodeData.name = value;
                  setState(() {});
                },
              ),
              SizedBox(height: 5),
              CheckBoxWidget(
                currentValue: widget.node.nodeData.respondImmediately,
                onChanged: (value) {
                  widget.node.nodeData.respondImmediately = value ?? false;
                  controller.update();
                },
                title: 'Run node without waiting user action',
              ),
              SizedBox(height: 5),
              Text('Context processing strategy', style: TextStyle(color: Colors.black, fontSize: 12)),
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
                      return 'Accumulate context';
                    case ContextStrategy.RESET:
                      return 'Reset context';
                    case ContextStrategy.RESET_WITH_SUMMARY:
                      return 'Use some of previos context history';
                  }
                },
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Action runing before run node', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.preActions.length < 4) {
                        widget.node.nodeData.preActions.add(action.Action(type: ActionTypes.function));
                        setState(() {});
                      }
                    },
                    icon: CupertinoIcons.add,
                    tooltip: 'Add pre action',
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
                  Text('System instruction for LLM', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.roleMessage == null) {
                        widget.node.nodeData.roleMessage = Message(
                          role: 'system',
                          content: 'Instruction for yuor LLM, where you set scenario of this node',
                        );
                      } else {
                        widget.node.nodeData.roleMessage = null;
                      }
                      controller.update();
                    },
                    icon: widget.node.nodeData.roleMessage == null ? CupertinoIcons.add : CupertinoIcons.clear,
                    tooltip: widget.node.nodeData.roleMessage == null
                        ? 'Add system instruction'
                        : 'Remove system instruction',
                  ),
                ],
              ),
              if (widget.node.nodeData.roleMessage != null)
                TextFieldGpt(
                  value: widget.node.nodeData.roleMessage!.content,
                  maxLength: 20,
                  callBack: (String value) {
                    widget.node.nodeData.roleMessage!.content = value;
                  },
                ),
              SizedBox(height: 5),
              Text('Target for LLM on this stage', style: TextStyle(color: Colors.black, fontSize: 12)),
              TextFieldGpt(
                value: widget.node.nodeData.taskMessage.content,
                maxLength: 20,
                callBack: (String value) {
                  widget.node.nodeData.taskMessage.content = value;
                },
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Routing scheme for switching to another nodes',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.functions.length < 4) {
                        widget.node.nodeData.functions.add(
                          FunctionSchema(
                            description: 'Descript task for LLM for compliting this node',
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
                    tooltip: 'Add flow',
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
                  Text('Actions before switch to another node', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.postActions.length < 4) {
                        widget.node.nodeData.postActions.add(action.Action(type: ActionTypes.end_conversation));
                        controller.update();
                      }
                    },
                    icon: CupertinoIcons.add,
                    tooltip: 'Add post action',
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
          ),
        ),
      ),
    );
  }
}

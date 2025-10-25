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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      appState.stage = FillStages.projectSettings;
                      appState.currentAction = null;
                      appState.currentSchema = null;
                      controller.update();
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                  Text('Назад'),
                  Spacer(),
                ],
              ),
              Text('Название узла', style: TextStyle(color: Colors.black, fontSize: 12)),
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
                title: 'Запускать узел до ответа пользователя',
              ),
              SizedBox(height: 5),
              Text('Стратегия обработки контекста', style: TextStyle(color: Colors.black, fontSize: 12)),
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
                      return 'Накапливать контекст';
                    case ContextStrategy.RESET:
                      return 'Обнулить контекст';
                    case ContextStrategy.RESET_WITH_SUMMARY:
                      return 'Использовать последние 5 шагов';
                  }
                },
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Действия перед запуском узла', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.preActions.length < 4) {
                        widget.node.nodeData.preActions.add(action.Action(type: ActionTypes.function));
                        setState(() {});
                      }
                    },
                    icon: CupertinoIcons.add,
                    tooltip: 'Добавить стадию скрипта',
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
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Системная инструкция для LLM', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.roleMessage == null) {
                        widget.node.nodeData.roleMessage = Message(
                          role: 'system',
                          content: 'инструкция для бота помогающая выполнить данный этап',
                        );
                      } else {
                        widget.node.nodeData.roleMessage = null;
                      }
                      setState(() {});
                    },
                    icon: widget.node.nodeData.roleMessage == null ? CupertinoIcons.add : CupertinoIcons.clear,
                    tooltip: widget.node.nodeData.roleMessage == null
                        ? 'Добавить системную инструкцию'
                        : 'Удалить системную инструкцию',
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
              Text('Задача для LLM на данном этапе', style: TextStyle(color: Colors.black, fontSize: 12)),
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
                  Text('Обработчики перехода в другие узлы', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.functions.length < 4) {
                        widget.node.nodeData.functions.add(
                          FunctionSchema(
                            description: 'Переход',
                            required: [],
                            handler: HandlerModel(
                              flowResultName: 'Название схемы',
                              properties: {},
                              description: 'Обработчик перехода',
                            ),
                            uuid: Uuid().v4(),
                          ),
                        );
                        setState(() {});
                      }
                    },
                    icon: CupertinoIcons.add,
                    tooltip: 'Добавить переход',
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
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Действия перед выходом из узла', style: TextStyle(color: Colors.black, fontSize: 12)),
                  Spacer(),
                  CircleButton(
                    onTap: () {
                      if (widget.node.nodeData.postActions.length < 4) {
                        widget.node.nodeData.postActions.add(action.Action(type: ActionTypes.end_conversation));
                        setState(() {});
                      }
                    },
                    icon: CupertinoIcons.add,
                    tooltip: 'Добавить действие перед выходом из узла',
                  ),
                ],
              ),
              Wrap(
                children: widget.node.nodeData.postActions
                    .map(
                      (a) => ActionPlate(
                        a: a,
                        // onTap: () => Navigator.of(context)
                        //     .push(
                        //       MaterialPageRoute(builder: (_) => ActionSettings(isPreAction: false, selectedAction: a)),
                        //     )
                        //     .whenComplete(() => controller.update()),
                        onTap: () {
                          appState.stage = FillStages.postActionSettings;
                          appState.currentAction = a;
                          controller.update();
                        },
                        remove: () {
                          widget.node.nodeData.postActions.removeWhere((ac) => ac == a);
                          setState(() {});
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

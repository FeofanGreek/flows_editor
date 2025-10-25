import 'package:flutter/cupertino.dart';
import '../../models/action_model.dart' as action;
import '../models/block_node.dart';
import '../models/flow_function_schema.dart';
import '../models/flow_model.dart';

class AppStateController with ChangeNotifier {
  final GlobalKey interactiveViewerKey = GlobalKey();
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();
  FillStages stage = FillStages.projectSettings;

  FunctionSchema? currentSchema;
  action.Action? currentAction;
  NodeBloc? currentNodeBlock;

  double leftSide = 400;

  Future<bool> saveProject(FlowModel model) async {
    final toSave = model.toSaveJson();
    debugPrint('$toSave');
    return true;
  }
}

enum FillStages { projectSettings, nodeSettings, preActionSettings, postActionSettings, flowSchemaSettings }

import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/utils/list_extension.dart';
import 'package:uuid/uuid.dart';

import '../models/block_node.dart';
import '../models/flow_function_schema.dart';
import '../models/flow_model.dart';
import '../models/handler_model.dart';
import '../models/message_model.dart';
import '../models/node_config_model.dart';
import '../models/region.dart';

///Общий контроллер управления редактором нодов
class FLowEditController with ChangeNotifier {
  //Главная модель проекта
  FlowModel flowModel = FlowModel(
    projectName: 'testing_project',
    projectDescription:
        'Пробуем все собрать в одном месте, выгрузить пайтон, выгрузить json, сохранить и загрузить сохраненный проект',
  );

  List<NodeBloc> get nodes => flowModel.nodes;

  //получить все связи между нодами для отрисовки
  List<(Offset, Offset, String, String)> get edges {
    var list = <(Offset, Offset, String, String)>[];
    for (final node in nodes) {
      for (final function in node.nodeData.functions) {
        if (function.handler.nextNodeUuid.isNotEmpty) {
          for (final nextNOdeUuid in function.handler.nextNodeUuid) {
            ///получить оффсет хэндлера
            final handlerOffset = function.handler.getPosition() ?? Offset.zero;

            ///получить оффсет нода
            final nodeOffset = nodes.firstWhereOrNull((n) => n.uuid == nextNOdeUuid)?.getPosition() ?? Offset.zero;
            list.add((handlerOffset, nodeOffset, nextNOdeUuid, node.uuid));
          }
        }
      }
    }
    return list;
  }

  ///область в которой мы производим построение нашей блок-схемы
  Region region = Region(height: 50, width: 100);

  Size _oldSize = Size.zero;

  void setRegion(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (_oldSize != screenSize) {
      region = Region(height: screenSize.height * 2, width: screenSize.width * 2);
      // if (nodes.isEmpty) {
      //   region = Region(height: screenSize.height, width: screenSize.width);
      // } else {
      //   double maxWidth = 0;
      //   double maxHeight = 0;
      //   for (final node in nodes) {
      //     if (maxWidth < node.blockRegion.right) {
      //       maxWidth = node.blockRegion.right;
      //       //print(maxWidth);
      //     }
      //     if (maxHeight < node.blockRegion.bottom) {
      //       maxHeight = node.blockRegion.bottom;
      //       //print(maxHeight);
      //     }
      //   }
      //   region = Region(width: maxWidth + (nodes.first.width * 2), height: maxHeight + (nodes.first.height * 2));
      // }
      //заполним ячейки региона на предмет нахождения над ними нода
      region.markCells(nodes);
      _oldSize = screenSize;
      notifyListeners();
    }
  }

  /// Функция для поиска свободной позиции нового блока
  Offset? findFreePosition(NodeBloc newNode, FLowEditController controller) {
    const cellSize = 10.0;
    final positions = [
      // Ищем справа от последнего блока
      (NodeBloc lastNode) => lastNode.blockRegion.topRight + Offset(cellSize, 0),
      // Ищем снизу от последнего блока
      (NodeBloc lastNode) => lastNode.blockRegion.bottomLeft + Offset(0, cellSize),
      // Ищем слева от последнего блока
      (NodeBloc lastNode) => lastNode.blockRegion.topLeft - Offset(newNode.width + cellSize, 0),
      // Ищем сверху от последнего блока
      (NodeBloc lastNode) => lastNode.blockRegion.topLeft - Offset(0, newNode.height + cellSize),
      // Углы (сверху-слева)
      (NodeBloc lastNode) => lastNode.blockRegion.topLeft - Offset(newNode.width, newNode.height),
      // Углы (снизу-слева)
      (NodeBloc lastNode) => lastNode.blockRegion.bottomLeft - Offset(newNode.width, newNode.height),
      // Углы (снизу-справа)
      (NodeBloc lastNode) => lastNode.blockRegion.bottomRight + Offset(cellSize, cellSize),
      // Углы (сверху-справа)
      (NodeBloc lastNode) => lastNode.blockRegion.topRight + Offset(cellSize, -newNode.height),
    ];

    if (controller.nodes.isNotEmpty) {
      final lastNode = controller.nodes.last;

      // Пробуем каждую позицию из списка
      for (final positionFunc in positions) {
        final testOffset = positionFunc(lastNode);
        newNode.offset = testOffset;

        if (_isValidPosition(newNode, controller)) {
          return testOffset;
        }
      }

      // Если стандартные позиции не подходят, ищем в свободной области
      return _findFreeSpaceByGrid(newNode, controller);
    }

    // Если это первый блок, размещаем его в начало
    return Offset(cellSize, cellSize);
  }

  /// Проверяет, валидна ли позиция для блока
  bool _isValidPosition(NodeBloc node, FLowEditController controller) {
    // Проверяем, не выходит ли блок за пределы региона
    if (!controller.region.regionRegion.contains(node.blockRegion.topLeft) ||
        !controller.region.regionRegion.contains(node.blockRegion.bottomRight)) {
      return false;
    }

    // Проверяем пересечение с другими блоками
    for (final block in controller.nodes) {
      if (block.blockRegion.overlaps(node.blockRegion)) {
        return false;
      }
    }

    return true;
  }

  /// Поиск свободного места с использованием сетки
  Offset? _findFreeSpaceByGrid(NodeBloc newNode, FLowEditController controller) {
    const gridStep = 10.0;
    final maxX = (controller.region.width / gridStep).ceil().toInt();
    final maxY = (controller.region.height / gridStep).ceil().toInt();

    // Ищем свободное место слоями, начиная с центра
    for (var y = 0; y < maxY; y++) {
      for (var x = 0; x < maxX; x++) {
        final testOffset = Offset(x * gridStep, y * gridStep);
        newNode.offset = testOffset;

        if (_isValidPosition(newNode, controller)) {
          return testOffset;
        }
      }
    }

    return null;
  }

  /// Обновленная функция addNode в вашем FLowEditController
  void addNode(BuildContext context) {
    final newNode = NodeBloc(
      nodeData: NodeConfig(
        name: 'node_${nodes.length}',
        taskMessage: Message(role: 'system', content: 'add your promt here'),
      ),
      uuid: Uuid().v4(),
    );

    final freePosition = findFreePosition(newNode, this);

    if (freePosition != null) {
      newNode.offset = freePosition;
      nodes.add(newNode);
      //region.markCells(nodes);
      setRegion(context);
      print('Блок добавлен на позицию: $freePosition');
    } else {
      print('Не удалось найти свободное место для блока');
    }
  }

  void removeNode(int index) {
    nodes.removeAt(index);
    update();
  }

  ///Добавляем новое ребро между нодами в флоу
  String? _uuidInProgress;

  ///нам надо в нужный нод, в нужную его схему, в ее хендлер передать uuid
  void setEdge(String? uuidOutput, String? uuidInput) {
    if (_uuidInProgress == null && uuidOutput != null) {
      //устаналиваем ожидающую связки FlowFunctionSchema uuid
      _uuidInProgress = uuidOutput;
    } else if (_uuidInProgress != null && uuidOutput != null) {
      //Делаем сброс, так как нажали по шарику
      _uuidInProgress = null;
    }
    if (_uuidInProgress != null && uuidInput != null) {
      FunctionSchema? setupSchema;
      for (final node in nodes) {
        for (final schema in node.nodeData.functions) {
          if (schema.uuid == _uuidInProgress) setupSchema = schema;
          if (setupSchema != null) {
            print('добавили связку');
            setupSchema.handler.nextNodeUuid.add(uuidInput);
            _uuidInProgress = null;
          }
        }
      }
    }

    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/action_model.dart' as action;
import '../models/block_node.dart';
import '../models/flow_function_schema.dart';
import '../models/flow_model.dart';
import '../models/handler_model.dart';
import '../models/message_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/node_config_model.dart';
import 'enums_lib.dart';

void printPythonCode() {
  NodeConfig node = NodeConfig(
    name: 'test_node',
    taskMessage: Message(role: 'system', content: 'что-то из задания для бота'),
  );
  node.roleMessage = Message(role: 'system', content: 'что-то из инструкций для бота');
  node.respondImmediately = true;
  node.postActions = [action.Action(type: ActionTypes.end_conversation, text: 'тестовый пост экшн')];
  node.preActions = [action.Action(type: ActionTypes.end_conversation, text: 'тестовый пре экшн')];
  node.functions = [
    FunctionSchema(
      description: 'проверка дескриптинга схемы',
      required: ["estew", "erwwet"],
      handler: HandlerModel(
        description: 'проверка дескриптинга хэндлера схемы',
        flowResultName: 'check_descriptor',
        properties: {
          "size": {
            "type": "string",
            "enum": ["small", "medium", "large"],
            "description": "Size of the pizza",
          },
          "type": {
            "type": "string",
            "enum": ["pepperoni", "cheese", "supreme", "vegetarian"],
            "description": "Type of pizza",
          },
        },
      ),
      uuid: Uuid().v4(),
    ),
  ];
  //node.functions.first.handler.router.nodes = [node, node, node];
  FlowModel flow = FlowModel(projectName: 'testing_project', projectDescription: 'Пробуем распечатать Python код');
  flow.nodes = [NodeBloc(nodeData: node, uuid: Uuid().v4()), NodeBloc(nodeData: node, uuid: Uuid().v4())];

  String pythonResult =
      '''
#перечисляем в коде импорты
from loguru import logger
from pipecat_flows import (
    FlowArgs,
    FlowManager,
    FlowsFunctionSchema,
    NodeConfig,
)



${flow.nodes.map((node) => node.nodeData.toPython()).join('\n\n')}

async def router(arg: dict, from: str) -> tuple[dict, NodeConfig]:
    match from:
${flow.nodes.map((node) => node.nodeData.functions.map((func) => '      case "${func.handler.name}":\n      #настройте математику \n${func.handler.router.toPython()}').join('')).join('')}
      case _: 
          return ${node.functions.first.handler.name}()
  ''';

  debugPrint(pythonResult);
  unawaited(savePythonFlow('${node.name}.py', pythonResult));
}

/// Сохраняет заданную строку в файл в указанной директории.
///
/// [directoryPath] - Путь к директории (например, 'out/flows').
/// [filename] - Имя файла (например, 'initial_flow.py').
/// [content] - Строка, которую нужно записать в файл.
///
/// Возвращает полный путь к сохраненному файлу.
Future<void> savePythonFlow(String filename, String content) async {
  // 1. Получаем объект Directory для директории Документов/данных приложения.
  //    Этот путь специфичен для ОС (например, в Android это будут 'files dir',
  //    в iOS это 'Documents', в Windows - 'AppData/Roaming').
  final directory = await getApplicationDocumentsDirectory();

  // 2. Формируем путь для сохранения: к директории добавляем подпапку
  //    (например, 'generated_flows') и имя файла.
  const String subDir = 'generated_flows';
  final outputDir = p.join(directory.path, subDir);

  // 3. Вызываем вашу функцию сохранения, которая создает директорию и файл.
  String fullSavedPath = await saveStringToFileInDir(outputDir, filename, content);

  // 4. Печатаем путь, куда сохранили.
  print('✅ Файл успешно сохранен!');
  print('Базовая директория приложения: ${directory.path}');
  print('Полный путь к файлу: $fullSavedPath');
}

Future<String> saveStringToFileInDir(String directoryPath, String filename, String content) async {
  try {
    // 1. Создаем объект Directory и убеждаемся, что директория существует.
    //    recursively: true позволяет создать все промежуточные директории.
    final directory = await Directory(directoryPath).create(recursive: true);

    // 2. Создаем полный путь к файлу с помощью пакета path (p.join).
    //    Это обеспечивает корректные разделители ('/' или '\') для разных ОС.
    final fullPath = p.join(directory.path, filename);

    // 3. Создаем объект File.
    final file = File(fullPath);

    // 4. Асинхронно записываем строку в файл (перезаписываем, если существует).
    await file.writeAsString(content);

    // 5. Возвращаем полный путь к файлу.
    return file.absolute.path;
  } catch (e) {
    print('Ошибка при сохранении файла $filename в $directoryPath: $e');
    rethrow;
  }
}

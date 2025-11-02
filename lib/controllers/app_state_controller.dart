import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/action_model.dart' as action;
import '../models/block_node.dart';
import '../models/flow_function_schema.dart';
import '../models/flow_model.dart';

class AppStateController with ChangeNotifier {
  final GlobalKey interactiveViewerKey = GlobalKey();
  ScrollController verticalScrollController = ScrollController();
  ScrollController horizontalScrollController = ScrollController();
  FillStages stage = FillStages.projectSettings;

  FunctionSchema? currentSchema;
  action.Action? currentAction;
  NodeBloc? currentNodeBlock;

  double leftSide = 400;

  //Отображать или нет много полей ввода в настройках проекта. Для генерации промпта, который можно отправить в любой ГПТ и сделать пайтон код, достаточно выключенного расширенного режима
  bool extendedMode = false;

  Future<FlowModel?> loadProject(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выбор файла отменен.')));
      }
      return null;
    }

    PlatformFile file = result.files.first;
    Uint8List? fileBytes = file.bytes; // Попробуем получить байты
    String? jsonString;

    if (fileBytes != null) {
      //print('Файл прочитан через байты (в памяти).');
      jsonString = utf8.decode(fileBytes);
    } else if (!kIsWeb && file.path != null) {
      try {
        final File loadedFile = File(file.path!);
        jsonString = await loadedFile.readAsString(encoding: utf8); // Чтение по пути с UTF-8
        //print('Файл прочитан через путь (dart:io).');
      } catch (e) {
        //print('Ошибка при чтении файла по пути: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ошибка: Не удалось прочитать файл по пути.')));
        }
        return null;
      }
    } else {
      // ⭐️ СЛУЧАЙ C: Ни байтов, ни пути (ошибка)
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ошибка: Не удалось получить ни байты, ни путь к файлу.')));
      }
      return null;
    }

    try {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      FlowModel loadedProject = FlowModel.fromJson(jsonMap);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Проект "${loadedProject.projectName}" загружен!'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
      //print('Загруженный проект: ${loadedProject.projectName}');
      verticalScrollController = ScrollController();
      horizontalScrollController = ScrollController();
      return loadedProject;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка при декодировании JSON: $e')));
      }
      //print('Ошибка при декодировании JSON: $e');
      return null;
    }
  }

  Future<bool> saveProject(FlowModel model) async {
    final toSave = model.toJson();
    final Uint8List bytes = utf8.encode(jsonEncode(toSave));

    await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: '${model.latinName.replaceAll(' ', '_')}.json',
      type: FileType.custom,
      bytes: bytes as Uint8List?,
    );
    return true;
  }

  Future<bool> savePrompt(String prompt, String projectName) async {
    //debugPrint(prompt);
    final Uint8List bytes = utf8.encode(prompt);

    await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: '${projectName.replaceAll(' ', '_')}.prompt',
      type: FileType.custom,
      bytes: bytes as Uint8List?,
    );
    return true;
  }
}

enum FillStages { projectSettings, nodeSettings, preActionSettings, postActionSettings, flowSchemaSettings }

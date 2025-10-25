import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'circle_button.dart';

class TextFieldGpt extends StatefulWidget {
  const TextFieldGpt({super.key, required this.value, required this.callBack, this.maxLength});
  final String value;
  final int? maxLength;

  final Function(String) callBack;

  @override
  State<TextFieldGpt> createState() => TextFieldGptState();
}

class TextFieldGptState extends State<TextFieldGpt> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      style: const TextStyle(fontSize: 12.0, height: 1.2),
      minLines: 1,
      maxLines: null,
      maxLength: widget.maxLength,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        isDense: false,
        hintText: 'Введите текст...',
        hintStyle: const TextStyle(fontSize: 12.0, height: 1.2),
        counter: SizedBox(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        //contentPadding: const EdgeInsets.only(left: 10, bottom: 15, top: 3),
        visualDensity: VisualDensity.comfortable,
        //suffix: SizedBox(
        //  width: 20,
        //  height: 20,
        //  child: Row(
        //   children: [
        //     CircleButton(onTap: () => textEditingController.clear(), icon: Icons.close, tooltip: 'Очистить поле'),
        // CircleButton(
        //   onTap:(){
        //     _sendToOllama();
        //   },
        //   icon: CupertinoIcons.chat_bubble_2,
        //   tooltip: 'Закрыть',
        // ),
        //    ],
        //  ),
        // ),
      ),
      onChanged: widget.callBack,
      onSubmitted: widget.callBack,
      onTapUpOutside: (v) => widget.callBack(textEditingController.text),
    );
  }

  // Функция для отправки запроса и получения потокового ответа
  String _responseText = '';
  bool _isLoading = false;
  Future<void> _sendToOllama() async {
    //if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
      _responseText = 'Генерация ответа...';
      print(_responseText);
    });

    try {
      // 1. Кодируем изображение в Base64
      //final imageBytes = await _imageFile!.readAsBytes();
      //final base64Image = base64Encode(imageBytes);

      // 2. Формируем тело запроса
      final requestBody = {
        'model': 'gemma3:4b',
        'prompt': 'Что изображено на картинке?',
        //'images': [base64Image],
        'stream': true, // Запрос на потоковый ответ
      };

      // 3. Используем HttpClient для работы с потоками
      final client = HttpClient();
      final request = await client.postUrl(Uri.parse('http://192.168.2.2:8080/api/generate'));

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(requestBody));
      final response = await request.close();

      // 4. Обрабатываем потоковый ответ
      setState(() {
        _responseText = ''; // Очищаем "Генерация ответа..."
      });
      await for (var chunk in response.transform(utf8.decoder).transform(const LineSplitter())) {
        if (chunk.isNotEmpty) {
          final data = jsonDecode(chunk);
          if (data['response'] != null) {
            // Обновляем UI с каждой новой порцией текста
            setState(() {
              _responseText += data['response'];
              print(_responseText);
            });
          }
        }
      }
      client.close();
      textEditingController.text = _responseText;
    } catch (e) {
      setState(() {
        _responseText = 'Произошла ошибка: $e';
        print(_responseText);
      });
    } finally {
      setState(() {
        _isLoading = false;
        print('ошибка');
      });
    }
  }
}

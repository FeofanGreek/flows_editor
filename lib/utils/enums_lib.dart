enum ActionTypes {
  //фраза которую надо сказать клиенту
  tts_say('Бот произносит фразу немедленно (полезно для сообщений типа «пожалуйста, подождите»'),
  //завершить разговор
  end_conversation('Вежливо завершить разговор'),
  //выполнить функцию
  ///# Изменяем аннотацию: функция теперь возвращает целое число (int)
  // async def get_api_status(api_url: str) -> int:
  //     async with aiohttp.ClientSession() as session:
  //         async with session.get(api_url) as response:
  //             return response.status  # <-- Явно возвращаем статус!
  //
  // # Вызов:
  // # status = await get_api_status(some_url)
  // # print(status)  # Напечатает 200, 404, и т.д.
  function('Выполнить пользовательскую функцию')
  //переключить на оператора или другой телефон
  //transfer_call('Переключить на оператора или другой телефон')
  ;

  final String description;
  const ActionTypes(this.description);
}

enum VariableTypes {
  string('string', 'String', 'str'),
  integer('integer', 'int', 'int'),
  number('number', 'double', 'float'),
  boolean('boolean', 'bool', 'bool'),
  array('array', 'List', 'list'),
  object('object', 'Map', 'dict');

  final String json;
  final String dart;
  final String python;
  const VariableTypes(this.json, this.dart, this.python);
}

///Strategy Types
//APPEND (Default): New node messages are added to the existing context, preserving the full conversation history. The context grows as the conversation progresses.
//RESET: The context is cleared and replaced with only the new node’s messages. Useful when previous conversation history is no longer relevant or to reduce context window size.
//RESET_WITH_SUMMARY: The context is cleared but includes an AI-generated summary of the previous conversation along with the new node’s messages. Helps reduce context size while preserving key information.
enum ContextStrategy {
  //Use APPEND when full conversation history is important for context
  APPEND,
  //Use RESET when starting a new topic or when previous context might confuse the current task
  RESET,
  //Use RESET_WITH_SUMMARY for long conversations where you need to preserve key points but reduce context size
  RESET_WITH_SUMMARY,
}

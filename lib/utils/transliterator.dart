String transliterateRussian(String text) {
  // Словарь для транслитерации
  const Map<String, String> mapping = {
    'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Е': 'E', 'Ё': 'Yo',
    'Ж': 'Zh', 'З': 'Z', 'И': 'I', 'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M',
    'Н': 'N', 'О': 'O', 'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'У': 'U',
    'Ф': 'F', 'Х': 'Kh', 'Ц': 'Ts', 'Ч': 'Ch', 'Ш': 'Sh', 'Щ': 'Shch',
    'Ъ': '"', 'Ы': 'Y', 'Ь': "'", 'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya',

    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo',
    'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm',
    'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u',
    'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'shch',
    'ъ': '"', 'ы': 'y', 'ь': "'", 'э': 'e', 'ю': 'yu', 'я': 'ya',

    // Дополнительные правила для мягкости/звучности (можно расширить)
    'ье': 'ye', 'ъе': 'ye', 'ий': 'iy',
  };

  final StringBuffer result = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    final char = text[i];
    final nextChar = (i + 1 < text.length) ? text[i + 1] : '';

    // Проверяем на двухбуквенные сочетания, например, 'ье', 'ъе'
    if (i + 1 < text.length) {
      final twoChar = char + nextChar;
      if (mapping.containsKey(twoChar)) {
        result.write(mapping[twoChar]);
        i++; // Пропускаем следующий символ, так как он уже обработан
        continue;
      }
    }

    // Обрабатываем одиночный символ
    if (mapping.containsKey(char)) {
      result.write(mapping[char]);
    } else {
      // Оставляем неизменными символы, которых нет в словаре (например, пробелы, знаки препинания, цифры)
      result.write(char);
    }
  }

  return result.toString();
}
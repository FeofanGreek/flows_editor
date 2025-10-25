extension StringCasingExtension on String {
  /// Капитализирует только первую букву строки.
  /// Остальная часть строки остается неизменной.
  String toCapitalized() {
    if (isEmpty) {
      return this;
    }
    // Берем первый символ и переводим его в верхний регистр
    // Затем объединяем с остальной частью строки (начиная с индекса 1)
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

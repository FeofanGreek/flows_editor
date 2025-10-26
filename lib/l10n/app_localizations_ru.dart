// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get back => 'Назад';

  @override
  String get selectActionType => 'Выберите тип действия';

  @override
  String get phraseWichBotSayFirst =>
      'Фраза, которую бот скажет перед выполнением узла';

  @override
  String get nameFunctionAndPythonCode =>
      'Имя функции и ее код Python, который будет выполнять бот.';

  @override
  String get nameOfFunction => 'Название функции';

  @override
  String get schemaDescriptionForLLM => 'Описание схемы для LLM';

  @override
  String get description => 'Description';

  @override
  String get schemaPropities => 'Параметры для схемы';

  @override
  String get addProperty => 'Добавить параметр';

  @override
  String get textValue => 'Текстовый параметр';

  @override
  String get integerValue => 'Числовой параметр';

  @override
  String get listValue => 'Параметр список';

  @override
  String get notSelected => 'Не выбрано';

  @override
  String get removeProperty => 'Удалить значение';

  @override
  String get openSavedProject => 'Открыть сохраненый проект';

  @override
  String get startNewProject => 'Начать новый проект';

  @override
  String get informationAboutApp => 'Информация о приложении';

  @override
  String get nodeName => 'Название узла';

  @override
  String get runWithoutWaitingUserAction =>
      'Запускать узел не дожидаясь фразы пользователя';

  @override
  String get contextProcessingStrategy => 'Стратегия накопления контекста';

  @override
  String get accumulateContext => 'Копить весь контекст';

  @override
  String get resetContext => 'Очистить контекст';

  @override
  String get useSomeHistory => 'Использовать несколько предыдущих фраз';

  @override
  String get actionRuningBeforeRuningNode =>
      'Действие запускаемое перед стартом узла';

  @override
  String get addPreAction => 'Добавить ПРЕ действие';

  @override
  String get systemInstructionForLLM => 'Системная инструкция для LLM';

  @override
  String get instructionForYourLLM =>
      'Инструкция для вашей LLM, где вы описываете сценарий выполнения данного узла';

  @override
  String get addSystemInstruction => 'Добавить системную инструкцию';

  @override
  String get removeSystemInstruction => 'Удалить системную инструкцию';

  @override
  String get instructionText => 'Текст системной иснтрукции';

  @override
  String get targetOnThisStage =>
      'Описание цели для LLM которая выполнит эту стадию';

  @override
  String get targetDescription => 'Описание цели';

  @override
  String get routingSchemeForSwitching =>
      'Схема переключения на следующий узел разговора';

  @override
  String get descriptTaskForCompliting =>
      'Описание задачи для LLM, выполнение которой является условием перехода далее';

  @override
  String get addFlow => 'Добавить схему';

  @override
  String get actionsBeforeSwitching =>
      'Дейтвие, выполняемое когда цель достигнута и нужно идти далее';

  @override
  String get addPostAction => 'Добавить ПОСТ действие';

  @override
  String get saveProject => 'Сохранить проект';

  @override
  String get exportToPython => 'Экспорт в Python';

  @override
  String get importFromPython => 'Импорт из Python';

  @override
  String get shortProjectName => 'Короткое наименование проекта';

  @override
  String get projectDescription => 'Описание проекта';

  @override
  String get speechStages => 'Стадии разговора';

  @override
  String get addStage => 'Добавить стадию';

  @override
  String get projectSettings => 'Настройки проекта';

  @override
  String get userGuide => 'Описание работы с приложением';

  @override
  String get selectValue => 'Выберите значение';

  @override
  String get propertyDescriptionForLLM => 'Описание параметра для LLM';

  @override
  String get possibleValuesForLLMChoose =>
      'Возможные значения из которых LLM сделает выбор (поле может быть пустым)';

  @override
  String get listValues => 'Список значений';

  @override
  String get defaultValueIfLLMCannotMakeChoice =>
      'Значение по умолчанию, если LLM не сможет сделать выбор';

  @override
  String get minimumAndMaximumNumberElementsInArray =>
      'Минимальное и максимальное количество элементов в масиве (сколько LLM может выбрать). (Это поле можно оставить пустым)';

  @override
  String get minIntegerValue => 'Минимальнео значение';

  @override
  String get maxIntegerValue => 'Максимальное значение';

  @override
  String get stringLengthLimiter =>
      'Ограничитель длины строки (поле можно оставить пустым)';

  @override
  String get regexPattern => 'Regex маска (поле можно оставить пустым)';

  @override
  String get pattern => 'Маска';

  @override
  String get formattingReceivedResponse =>
      'Форматирование полученного от пользователея значения (поле можно оставить пустым, но форматирование может быть полезно вам для дальнейшей обработки)';

  @override
  String get formatter => 'Шаблон';

  @override
  String get minimumAndMaximumAllowedValues =>
      'Минимальное и максимальное допустимое значение (включительно). (Поле можно оставить пустым)';

  @override
  String get valueMustStrictlyGreaterLessSpecifiedValue =>
      'Значение должно быть строго меньше или больше чем указанное (Поле можно оставить пустым)';

  @override
  String get valueMustMultipleSpecifiedNumber =>
      'Значение должно быть кратно указанному числу (e.g. `0.5`) (Поле можно оставить пустым)';
}

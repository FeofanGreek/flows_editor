// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get back => 'Back';

  @override
  String get selectActionType => 'Select action type';

  @override
  String get phraseWichBotSayFirst => 'Phrase, wich bot say first';

  @override
  String get nameFunctionAndPythonCode =>
      'The name of the function and its Python code that the bot will execute';

  @override
  String get nameOfFunction => 'Name of the function';

  @override
  String get schemaDescriptionForLLM => 'Schema description for LLM';

  @override
  String get description => 'Description';

  @override
  String get schemaPropities => 'Schema properties';

  @override
  String get addProperty => 'Add propierty';

  @override
  String get textValue => 'Text value';

  @override
  String get integerValue => 'Integer value';

  @override
  String get listValue => 'List value';

  @override
  String get notSelected => 'Not selected';

  @override
  String get removeProperty => 'Remove property';

  @override
  String get openSavedProject => 'Open saved project';

  @override
  String get startNewProject => 'Start new project';

  @override
  String get informationAboutApp => 'Information about app';

  @override
  String get nodeName => 'Node name';

  @override
  String get runWithoutWaitingUserAction =>
      'Run node without waiting user action';

  @override
  String get contextProcessingStrategy => 'Context processing strategy';

  @override
  String get accumulateContext => 'Accumulate context';

  @override
  String get resetContext => 'Reset context';

  @override
  String get useSomeHistory => 'Use some of previos context history';

  @override
  String get actionRuningBeforeRuningNode => 'Action runing before run node';

  @override
  String get addPreAction => 'Add pre action';

  @override
  String get systemInstructionForLLM => 'System instruction for LLM';

  @override
  String get instructionForYourLLM =>
      'Instruction for your LLM, where you set scenario of this node';

  @override
  String get addSystemInstruction => 'Add system instruction';

  @override
  String get removeSystemInstruction => 'Remove system instruction';

  @override
  String get instructionText => 'Instruction text';

  @override
  String get targetOnThisStage => 'Target for LLM on this stage';

  @override
  String get targetDescription => 'Target description';

  @override
  String get routingSchemeForSwitching =>
      'Routing scheme for switching to another nodes';

  @override
  String get descriptTaskForCompliting =>
      'Descript task for LLM for compliting this node';

  @override
  String get addFlow => 'Add flow';

  @override
  String get actionsBeforeSwitching => 'Actions before switch to another node';

  @override
  String get addPostAction => 'Add post action';

  @override
  String get saveProject => 'Save project';

  @override
  String get exportToPython => 'Export to Python';

  @override
  String get importFromPython => 'Import from Python';

  @override
  String get shortProjectName => 'Short project name';

  @override
  String get projectDescription => 'Project description';

  @override
  String get speechStages => 'Speech stages';

  @override
  String get addStage => 'Add stage';

  @override
  String get projectSettings => 'Project settings';

  @override
  String get userGuide => 'User guide';

  @override
  String get selectValue => 'Select value';

  @override
  String get propertyDescriptionForLLM => 'Property description for LLM';

  @override
  String get possibleValuesForLLMChoose =>
      'Possible values from which LLM will choose (field may be empty)';

  @override
  String get listValues => 'List of values';

  @override
  String get defaultValueIfLLMCannotMakeChoice =>
      'Default value if LLM cannot make a choice';

  @override
  String get minimumAndMaximumNumberElementsInArray =>
      'The minimum and maximum number of elements in the array. (This field may be empty.)';

  @override
  String get minIntegerValue => 'Min integer value';

  @override
  String get maxIntegerValue => 'Max integer value';

  @override
  String get stringLengthLimiter =>
      'String length limiter (fields may be empty)';

  @override
  String get regexPattern => 'Regex pattern (field may be empty)';

  @override
  String get pattern => 'Pattern';

  @override
  String get formattingReceivedResponse =>
      'Formatting the received response (the field may be empty, but the formatting may be useful for subsequent processing)';

  @override
  String get formatter => 'Formatter';

  @override
  String get minimumAndMaximumAllowedValues =>
      'Minimum and maximum allowed values (inclusive). (This field may be empty.)';

  @override
  String get valueMustStrictlyGreaterLessSpecifiedValue =>
      'The value must be strictly greater than or less than the specified value. (The field may be empty.)';

  @override
  String get valueMustMultipleSpecifiedNumber =>
      'The value must be a multiple of the specified number (e.g. `0.5`) (the field may be empty)';
}

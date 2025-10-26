import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @selectActionType.
  ///
  /// In en, this message translates to:
  /// **'Select action type'**
  String get selectActionType;

  /// No description provided for @phraseWichBotSayFirst.
  ///
  /// In en, this message translates to:
  /// **'Phrase, wich bot say first'**
  String get phraseWichBotSayFirst;

  /// No description provided for @nameFunctionAndPythonCode.
  ///
  /// In en, this message translates to:
  /// **'The name of the function and its Python code that the bot will execute'**
  String get nameFunctionAndPythonCode;

  /// No description provided for @nameOfFunction.
  ///
  /// In en, this message translates to:
  /// **'Name of the function'**
  String get nameOfFunction;

  /// No description provided for @schemaDescriptionForLLM.
  ///
  /// In en, this message translates to:
  /// **'Schema description for LLM'**
  String get schemaDescriptionForLLM;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @schemaPropities.
  ///
  /// In en, this message translates to:
  /// **'Schema properties'**
  String get schemaPropities;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add propierty'**
  String get addProperty;

  /// No description provided for @textValue.
  ///
  /// In en, this message translates to:
  /// **'Text value'**
  String get textValue;

  /// No description provided for @integerValue.
  ///
  /// In en, this message translates to:
  /// **'Integer value'**
  String get integerValue;

  /// No description provided for @listValue.
  ///
  /// In en, this message translates to:
  /// **'List value'**
  String get listValue;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @removeProperty.
  ///
  /// In en, this message translates to:
  /// **'Remove property'**
  String get removeProperty;

  /// No description provided for @openSavedProject.
  ///
  /// In en, this message translates to:
  /// **'Open saved project'**
  String get openSavedProject;

  /// No description provided for @startNewProject.
  ///
  /// In en, this message translates to:
  /// **'Start new project'**
  String get startNewProject;

  /// No description provided for @informationAboutApp.
  ///
  /// In en, this message translates to:
  /// **'Information about app'**
  String get informationAboutApp;

  /// No description provided for @nodeName.
  ///
  /// In en, this message translates to:
  /// **'Node name'**
  String get nodeName;

  /// No description provided for @runWithoutWaitingUserAction.
  ///
  /// In en, this message translates to:
  /// **'Run node without waiting user action'**
  String get runWithoutWaitingUserAction;

  /// No description provided for @contextProcessingStrategy.
  ///
  /// In en, this message translates to:
  /// **'Context processing strategy'**
  String get contextProcessingStrategy;

  /// No description provided for @accumulateContext.
  ///
  /// In en, this message translates to:
  /// **'Accumulate context'**
  String get accumulateContext;

  /// No description provided for @resetContext.
  ///
  /// In en, this message translates to:
  /// **'Reset context'**
  String get resetContext;

  /// No description provided for @useSomeHistory.
  ///
  /// In en, this message translates to:
  /// **'Use some of previos context history'**
  String get useSomeHistory;

  /// No description provided for @actionRuningBeforeRuningNode.
  ///
  /// In en, this message translates to:
  /// **'Action runing before run node'**
  String get actionRuningBeforeRuningNode;

  /// No description provided for @addPreAction.
  ///
  /// In en, this message translates to:
  /// **'Add pre action'**
  String get addPreAction;

  /// No description provided for @systemInstructionForLLM.
  ///
  /// In en, this message translates to:
  /// **'System instruction for LLM'**
  String get systemInstructionForLLM;

  /// No description provided for @instructionForYourLLM.
  ///
  /// In en, this message translates to:
  /// **'Instruction for your LLM, where you set scenario of this node'**
  String get instructionForYourLLM;

  /// No description provided for @addSystemInstruction.
  ///
  /// In en, this message translates to:
  /// **'Add system instruction'**
  String get addSystemInstruction;

  /// No description provided for @removeSystemInstruction.
  ///
  /// In en, this message translates to:
  /// **'Remove system instruction'**
  String get removeSystemInstruction;

  /// No description provided for @instructionText.
  ///
  /// In en, this message translates to:
  /// **'Instruction text'**
  String get instructionText;

  /// No description provided for @targetOnThisStage.
  ///
  /// In en, this message translates to:
  /// **'Target for LLM on this stage'**
  String get targetOnThisStage;

  /// No description provided for @targetDescription.
  ///
  /// In en, this message translates to:
  /// **'Target description'**
  String get targetDescription;

  /// No description provided for @routingSchemeForSwitching.
  ///
  /// In en, this message translates to:
  /// **'Routing scheme for switching to another nodes'**
  String get routingSchemeForSwitching;

  /// No description provided for @descriptTaskForCompliting.
  ///
  /// In en, this message translates to:
  /// **'Descript task for LLM for compliting this node'**
  String get descriptTaskForCompliting;

  /// No description provided for @addFlow.
  ///
  /// In en, this message translates to:
  /// **'Add flow'**
  String get addFlow;

  /// No description provided for @actionsBeforeSwitching.
  ///
  /// In en, this message translates to:
  /// **'Actions before switch to another node'**
  String get actionsBeforeSwitching;

  /// No description provided for @addPostAction.
  ///
  /// In en, this message translates to:
  /// **'Add post action'**
  String get addPostAction;

  /// No description provided for @saveProject.
  ///
  /// In en, this message translates to:
  /// **'Save project'**
  String get saveProject;

  /// No description provided for @exportToPython.
  ///
  /// In en, this message translates to:
  /// **'Export to Python'**
  String get exportToPython;

  /// No description provided for @importFromPython.
  ///
  /// In en, this message translates to:
  /// **'Import from Python'**
  String get importFromPython;

  /// No description provided for @shortProjectName.
  ///
  /// In en, this message translates to:
  /// **'Short project name'**
  String get shortProjectName;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project description'**
  String get projectDescription;

  /// No description provided for @speechStages.
  ///
  /// In en, this message translates to:
  /// **'Speech stages'**
  String get speechStages;

  /// No description provided for @addStage.
  ///
  /// In en, this message translates to:
  /// **'Add stage'**
  String get addStage;

  /// No description provided for @projectSettings.
  ///
  /// In en, this message translates to:
  /// **'Project settings'**
  String get projectSettings;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User guide'**
  String get userGuide;

  /// No description provided for @selectValue.
  ///
  /// In en, this message translates to:
  /// **'Select value'**
  String get selectValue;

  /// No description provided for @propertyDescriptionForLLM.
  ///
  /// In en, this message translates to:
  /// **'Property description for LLM'**
  String get propertyDescriptionForLLM;

  /// No description provided for @possibleValuesForLLMChoose.
  ///
  /// In en, this message translates to:
  /// **'Possible values from which LLM will choose (field may be empty)'**
  String get possibleValuesForLLMChoose;

  /// No description provided for @listValues.
  ///
  /// In en, this message translates to:
  /// **'List of values'**
  String get listValues;

  /// No description provided for @defaultValueIfLLMCannotMakeChoice.
  ///
  /// In en, this message translates to:
  /// **'Default value if LLM cannot make a choice'**
  String get defaultValueIfLLMCannotMakeChoice;

  /// No description provided for @minimumAndMaximumNumberElementsInArray.
  ///
  /// In en, this message translates to:
  /// **'The minimum and maximum number of elements in the array. (This field may be empty.)'**
  String get minimumAndMaximumNumberElementsInArray;

  /// No description provided for @minIntegerValue.
  ///
  /// In en, this message translates to:
  /// **'Min integer value'**
  String get minIntegerValue;

  /// No description provided for @maxIntegerValue.
  ///
  /// In en, this message translates to:
  /// **'Max integer value'**
  String get maxIntegerValue;

  /// No description provided for @stringLengthLimiter.
  ///
  /// In en, this message translates to:
  /// **'String length limiter (fields may be empty)'**
  String get stringLengthLimiter;

  /// No description provided for @regexPattern.
  ///
  /// In en, this message translates to:
  /// **'Regex pattern (field may be empty)'**
  String get regexPattern;

  /// No description provided for @pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// No description provided for @formattingReceivedResponse.
  ///
  /// In en, this message translates to:
  /// **'Formatting the received response (the field may be empty, but the formatting may be useful for subsequent processing)'**
  String get formattingReceivedResponse;

  /// No description provided for @formatter.
  ///
  /// In en, this message translates to:
  /// **'Formatter'**
  String get formatter;

  /// No description provided for @minimumAndMaximumAllowedValues.
  ///
  /// In en, this message translates to:
  /// **'Minimum and maximum allowed values (inclusive). (This field may be empty.)'**
  String get minimumAndMaximumAllowedValues;

  /// No description provided for @valueMustStrictlyGreaterLessSpecifiedValue.
  ///
  /// In en, this message translates to:
  /// **'The value must be strictly greater than or less than the specified value. (The field may be empty.)'**
  String get valueMustStrictlyGreaterLessSpecifiedValue;

  /// No description provided for @valueMustMultipleSpecifiedNumber.
  ///
  /// In en, this message translates to:
  /// **'The value must be a multiple of the specified number (e.g. `0.5`) (the field may be empty)'**
  String get valueMustMultipleSpecifiedNumber;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

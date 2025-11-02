import 'package:PipeCatFlowEditor/utils/list_extension.dart';
import 'package:flutter/material.dart';
import '../../ui/widgets/text_field_gpt.dart';

import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/array_property_model.dart';
import '../../models/flowschema_properties_models/number_property_model.dart';
import '../../models/flowschema_properties_models/string_property_model.dart';
import '../../utils/enums_lib.dart';
import 'drop_down_menu.dart';

Future<Map<String, dynamic>> showAddPropertyDialog<T>(BuildContext context) async {
  final loc = AppLocalizations.of(context)!;
  Map<String, dynamic> result = {};
  final one = ArrayPropertyModel(description: '', items: <String, dynamic>{});
  final two = NumberPropertyModel(description: '', enums: [], default_value: null);
  final three = StringPropertyModel(description: '', enums: [], default_value: null, format: null);
  dynamic property;
  Type? selectedItem;

  bool keyNotFilled = true;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(loc.addProperty),
        content: StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: <Widget>[
                  DropDownMenu(
                    selectedItem: selectedItem,
                    items: [ArrayPropertyModel, NumberPropertyModel, StringPropertyModel],
                    onChanged: (value) {
                      selectedItem = value;
                      if (selectedItem == ArrayPropertyModel) {
                        property = one;
                      } else if (selectedItem == NumberPropertyModel) {
                        property = two;
                      } else {
                        property = three;
                      }
                      setState(() {});
                    },
                    getTitle: (type) {
                      switch (type) {
                        case StringPropertyModel:
                          return loc.textValue;
                        case NumberPropertyModel:
                          return loc.integerValue;
                        case ArrayPropertyModel:
                          return loc.listValue;
                        default:
                          return loc.notSelected;
                      }
                    },
                  ),
                  if (property != null) ...[
                    TextFieldGpt(
                      maxLength: 30,
                      value: property.key,

                      callBack: (String p1) {
                        property.key = p1;
                        if (p1.isNotEmpty) {
                          setState(() {
                            keyNotFilled = false;
                          });
                        }
                      },
                      hintText: loc.parameterName,
                      isNumber: false,
                      onlyLatin: true,
                    ),
                    if (keyNotFilled) Text(loc.fillParameterName, style: TextStyle(fontSize: 12, color: Colors.red)),

                    Text(loc.propertyDescriptionForLLM),

                    //Общие для всех параметры
                    TextFieldGpt(
                      value: property.description,
                      callBack: (String p1) {
                        property.description = p1;
                      },
                      hintText: loc.description,
                      isNumber: false,
                      onlyLatin: false,
                    ),
                    if (selectedItem != ArrayPropertyModel) ...[
                      Text(loc.possibleValuesForLLMChoose),
                      TextFieldGpt(
                        value: property.enums != null ? property.enums!.join(', ') : '',
                        callBack: (String p1) {
                          if (selectedItem == StringPropertyModel) {
                            property.enums = p1.split(',');
                          }
                          if (selectedItem == NumberPropertyModel) {
                            property.enums = p1.split(',').map((e) => num.tryParse(e) ?? 0).toList();
                          }
                          setState(() {});
                        },
                        hintText: loc.listValues,
                        isNumber: false,
                        onlyLatin: false,
                      ),
                      Text(loc.defaultValueIfLLMCannotMakeChoice),
                    ],

                    if (property.runtimeType != ArrayPropertyModel)
                      Wrap(
                        children: [
                          ...(property.enums ?? [])
                              .map(
                                (el) => SizedBox(
                                  width: (30 + (el.toString().length * 12)).toDouble(),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          property.default_value = el;
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                                          ),
                                          height: 20,
                                          width: 20,
                                          padding: EdgeInsets.all(3),
                                          child: el == property.default_value
                                              ? Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                    color: Colors.deepPurpleAccent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ),
                                      ),
                                      Text('$el'),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    //для типа ArrayPropertyModel
                    if (property.runtimeType == ArrayPropertyModel) ...[
                      Text('Объект JSON Schema, описывающий тип каждого элемента в массиве.'),
                      Text(''''"items": {
    "type": "string",
    "enum": ["extra_cheese", "mushrooms", "olives"]
  },'''),
                      Row(
                        spacing: 5,
                        children: [
                          DropDownMenu<VariableTypes>(
                            selectedItem:
                                VariableTypes.values.firstWhereOrNull((e) => e.json == property.items['type']) ??
                                VariableTypes.string,
                            items: VariableTypes.values,
                            onChanged: (value) {
                              property.items['type'] = value?.json;
                              setState(() {});
                            },
                            getTitle: (type) {
                              return type.json;
                            },
                          ),
                          Expanded(
                            child: TextFieldGpt(
                              value: property.items['enum'] != null ? property.items['enum']!.join(', ') : '',
                              callBack: (String p1) {
                                switch (property.items['type']) {
                                  case 'integer':
                                    {
                                      property.enums = p1.split(',').map((e) => num.parse(e)).toList();
                                    }
                                  case 'number':
                                    {
                                      property.enums = p1.split(',').map((e) => num.parse(e)).toList();
                                    }
                                  case 'string':
                                    {
                                      property.enums = p1.split(',').map((e) => e).toList();
                                    }
                                }
                              },
                              hintText: loc.listValues,
                              isNumber: property.items['type'] == 'string',
                              onlyLatin: false,
                            ),
                          ),
                        ],
                      ),
                      Text(loc.minimumAndMaximumNumberElementsInArray),
                      Row(
                        spacing: 5,
                        children: [
                          Expanded(
                            child: TextFieldGpt(
                              value: property.minItems.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                property.minItems = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.minIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                          Expanded(
                            child: TextFieldGpt(
                              value: property.maxItems.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                property.maxItems = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.maxIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                    //для типа NumberPropertyModel
                    if (property.runtimeType == NumberPropertyModel) ...[
                      Text(loc.minimumAndMaximumAllowedValues),
                      Row(
                        spacing: 5,
                        children: [
                          Expanded(
                            child: TextFieldGpt(
                              value: property.minimun.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                print(p1);
                                property.minimun = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.minIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                          Expanded(
                            child: TextFieldGpt(
                              value: property.maximum.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                property.maximum = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.maxIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                        ],
                      ),
                      Text(loc.valueMustStrictlyGreaterLessSpecifiedValue),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldGpt(
                              value: property.exlusiveMinimum.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                property.exlusiveMinimum = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.minIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                          Expanded(
                            child: TextFieldGpt(
                              value: property.exlusiveMaximum.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                property.exlusiveMaximum = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.maxIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                        ],
                      ),
                      Text(loc.valueMustMultipleSpecifiedNumber),
                      TextFieldGpt(
                        value: property.multipleOf.toString(),
                        maxLength: 10,
                        callBack: (String p1) {
                          property.multipleOf = num.tryParse(p1);
                          //setState(() {});
                        },
                        hintText: loc.integerValue,
                        isNumber: true,
                        onlyLatin: false,
                      ),
                    ],
                    //для типа StringPropertyModel
                    if (property.runtimeType == StringPropertyModel) ...[
                      Text(loc.stringLengthLimiter),
                      Row(
                        spacing: 5,
                        children: [
                          Expanded(
                            child: TextFieldGpt(
                              value: property.minLength.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                property.minLength = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.minIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                          Expanded(
                            child: TextFieldGpt(
                              value: property.maxLenght.toString(),
                              maxLength: 10,
                              callBack: (String p1) {
                                print(p1);
                                property.maxLenght = num.tryParse(p1);
                                //setState(() {});
                              },
                              hintText: loc.maxIntegerValue,
                              isNumber: true,
                              onlyLatin: false,
                            ),
                          ),
                        ],
                      ),

                      Text(loc.regexPattern),
                      TextFieldGpt(
                        value: property.pattern ?? '',
                        callBack: (String p1) {
                          property.pattern = p1;
                          setState(() {});
                        },
                        hintText: loc.pattern,
                        isNumber: false,
                        onlyLatin: true,
                      ),
                      Text(loc.formattingReceivedResponse),
                      TextFieldGpt(
                        value: property.format ?? '',
                        callBack: (String p1) {
                          property.format = p1;
                          //setState(() {});
                        },
                        hintText: loc.formatter,
                        isNumber: false,
                        onlyLatin: true,
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(loc.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(loc.accept),
            onPressed: () {
              if (property.key != null) {
                result = property.toJson();
                result['key'] = property.key;
                result['type'] = property.typeLabel;
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
  return result;
}

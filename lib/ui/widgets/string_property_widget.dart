import 'package:flutter/material.dart';
import '../../ui/widgets/text_field_gpt.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../controllers/app_state_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/flowschema_properties_models/string_property_model.dart';
import 'circle_button.dart';

class StringPropertyWidget extends StatefulWidget {
  const StringPropertyWidget({
    super.key,
    required this.setProperty,
    required this.property,
    required this.removeProperty,
    required this.required,
  });

  final StringPropertyModel property;
  final Function(StringPropertyModel) setProperty;
  final Function(StringPropertyModel) removeProperty;
  final List<String> required;

  @override
  State<StringPropertyWidget> createState() => StringPropertyWidgetState();
}

class StringPropertyWidgetState extends State<StringPropertyWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppStateController>();
    final loc = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(minWidth: 400, maxWidth: appState.leftSide),
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              spacing: 5,
              children: [
                Expanded(flex: 3, child: Text('${loc.textValue}: ${widget.property.key}')),
                Spacer(),

                Text(loc.isRequired),
                Checkbox(
                  value: widget.required.contains(widget.property.key),
                  onChanged: (value) {
                    widget.setProperty(widget.property);
                  },
                ),
                CircleButton(
                  onTap: () => widget.removeProperty(widget.property),
                  icon: Icons.delete_forever,
                  color: Colors.red,
                  tooltip: loc.removeProperty,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: Icon(!expanded ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 0.3, color: Colors.grey),
          if (expanded) ...[
            Text(loc.propertyDescriptionForLLM),

            //Общие для всех параметры
            TextFieldGpt(
              value: widget.property.description,
              callBack: (String p1) {
                widget.property.description = p1;
              },
              hintText: loc.description,
              isNumber: false,
              onlyLatin: false,
            ),
            Text(loc.possibleValuesForLLMChoose),
            TextFieldGpt(
              value: widget.property.enums != null ? widget.property.enums!.join(', ') : '',
              callBack: (String p1) {
                widget.property.enums = p1.split(',');
                setState(() {});
              },
              hintText: loc.listValues,
              isNumber: false,
              onlyLatin: false,
            ),
            Text(loc.defaultValueIfLLMCannotMakeChoice),
            Wrap(
              children: [
                ...(widget.property.enums ?? []).map(
                  (el) => SizedBox(
                    width: (30 + (el.toString().length * 12)).toDouble(),
                    child: Row(
                      spacing: 5,
                      children: [
                        InkWell(
                          onTap: () {
                            widget.property.default_value = el;
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
                            child: el == widget.property.default_value
                                ? Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(color: Colors.deepPurpleAccent, shape: BoxShape.circle),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                        Text(el),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(loc.stringLengthLimiter),
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: TextFieldGpt(
                    value: widget.property.minLength.toString(),
                    maxLength: 10,
                    callBack: (String p1) {
                      widget.property.minLength = int.tryParse(p1);
                    },
                    hintText: loc.minIntegerValue,
                    isNumber: true,
                    onlyLatin: false,
                  ),
                ),
                Expanded(
                  child: TextFieldGpt(
                    value: widget.property.maxLenght.toString(),
                    maxLength: 10,
                    callBack: (String p1) {
                      widget.property.maxLenght = int.tryParse(p1);
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
              value: widget.property.pattern ?? '',
              callBack: (String p1) {
                widget.property.pattern = p1;
                setState(() {});
              },
              hintText: loc.pattern,
              isNumber: false,
              onlyLatin: true,
            ),
            Text(loc.formattingReceivedResponse),
            TextFieldGpt(
              value: widget.property.format ?? '',
              callBack: (String p1) {
                widget.property.format = p1;
              },
              hintText: loc.formatter,
              isNumber: false,
              onlyLatin: true,
            ),
          ],
        ],
      ),
    );
  }
}

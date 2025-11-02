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
  });

  final StringPropertyModel property;
  final Function(StringPropertyModel) setProperty;
  final Function(StringPropertyModel) removeProperty;

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
                Checkbox(value: true, onChanged: (value) {}),
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
            TextFieldGpt(
              value: widget.property.description,
              callBack: (String p1) {},
              hintText: loc.description,
              isNumber: false,
              onlyLatin: false,
            ),
            Text(loc.possibleValuesForLLMChoose),

            TextFieldGpt(
              value: widget.property.enums != null ? widget.property.enums!.join(', ') : '',
              callBack: (String p1) {},
              hintText: loc.listValues,
              isNumber: false,
              onlyLatin: false,
            ),
            Text(loc.defaultValueIfLLMCannotMakeChoice),
            Text('TODO тут селектор из имеющихся'),
            TextFieldGpt(
              value: widget.property.default_value ?? '',
              callBack: (String p1) {},
              hintText: 'List of values',
              isNumber: false,
              onlyLatin: false,
            ),
            Text(loc.stringLengthLimiter),
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: TextFieldGpt(
                    value: widget.property.minLength.toString(),
                    callBack: (String p1) {},
                    hintText: loc.minIntegerValue,
                    isNumber: true,
                    onlyLatin: false,
                  ),
                ),
                Expanded(
                  child: TextFieldGpt(
                    value: widget.property.maxLenght.toString(),
                    callBack: (String p1) {},
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
              callBack: (String p1) {},
              hintText: loc.pattern,
              isNumber: false,
              onlyLatin: true,
            ),
            Text(loc.formattingReceivedResponse),
            TextFieldGpt(
              value: widget.property.format ?? '',
              callBack: (String p1) {},
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

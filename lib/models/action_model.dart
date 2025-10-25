import '../utils/enums_lib.dart';
import 'package:json_annotation/json_annotation.dart';

part 'action_model.g.dart';

/// Модель для Actions (pre_actions, post_actions)
@JsonSerializable()
class Action {
  ActionTypes type; // Например: 'tts_say', 'end_conversation', 'function'
  String? text; // Для 'tts_say'
  String? handlerName; // Для 'function'
  //final String? to; // Для 'transfer_call'
  String? codeSnipet;

  Action({
    required this.type,
    this.text,
    this.handlerName,
    //this.to
  });

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

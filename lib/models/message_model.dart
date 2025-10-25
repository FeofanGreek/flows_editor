import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

/// Модель для сообщений (role_messages, task_messages)
@JsonSerializable()
class Message {
  final String role;
  String content;

  Message({required this.role, required this.content});

  @override
  String toString() => 'Message(role: $role, content: "$content")';

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

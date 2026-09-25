import 'package:final_project/model/property.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final List<Property> properties;

  ChatMessage({
    required this.message,
    required this.isUser,
    this.properties = const [],
  });
}
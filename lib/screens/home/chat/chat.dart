import 'package:equatable/equatable.dart';
import 'package:touriso_agent/screens/home/chat/message.dart';

class Chat extends Equatable {
  final String id;
  final Message lastMessage;
  final List<Message> messages;

  const Chat(
      {required this.id, required this.lastMessage, required this.messages});

  Chat.fromFirebase(Map<String, dynamic> map, String chatId)
      : id = chatId,
        lastMessage = Message.fromFirebase(map['lastMessage']),
        messages = (map['messages'] as List)
            .map((e) => Message.fromFirebase(e))
            .toList();

  @override
  List<Object?> get props => [id, lastMessage, messages];
}

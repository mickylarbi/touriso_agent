import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/chat/chat.dart';
import 'package:touriso_agent/screens/home/chat/chats_list_view.dart';
import 'package:touriso_agent/screens/home/chat/messages_list_view.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final ValueNotifier<Chat?> selectedChatNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Chats', style: titleLarge(context)),
                ),
                const Divider(),
                Expanded(
                    child: ChatsListView(
                        selectedChatNotifier: selectedChatNotifier)),
              ],
            ),
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: ValueListenableBuilder<Chat?>(
              valueListenable: selectedChatNotifier,
              builder: (context, value, child) {
                if (value == null) {
                  return const Center(child: EmptyWidget());
                }

                return Center(
                  child: SizedBox(
                    width: 400,
                    child: MessagesListView(chat: value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

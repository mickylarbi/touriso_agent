import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/chat/chat.dart';
import 'package:touriso_agent/screens/home/chat/chat_utils.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatsListView extends StatelessWidget {
  const ChatsListView({
    super.key,
    required this.selectedChatNotifier,
  });
  final ValueNotifier<Chat?> selectedChatNotifier;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: chatsCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CustomErrorWidget());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        List<Chat> chats = snapshot.data!.docs
            .map((e) =>
                Chat.fromFirebase(e.data()! as Map<String, dynamic>, e.id))
            .toList();

        return chats.isEmpty
            ? const Center(child: Text('No chats to show'))
            : ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Chat chat = chats[index];

                  return ListTile(
                    onTap: () {
                      selectedChatNotifier.value = chat;
                    },
                    leading: CircleAvatar(
                      child: Text(
                        chat.id[0].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      chat.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${chat.lastMessage.senderId == 'Touriso' ? 'Touriso' : 'User'}: ${chat.lastMessage.content}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(timeago.format(
                      chat.lastMessage.dateTime,
                      locale: 'en_short',
                    )),
                  );
                },
              );
      },
    );
  }
}

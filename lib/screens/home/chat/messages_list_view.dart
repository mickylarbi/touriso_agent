import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/chat/chat.dart';
import 'package:touriso_agent/screens/home/chat/chat_bubble.dart';
import 'package:touriso_agent/screens/home/chat/chat_utils.dart';
import 'package:touriso_agent/screens/home/chat/message.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({
    super.key,
    required this.chat,
  });
  final Chat chat;

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              widget.chat.id,
              style: titleLarge(context),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: chatDocument(widget.chat.id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('an error occurred'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (snapshot.data == null || snapshot.data!.data() == null) {
                return Text('No messages to show');
              }

              Chat chat = Chat.fromFirebase(
                  snapshot.data!.data() as Map<String, dynamic>,
                  snapshot.data!.id);

              //TODO: empty widget, correct orientation, names and things and move on to articles side

              return ListView.separated(
                itemCount: chat.messages.length,
                itemBuilder: (context, index) =>
                    ChatBubble(message: chat.messages[index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              );
            },
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return Row(
            children: [
              Flexible(
                child: CustomTextFormField(
                  controller: controller,
                  hintText: 'Reply here',
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 20),
              IconButton.filled(
                onPressed: () {
                  try {
                    Map<String, dynamic> messageMap = Message(
                            senderId: 'Touriso',
                            content: controller.text.trim(),
                            dateTime: DateTime.now())
                        .toFirebase();

                    chatDocument(widget.chat.id).update({
                      'messages': FieldValue.arrayUnion([messageMap]),
                      'lastMessage': messageMap,
                    });

                    controller.clear();
                  } catch (e) {
                    print(e);
                    showAlertDialog(context, message: e.toString());
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: controller.text.trim().isEmpty
                      ? Colors.grey
                      : primaryColor,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 40)
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

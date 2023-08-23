import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/chat/message.dart';
import 'package:touriso_agent/utils/text_styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final Message message;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          child: Text(message.senderId[0]),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.senderId,
              style: bodySmall(context)
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(message.content),
            ),
            Text(
              timeago.format(message.dateTime),
              style: bodySmall(context).copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Touriso',
              style: bodySmall(context).copyWith(
                  fontWeight: FontWeight.bold, color: Colors.pink[900]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(message.content),
            ),
            Text(
              timeago.format(message.dateTime),
              style: bodySmall(context).copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.pink[900],
          child: const Text(
            'T',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: message.senderId == 'Touriso'
            ? myMessage(context)
            : otherMessage(context),
      ),
    );
    //TODO: add time ago things
  }
}

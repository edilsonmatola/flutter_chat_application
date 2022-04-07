import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({Key? key, required this.message, required this.isMe})
      : super(key: key);

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8, left: 4),
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isMe ? Colors.teal : Colors.grey[600],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

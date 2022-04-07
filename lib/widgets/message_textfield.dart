import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  MessageTextField({Key? key, required this.currentId, required this.friendId})
      : super(key: key);

  final String currentId;
  final String friendId;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                labelText: 'Write a message',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                  ),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () async {
              final message = _textController.text;
              _textController.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add(
                {
                  'senderId': widget.currentId,
                  'receiverId': widget.friendId,
                  'message': message,
                  'type': 'text',
                  'dateTime': DateTime.now(),
                },
              ).then(
                (value) => {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentId)
                      .collection('messages')
                      .doc(widget.friendId)
                      .set(
                    {
                      'last_message': message,
                    },
                  )
                },
              );

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendId)
                  .collection('messages')
                  .doc(widget.currentId)
                  .collection('chats')
                  .add(
                {
                  'senderId': widget.currentId,
                  'receiverId': widget.friendId,
                  'message': message,
                  'type': 'text',
                  'dateTime': DateTime.now(),
                },
              ).then(
                (value) => {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.friendId)
                      .collection('messages')
                      .doc(widget.currentId)
                      .set(
                    {
                      'last_message': message,
                    },
                  ),
                },
              );
            },
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

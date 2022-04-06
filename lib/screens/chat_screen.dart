import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../widgets/message_textfield.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    Key? key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  }) : super(key: key);

  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.network(
                friendImage,
                height: 35,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              friendName,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Container(),
              ),
            ),
            MessageTextField(
              currentId: currentUser.uid,
              friendId: friendId,
            ),
          ],
        ),
      ),
    );
  }
}

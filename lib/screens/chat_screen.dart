import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../widgets/message_bubble.dart';
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
              child: CachedNetworkImage(
                height: 40,
                imageUrl: friendImage,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: Colors.white,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline,
                ),
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
      body: Column(
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy(
                      'dateTime',
                      descending: true,
                    )
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Say Hi',
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final isMe = snapshot.data!.docs[index]['senderId'] ==
                            currentUser.uid;
                        return MessageBubble(
                          message:
                              snapshot.data!.docs[index]['message'] as String,
                          isMe: isMe,
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          MessageTextField(
            currentId: currentUser.uid,
            friendId: friendId,
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'chat_screen.dart';
import 'search_screen.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'Home',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection('messages')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Chats Available',
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final friendId = snapshot.data!.docs[index].id;
                final lastMessage = snapshot.data!.docs[index]['last_message'];
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(friendId)
                      .get(),
                  builder: (context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      final friend = asyncSnapshot.data;
                      return ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUser: widget.user,
                              friendId: friend['uid'] as String,
                              friendName: friend['userName'] as String,
                              friendImage: friend['image'] as String,
                            ),
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: CachedNetworkImage(
                            height: 50,
                            imageUrl: friend['image'] as String,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error_outline,
                            ),
                          ),
                        ),
                        title: Text(
                          friend['userName'] as String,
                        ),
                        subtitle: Text(
                          '$lastMessage',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                    return LinearProgressIndicator(
                      color: Colors.white,
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                user: widget.user,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.search_outlined,
        ),
      ),
    );
  }
}

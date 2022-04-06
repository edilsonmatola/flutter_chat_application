import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map> searchResult = [];

  bool isLoading = false;

  Future<void> onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where(
          'name',
          isEqualTo: searchController.text,
        )
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(
                seconds: 3,
              ),
              elevation: 2,
              content: Center(
                child: Text(
                  'No users found',
                ),
              ),
            ),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
        for (final user in value.docs) {
          if (user.data()['email'] != widget.user.email) {
            searchResult.add(
              user.data(),
            );
          }
        }
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search your friends',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Type username',
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: onSearch,
                          icon: const Icon(
                            Icons.search_outlined,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (searchResult.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Image.network(
                          searchResult[index]['image'] as String,
                        ),
                      ),
                      title: Text(
                        searchResult[index]['name'] as String,
                      ),
                      subtitle: Text(
                        searchResult[index]['email'] as String,
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message_outlined,
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (isLoading == true)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}

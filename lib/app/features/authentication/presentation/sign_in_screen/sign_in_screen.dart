import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  Future signInUser() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final userExist = await firestoreDB
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (userExist.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(
            seconds: 3,
          ),
          content: Center(
            child: Text(
              'User Already exists',
            ),
          ),
        ),
      );
    } else {
      await firestoreDB.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'userName': userCredential.user!.displayName,
          'image': userCredential.user!.photoURL,
          'dateTime': DateTime.now(),
        },
      );
    }

    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
      (route) => false,
    );
  }

  late double deviceWidth = MediaQuery.of(context).size.width;
  late double deviceHeight = MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: deviceWidth * 0.8,
                  height: deviceHeight * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'http://cdn.onlinewebfonts.com/svg/img_382824.png',
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Chat App',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    await signInUser();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png',
                        height: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Sign In with Google',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

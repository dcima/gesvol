import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gesvol/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {

    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    User? user = FirebaseAuth.instance.currentUser;


    /*if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    }*/
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      authProvider.setCustomParameters({
        'client_id': '158895990793-4lseu4mff4bcnaeja3oiod850incvno3.apps.googleusercontent.com',
        'hd': 'gevbologna.org',
        'prompt' : 'select_account',
      });
      authProvider.addScope('openid');
      authProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      authProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
      authProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '158895990793-4lseu4mff4bcnaeja3oiod850incvno3.apps.googleusercontent.com',
        hostedDomain: 'gevbologna.org',
        scopes: <String>[
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);
          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential.',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
        }
      }
   }

    return user;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Disconnessione effettuata',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

}
import 'dart:async';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gesvol/utils/firebase_options.dart';
import 'package:gesvol/utils/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    User? user = FirebaseAuth.instance.currentUser;
    Helper.userFirebase = user;
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      print('>>>>>>>>>>>>>>>>>>> kIsWeb <<<<<<<<<<<<<<<<<<');
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      authProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      authProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
      authProvider.addScope('https://www.googleapis.com/auth/youtube.readonly');
      authProvider.addScope('https://www.googleapis.com/auth/admin.directory.group');
      authProvider.addScope('https://www.googleapis.com/auth/admin.directory.group.member');

      authProvider.setCustomParameters({
        'client_id': '158895990793-4lseu4mff4bcnaeja3oiod850incvno3.apps.googleusercontent.com',
        'hd': 'gevbologna.org',
        'prompt' : 'select_account',
      });
      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);
        print('userCredential: $userCredential');
        print("-------------------------------------------------------------------");
        print('userCredential.credential: $userCredential.credential');
        print("-------------------------------------------------------------------");
        user = userCredential.user;
        print('user: user');
        Helper.authClient = userCredential.credential;
        print('Helper.authClient: $Helper.authClient');
      } catch (e) {
        print(e.toString());
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '158895990793-4lseu4mff4bcnaeja3oiod850incvno3.apps.googleusercontent.com',
        hostedDomain: 'gevbologna.org',
        scopes: <String>[
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/youtube.readonly',
          'https://www.googleapis.com/auth/admin.directory.group',
          'https://www.googleapis.com/auth/admin.directory.group.member'
        ],
      );
      if (googleSignIn != null) {
        Helper.googleSignIn = googleSignIn;
        final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        Helper.authClient  = await googleSignIn.authenticatedClient();

        print(Helper.googleSignIn?.currentUser?.authHeaders);
        print(Helper.authClient.toString());

        if (googleSignInAccount != null && Helper.authClient  != null) {
          if (googleSignInAccount != null) {
            final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );
            try {
              final UserCredential userCredential = await auth
                  .signInWithCredential(credential);
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
      }
    }

    Helper.userGoogle = user;

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

import 'dart:async';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gesvol/utils/firebase_options.dart';
import 'package:gesvol/utils/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/admin/directory_v1.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
    print('initializeFirebase');
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Helper.userFirebase = FirebaseAuth.instance.currentUser;
    return firebaseApp;
  }

  static Future<UserCredential> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: '158895990793-4lseu4mff4bcnaeja3oiod850incvno3.apps.googleusercontent.com',
      hostedDomain: 'gevbologna.org',
      scopes: <String>[
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
        'https://www.googleapis.com/auth/youtube.readonly',
        'https://www.googleapis.com/auth/admin.directory.group',
        'https://www.googleapis.com/auth/admin.directory.group.member',
        DirectoryApi.adminDirectoryGroupMemberScope,
        DirectoryApi.adminDirectoryGroupMemberReadonlyScope,
      ],
    );

    Helper.userGoogle = await googleSignIn.signIn();
    Helper.googleAuth = await Helper.userGoogle?.authentication;
    Helper.httpClient =  (await googleSignIn.authenticatedClient())!;

    final credential = GoogleAuthProvider.credential(
      accessToken: Helper.googleAuth?.accessToken,
      idToken: Helper.googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);

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

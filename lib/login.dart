// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:gesvol/dashboard.dart';
import 'package:gesvol/helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId: '158895990793-4lseu4mff4bcnaeja3oiod850incvno3.apps.googleusercontent.com',
  hostedDomain: 'gevbologna.org',
  scopes: <String>[
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    print("initState");

    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        Helper.currentUser = account;
      });
    });
  }

  Future<void> _handleSignIn(context) async {
    print("_handleSignIn");

    try {
      await _googleSignIn.signIn();
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashboard()));
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Center(
        child: SizedBox(
            width: 96,
            height: 120,
            child: Image.asset('assets/logo-cpgev-bologna_96.png')),
      ),
    );
  }

  Widget welcomeLogin(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
      child: Column(
        children: [
          Text(
              AppLocalizations.of(context)!.welcomeLogin,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              AppLocalizations.of(context)!.pressBelowButton,
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: SignInButton(
        Buttons.Google,
        text: AppLocalizations.of(context)!.signInWithGoogle,
        onPressed: () {
          _handleSignIn(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginPage),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Container(
              width: 380,
              height: 520,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(4, 16), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  buildLogo(context),
                  welcomeLogin(context),
                  buildLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
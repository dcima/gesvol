// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:gesvol/dashboard.dart';
import 'package:gesvol/utils/authentication.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
      padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
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
                textStyle: const TextStyle(
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

  Widget buildFuture(BuildContext context) {
    return FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return const GoogleSignInButton();
        }
        return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.loginPage),
        ),
        body: SingleChildScrollView(
          child: Center(
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
                  buildFuture(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : SignInButton(
              Buttons.Google,
              text: AppLocalizations.of(context)!.signInWithGoogle,
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user =  await Authentication.signInWithGoogle(context: context);
                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Dashboard( user: user  ),
                    ),
                  );
                }
              },
            ),
    );
  }
}


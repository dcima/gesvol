// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:gesvol/screen/dashboard.dart';
import 'package:gesvol/utils/authentication.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Center(
        child: SizedBox(
            width: 96,
            height: 120,
            child: Image.asset('assets/logos/logo-cpgev.png')),
      ),
    );
  }

  Widget welcomeLogin(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                  AppLocalizations.of(context)!.welcomeLogin,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                    ),
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                AppLocalizations.of(context)!.pressBelowButton,
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                  textStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ),
            ),
          ],
        ),
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
    return Stack(
      children: [
        Image.asset(
          "images/bosco_autunnale.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.drawerDashboard),
          ),
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                /*boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(4, 16), // changes position of shadow
                  ),
                ],*/
                gradient: const LinearGradient(
                  colors: [Color(0xff5bb85f), Color(0xff62fff0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              height: 460,
              margin: const EdgeInsets.all(16.0),
              width: 280,
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
    ]);
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: SignInButton(
                Buttons.Google,
                text: AppLocalizations.of(context)!.signInWithGoogle,
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  await Authentication.signInWithGoogle(context: context);
                  setState(() {
                    _isSigningIn = false;
                  });

                  if (Helper.userGoogle  != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
                  }
                },
              ),
          ),
    );
  }
}


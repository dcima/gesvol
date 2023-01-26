// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/dashboard.dart';
import 'package:gesvol/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailOk = RegExp(r'^[a-zA-Z0-9_.]+@gevbologna.org+$');
  final passwdOk = RegExp(r'^[a-zA-Z0-9_.!$%&@?*,;.:]{1,16}$');
  FocusNode emailFN = FocusNode();
  FocusNode passwdFN = FocusNode();
  FocusNode loginBtnFN = FocusNode();

  // Initially password is obscure
  bool _isObscure  = true;

  TextEditingController userInput = TextEditingController();
  String email = "";
  String password = "";

  @override
  void dispose() {
    userInput.dispose();
    super.dispose();
  }

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

  Widget buildEmailField(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:TextFormField(
          autofocus: true,
          controller: userInput,
          //textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email dominio gevbologna.org obbligatoria';
            } else if( emailOk.hasMatch(value))  {
              email = value.toString();
              //FocusScope.of(context).requestFocus(passwdFN);
              return null;
            } else {
                return 'Email nel formato: nome.cognome@gevbologna.org';
            }
          },
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            focusColor: Colors.white,
            prefixIcon: const Icon(
              Icons.email,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.blue, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            fillColor: Colors.grey,
            hintText: "Es. nome.cognome@gevbologna.org",
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: "verdana_regular",
              fontWeight: FontWeight.w400,
            ),
            labelText: 'Email',
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: "verdana_regular",
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      //padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        obscureText: _isObscure,
        //textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password obbligatoria';
          } else if( passwdOk.hasMatch(value))  {
            password = value.toString();
            //FocusScope.of(context).requestFocus(loginBtnFN);
            return null;
          } else {
            return 'Password non valida. Caratteri ammessi: "[a-zA-Z0-9_.!\$%&@?*,;.:]" e lunghezza da 1 a 16';
          }
        },
        decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
                icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
            ),
        ),
      ),
    );
  }

  Widget buildForgotPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: (){
          //TODO FORGOT PASSWORD SCREEN GOES HERE
        },
        child: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.blue, fontSize: 15),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            Helper.snackMsg(context, 'Controlla i campi!');
          } else {
            try {
              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
              );
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashboard()));
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                Helper.snackMsg(context, 'No user found for that email');
              } else if (e.code == 'wrong-password') {
                Helper.snackMsg(context, 'Wrong password provided for that user.');
              }
            }


          }
        },
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).loginPage),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
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
                  buildEmailField(context),
                  buildPasswordField(context),
                  buildForgotPasswordButton(context),
                  buildLoginButton(context),

                  const SizedBox(
                    height: 40,
                  ),
                  const Text('New User? Create Account')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gesvol/dashboard.dart';
import 'package:gesvol/list_domain_users.dart';
import 'package:gesvol/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it'), // Italiano
        Locale('en'), // Inglese
        Locale('es'), // Español
        Locale('fr'), // Francaise
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/dashboard'              : (context) => const Dashboard(),
        '/list_domain_users'      : (context) => const ListDomainUsers(),
      },

    );
  }
}
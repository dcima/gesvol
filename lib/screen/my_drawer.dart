import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/utils/authentication.dart';
import 'package:gesvol/utils/helper.dart';

import 'login.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? _user = Helper.userGoogle;
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        children:   [
          UserAccountsDrawerHeader(
            accountName: Text(_user!.displayName!),
            accountEmail: Text(_user!.email!),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(_user!.photoURL!),
              backgroundColor: Colors.transparent,
              onBackgroundImageError: (e, s) {
                debugPrint('image issue, $e,$s');
              },
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://archive.org/download/nav-menu-header-bg/nav-menu-header-bg.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            /*otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage("https://randomuser.me/api/portraits/women/74.jpg")),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/47.jpg"),
                ),
              ],*/
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.drawerDashboard),
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.domain),
            title: Text(AppLocalizations.of(context)!.drawerListMyVideos),
            onTap: () {
              Navigator.pushNamed(context, '/list_my_videos');
            },
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.drawerLogout),
              onTap: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              }),
        ],
      ),
    );

  }
}
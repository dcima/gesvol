import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/utils/helper.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  final User? _user = Helper.userGoogle;
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
            leading: const Icon(Icons.domain),
            title: Text(AppLocalizations.of(context)!.drawerListNations),
            onTap: () {
              Navigator.pushNamed(context, '/list_nations');
            },
          ),
          Helper.logoff(context),
        ],
      ),
    );
  }
}
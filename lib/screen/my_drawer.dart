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
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        children:   [
          UserAccountsDrawerHeader(
            accountName: Text(Helper.userGoogle!.displayName!),
            accountEmail: Text(Helper.userGoogle!.email!),
            onDetailsPressed: () {
              print(Helper.userGoogle?.id);
              Helper.snackBarPop(context, Helper.userGoogle?.id);
            },
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(Helper.userGoogle!.photoUrl!),
              backgroundColor: Colors.transparent,
              onBackgroundImageError: (e, s) {
                debugPrint('image issue, $e,$s');
              },
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/nav-menu-header-bg.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context)!.drawerDashboard),
            onTap: () {
              if( ModalRoute.of(context)?.settings.name == '/dashboard') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/dashboard');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: Text(AppLocalizations.of(context)!.drawerListMyContacts),
            onTap: () {
              if( ModalRoute.of(context)?.settings.name == '/list_my_contacts') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/list_my_contacts');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: Text(AppLocalizations.of(context)!.drawerListMyGroups),
            onTap: () {
              if( ModalRoute.of(context)?.settings.name == '/list_my_groups') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/list_my_groups');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(AppLocalizations.of(context)!.drawerListMyVideos),
            onTap: () {
              if( ModalRoute.of(context)?.settings.name == '/list_my_videos') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/list_my_videos');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: Text(AppLocalizations.of(context)!.drawerListNations),
            onTap: () {
              if( ModalRoute.of(context)?.settings.name == '/list_nations') {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/list_nations');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.drawerLogout),
            onTap: () {
              Helper.logoff(context);
            },
          ),
        ],
      ),
    );
  }
}
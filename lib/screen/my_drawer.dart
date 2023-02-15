import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/utils/authentication.dart';
import 'package:gesvol/utils/helper.dart';

import 'login.dart';

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
          ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.drawerLogout),
              onTap: ()  {
                // set up the buttons
                Widget cancelButton = TextButton(
                  child: Text("Cancel"),
                  onPressed:  () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
                Widget continueButton = TextButton(
                  child: Text("Continue"),
                  onPressed:  () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await Authentication.signOut(context: context);
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => Login()),
                        ModalRoute.withName('/')
                    );
                  },
                );
                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Conferma"),
                  content: Text("Confermi uscita dall'applicazione ?"),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );
                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }),
        ],
      ),
    );

  }
}
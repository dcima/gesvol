import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gesvol/utils/authentication.dart';

import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late User _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  Widget getDrawer() {
    return  Drawer(
        child: ListView(
          children:   [
            UserAccountsDrawerHeader(
              accountName: Text(_user!.displayName!),
              accountEmail: Text(_user!.email!),
              currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  //backgroundImage: NetworkImage(Helper.currentUser!.photoUrl!.replaceAll("s96-c", "s192-c")),
                  backgroundImage: NetworkImage(
                      _user.photoURL!.isEmpty ?
                      "https://as2.ftcdn.net/v2/jpg/04/81/46/87/1000_F_481468761_wL1IyJr5atPekfwhSK3dXtI1l6TOzw3T.jpg"
                      :
                      _user.photoURL!,
                  ),
                  backgroundColor: Colors.transparent,
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
              title: Text(AppLocalizations.of(context)!.loginPage),
              onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: getDrawer(),
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Welcome',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gesvol/helper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget getDrawer() {
    return  Drawer(
        child: ListView(
          children:   [
            UserAccountsDrawerHeader(
              accountName: Text(Helper.currentUser!.displayName!),
              accountEmail: Text(Helper.currentUser!.email!),
              currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(Helper.currentUser!.photoUrl!.replaceAll("s96-c", "s192-c")),
                  backgroundColor: Colors.transparent,
              ),
              decoration: BoxDecoration(
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
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("About"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.grid_3x3_outlined),
              title: Text("Products"),
            onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("Contact"),
              onTap: () {},
            ),
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
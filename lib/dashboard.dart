import 'package:flutter/material.dart';
import 'package:gesvol/my_drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          child: Text(
              'Welcome',
              style: TextStyle(color: Colors.red, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
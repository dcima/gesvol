import 'package:flutter/material.dart';
import 'package:gesvol/screen/my_drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
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
      drawer: const MyDrawer(),
      body: const Center(
        child: SizedBox(
          height: 80,
          width: 150,
          child:  Text(
              'Welcome',
              style: TextStyle(color: Colors.red, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
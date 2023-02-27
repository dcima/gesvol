import '../../utils/helper.dart';
import 'package:flutter/material.dart';

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

  Widget getBody(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 80,
        width: 150,
        child: Text(
          'Welcome',
          style: TextStyle(color: Colors.red, fontSize: 25),
        ),
      ),
    );
  }

  @override Widget build(BuildContext context) {
    return Helper.doBuild(context, "Dashboard", getBody(context));
  }
}
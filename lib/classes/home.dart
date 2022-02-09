import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  static const batteryChannel = MethodChannel('com.project/battery');

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }

  // getting data from mainactivity.java
  Future getBatteryLevel() async {
    final String _newPass =
        await batteryChannel.invokeMethod('getBatteryLevel');
    // setState(() {
    //   _password = _newPass;
    // });
  }
}

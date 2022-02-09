import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  static const batteryChannel = MethodChannel('com.project/battery');

  String _password = 'Getting..';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(_password),
          ),
          ElevatedButton(
            onPressed: () {
              getBatteryLevel();
            },
            child: const Text('Get Password'),
          ),
        ],
      ),
    );
  }

  Future getBatteryLevel() async {
    final String _newPass =
        await batteryChannel.invokeMethod('getBatteryLevel');
    setState(() {
      _password = _newPass;
    });
  }
}

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeevayu/devices-state/dev_paired.dart';
import 'package:jeevayu/devices-state/dev_unpaired.dart';
import 'package:jeevayu/features/notification_api.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  static const deviceChannel = MethodChannel('com.project/deviceState');
  static const method1 = MethodChannel('com.project/DeviceID');

  late String _devID = "";

  @override
  void initState() {
    getID();
    super.initState();
    NotificationApi.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _devID.isEmpty ? const DeviceUnpaired() : const DevicePaired(),
    );
  }

  Future getID() async {
    final String _val = await method1.invokeMethod('getDeviceID');
    setState(() {
      _devID = _val;
    });
    if (_devID.isEmpty) {
      print('Trig 1');
      setPrefNo();
    } else if (_devID.length > 2) {
      print('Trig 2');
      setPrefYes();
    }
  }

  Future setPrefNo() async {
    await deviceChannel.invokeMethod('setPreferenceNo');
  }

  Future setPrefYes() async {
    await deviceChannel.invokeMethod('setPreferenceYes');
  }

  Future<void> setDevIDNo() async {
    var data = <String, dynamic>{"data": ""};
    String value = await method1.invokeMethod("setDeviceID", data);
    print(value);
  }
}

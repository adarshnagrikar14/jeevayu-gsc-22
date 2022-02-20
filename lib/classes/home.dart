// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    super.initState();
    getID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // body: _devState.length == 2 || _devState.isEmpty
      body: _devID.isEmpty
          ? const Center(
              child: Text('No Device Paired'),
            )
          : Center(
              child: Text(_devID),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setDevIDNo();
        },
        child: const Icon(Icons.stop_circle),
      ),
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

class DevicePaired extends StatefulWidget {
  const DevicePaired({Key? key}) : super(key: key);

  @override
  _DevicePairedState createState() => _DevicePairedState();
}

class _DevicePairedState extends State<DevicePaired> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Dev paired'),
    );
  }
}

class DeviceUnpaired extends StatefulWidget {
  const DeviceUnpaired({Key? key}) : super(key: key);

  @override
  _DeviceUnpairedState createState() => _DeviceUnpairedState();
}

class _DeviceUnpairedState extends State<DeviceUnpaired> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: const Center(
        child: Text('Dev not paired'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  static const deviceChannel = MethodChannel('com.project/deviceState');
  late String _devState = "no";

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _devState.length == 2 || _devState.isEmpty
          ? const DeviceUnpaired()
          : const DevicePaired(),
    );
  }

  Future getPref() async {
    final String state = await deviceChannel.invokeMethod('getPreference');
    setState(() {
      _devState = state;
    });
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
    return const Center(
      child: Text('Dev not paired'),
    );
  }
}

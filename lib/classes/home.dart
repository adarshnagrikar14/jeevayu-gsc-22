// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeevayu/helpers/qr_reader.dart';

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

class DevicePaired extends StatefulWidget {
  const DevicePaired({Key? key}) : super(key: key);

  @override
  _DevicePairedState createState() => _DevicePairedState();
}

class _DevicePairedState extends State<DevicePaired> {
  static const method1 = MethodChannel('com.project/DeviceID');
  late String _devID = "";

  @override
  void initState() {
    super.initState();
    getID();
  }

  Future getID() async {
    final String _val = await method1.invokeMethod('getDeviceID');
    setState(() {
      _devID = _val;
    });
  }

  Future<void> setDevIDNo() async {
    var data = <String, dynamic>{"data": ""};
    String value = await method1.invokeMethod("setDeviceID", data);
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Text('Device paired - $_devID'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            setDevIDNo();
          },
          child: const Icon(Icons.stop),
        ));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/social/home.png"),
              width: MediaQuery.of(context).size.width,
            ),

            // txt
            const Text(
              'Welcome!\nYou can now Connect a Device.',
              // "",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            // btn
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white10,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(
                        color: Colors.lightGreen,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QrReader()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                      fontSize: 23.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

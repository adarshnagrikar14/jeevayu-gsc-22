// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeevayu/helpers/address.dart';
import 'package:jeevayu/helpers/history.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String _versionName = "";

  // msg to display
  late bool _allowedCommTab;

  // chnnel1
  static const prefChannel = MethodChannel('com.project/deviceState');

  // chnnel2
  static const notChannel = MethodChannel('com.project/notificationControl');

  static const method1 = MethodChannel('com.project/DeviceID');
  late String _devID = "";
  late String _number = "";

  @override
  void initState() {
    super.initState();

    // packg name
    getPackageName();

    // get pref for displaying msg
    getPref();

    // get id
    getID();

    // get no.
    getNum();
  }

  Future getID() async {
    final String _val = await method1.invokeMethod('getDeviceID');
    setState(() {
      _devID = _val;
    });
  }

  Future getNum() async {
    var collection = FirebaseFirestore.instance.collection('Providers');
    var docSnapshot = await collection.doc(_devID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String _value = data?['Number'];
      setState(() {
        _number = _value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        toolbarHeight: 60.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 35.0, top: 20.0),
                child: Image(
                  image: AssetImage('assets/social/settings.png'),
                  height: 120,
                  width: 120,
                ),
              ),
              // notification tile
              ListTile(
                subtitle: const Text(
                  'Customize the way notification is displayed',
                  style: TextStyle(fontSize: 13.0),
                ),
                leading: Icon(
                  Icons.notifications_none,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
                onTap: () {
                  openNotificationSetting();
                },
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // hist tile
              ListTile(
                subtitle: const Text(
                  'See previous activities',
                  style: TextStyle(fontSize: 13.0),
                ),
                onTap: () {
                  openHistory();
                },
                leading: Icon(
                  Icons.history,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
                title: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // comm tile
              ListTile(
                subtitle: const Text(
                  'Communicate the registered service provider',
                  style: TextStyle(fontSize: 13.0),
                ),
                onTap: () {
                  openCommunicationTab();
                },
                leading: Icon(
                  Icons.comment_outlined,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
                title: const Text(
                  'Communication',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // comm tile
              ListTile(
                subtitle: const Text(
                  'Update the address you provided.',
                  style: TextStyle(fontSize: 13.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddressUpdate()),
                  );
                },
                leading: Icon(
                  Icons.location_on_outlined,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
                title: const Text(
                  'Update Address',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // help tile
              ListTile(
                title: const Text(
                  'Help Center',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
                onTap: () {
                  openHelp();
                },
                leading: Icon(
                  Icons.help_outline,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
              ),

              // pp tile
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
                onTap: () {
                  openPP();
                },
                leading: Icon(
                  Icons.privacy_tip_outlined,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
              ),

              // about tile
              ListTile(
                title: const Text(
                  'About Us',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
                onTap: () {
                  openAbout();
                },
                leading: Icon(
                  Icons.info_outline,
                  size: 25.0,
                  color: Colors.green.shade400,
                ),
              ),

              // version tile
              ListTile(
                subtitle: Text(
                  'Version $_versionName',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    setState(() {
      _versionName = version;
    });
  }

  void openNotificationSetting() async {
    await notChannel.invokeMethod('openNotification');
  }

  void openHistory() {
    // history page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const History(),
      ),
    );
  }

  void openCommunicationTab() {
    getPref();
    getNum();
    if (_allowedCommTab) {
      showCommDialog(true);
    } else {
      showCommDialog(false);
    }
  }

  void openHelp() {}

  void openPP() {}

  void openAbout() {}

  // get the pref
  Future getPref() async {
    final String state = await prefChannel.invokeMethod('getPreference');

    if (state.length == 2) {
      setState(() {
        _allowedCommTab = false;
      });
    } else if (state.isEmpty) {
      setState(() {
        _allowedCommTab = false;
      });
    } else {
      setState(() {
        _allowedCommTab = true;
      });
    }
  }

  showCommDialog(bool _allowed) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          backgroundColor: Colors.grey[850],
          content: SizedBox(
            width: 300.0,
            height: 250.0,

            // design start here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // heading:
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 6.0),
                    child: Text(
                      'Communicate',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  flex: 1,
                ),

                // first div:
                const Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),

                // display msg
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _allowed
                            ? "Contact No. - $_number \nThis is the contact no. of Service provider."
                            : "No Service provider found. Try connecting the device.",
                        style: const TextStyle(
                          fontSize: 18.0,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  flex: 3,
                ),

                // button
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        _allowed ? "Done" : "Ok",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

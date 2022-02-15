// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const deviceChannel = MethodChannel('com.project/deviceState');

  @override
  void initState() {
    super.initState();

    // packg name
    getPackageName();

    // get pref for displaying msg
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // notification tile
              ListTile(
                subtitle:
                    const Text('Customize the way notification is displayed'),
                onTap: () {
                  openNotificationSetting();
                },
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // hist tile
              ListTile(
                subtitle: const Text('See previous activities'),
                onTap: () {
                  openHistory();
                },
                title: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // comm tile
              ListTile(
                subtitle:
                    const Text('Communicate the registered service provider'),
                onTap: () {
                  openCommunicationTab();
                },
                title: const Text(
                  'Communication',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
              ),

              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),

              // help tile
              ListTile(
                subtitle: const Text(
                  'Help Center',
                  style: TextStyle(fontSize: 17.0),
                ),
                onTap: () {
                  openHelp();
                },
              ),

              // pp tile
              ListTile(
                subtitle: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 17.0),
                ),
                onTap: () {
                  openPP();
                },
              ),

              // about tile
              ListTile(
                subtitle: const Text(
                  'About Us',
                  style: TextStyle(fontSize: 17.0),
                ),
                onTap: () {
                  openAbout();
                },
              ),

              // version tile
              ListTile(
                subtitle: Text(
                  'Version $_versionName',
                  style: const TextStyle(fontSize: 17.0),
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

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    setState(() {
      _versionName = version;
    });
    // String buildNumber = packageInfo.buildNumber;
  }

  void openNotificationSetting() {}

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
    final String state = await deviceChannel.invokeMethod('getPreference');

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
                            ? "Contact No. - "
                            : "No Service provider found. Try connecting the device.",
                        style: const TextStyle(
                          fontSize: 18.0,
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

// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jeevayu/classes/notification.dart';
import 'package:jeevayu/classes/home.dart';
import 'package:jeevayu/classes/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: library_prefixes
import 'package:jeevayu/classes/settings.dart' as SettingClass;
import 'package:jeevayu/features/notification-api.dart';
import 'package:jeevayu/features/video_message.dart';
import 'package:jeevayu/helpers/qr_reader.dart';
import 'package:jeevayu/splashscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // msg to display
  late bool _allowVideoMsg;

  // chnnel1
  static const deviceChannel = MethodChannel('com.project/deviceState');

  // bottom color
  final Color _bluedark = HexColor('25383c');

  final User? user = FirebaseAuth.instance.currentUser;
  late String _profile;

  @override
  void initState() {
    super.initState();

    // allow video msg or not
    getPref();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.light, // change the brightness of the icons
        statusBarColor: Colors.black,
        systemNavigationBarColor: _bluedark,
      ),
    );

    // get profile
    setState(() {
      _profile = user!.photoURL!;
    });
  }

  Future<bool> onBackPress() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  final List<Widget> _widgetOptions = const <Widget>[
    DashBoard(),
    NotificationActivity(),
    // Settings(),
    Account(),
  ];

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.light, // change the brightness of the icons
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black87,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        // Appbar:
        appBar: AppBar(
          title: Text(
            _selectedIndex == 2 ? ' ' : ' Jeevayu',
            style: GoogleFonts.redressed(
                //satisfy, courgette
                textStyle: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            )),
          ),
          actions: <Widget>[
            // settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                child: const Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: "Qr Scan",
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  handleScan();
                },
              ),
            ),

            // help
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                child: const Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: "Video Message",
                  child: Icon(
                    Icons.videocam_rounded,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  // openYoutube();
                  openVideoDialog();
                },
              ),
            ),

            // settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                child: const Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: "Settings",
                  child: Icon(
                    Icons.settings,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingClass.Settings()),
                  );
                },
              ),
            ),
          ],
          toolbarHeight: 60.0,
          backgroundColor: Colors.grey[900],
          elevation: 0,
          // shadowColor: Colors.grey[400],
        ),

        // Bottom nav bar
        bottomNavigationBar: SizedBox(
          height: 82.0,
          child: Scaffold(
            backgroundColor: _bluedark,
            body: FloatingNavbar(
              onTap: (int val) {
                setState(() {
                  _selectedIndex = val;
                });
              },
              currentIndex: _selectedIndex,
              backgroundColor: _bluedark,
              borderRadius: 10.0,
              itemBorderRadius: 50.0,
              iconSize: 25.0,
              unselectedItemColor: Colors.green.shade100,
              selectedItemColor: Colors.white,
              selectedBackgroundColor: Colors.green.shade500,
              items: [
                FloatingNavbarItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                ),
                FloatingNavbarItem(
                  icon: Icons.notifications_none,
                  title: 'Notification',
                ),
                FloatingNavbarItem(
                  // icon: Icons.account_circle_rounded,
                  customWidget: CircleAvatar(
                    backgroundImage: NetworkImage(_profile),
                    radius: 12,
                  ),
                  title: 'Profile',
                ),
              ],
            ),
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  openVideoDialog() {
    getPref();

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
                      'Video Message',
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
                        _allowVideoMsg
                            ? "You can Record the video message and send it to the registered service provider."
                            : "Can't Record Video message as the device is not registered with any Service.",
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
                        if (_allowVideoMsg) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VideoMessage(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        _allowVideoMsg ? "Proceed" : "Ok",
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

  // get the pref
  Future getPref() async {
    final String state = await deviceChannel.invokeMethod('getPreference');

    if (state.length == 2) {
      setState(() {
        _allowVideoMsg = false;
      });
    } else if (state.isEmpty) {
      setState(() {
        _allowVideoMsg = false;
      });
    } else {
      setState(() {
        _allowVideoMsg = true;
      });
    }
  }

  void handleScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrReader()),
    );
    if (result.toString().length == 16) {
      String liveDate =
          DateFormat('dd/MM/yy').format(DateTime.now()).toString();
      String liveTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
      String _id = result.toString();

      FirebaseFirestore.instance.runTransaction(
        (Transaction transaction) async {
          DocumentReference reference = FirebaseFirestore.instance
              .collection('Notifications')
              .doc(user!.uid)
              .collection("Notifications")
              .doc();

          await reference.set(
            {
              "Body": "Your device is registered with device ID - $_id",
              "Date": liveDate,
              "Time": liveTime,
              "Type": "Message"
            },
          ).whenComplete(() {
            // handle notification
            handleNotification("Device Connected",
                "Device is registered successfully and ready to use.");

            // start activity again
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenSplash(),
              ),
            );
          }).onError((error, stackTrace) {
            handleNotification("Error Occurred",
                "There was an error connecting to the server , kindly Retry!");
          });
        },
      );
    } else {
      var snackBar = const SnackBar(
        content: Text(
          "Failed to get data. Retry!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void handleNotification(String title, String body) {
    NotificationApi.showNotification(
      title: title,
      body: body,
      payload: "app.notification",
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

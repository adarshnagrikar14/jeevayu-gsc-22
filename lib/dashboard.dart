// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:jeevayu/classes/notification.dart';
import 'package:jeevayu/classes/home.dart';
import 'package:jeevayu/classes/settings.dart';
import 'package:jeevayu/classes/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeevayu/features/video_message.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // youtube url
  final String _url_youtube = "https://youtube.com";

  // terms url
  final String _url_terms = "https://youtube.com";

  // msg to display
  late bool _allowVideoMsg;

  @override
  void initState() {
    super.initState();

    _allowVideoMsg = true;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.light, // change the brightness of the icons
        statusBarColor: Colors.black,
      ),
    );
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
    Settings(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        // Appbar:
        appBar: AppBar(
          title: const Text(
            'Jeevayu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            // help
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
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

            // other options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: PopupMenuButton<String>(
                onSelected: handleClick,
                iconSize: 28.0,
                itemBuilder: (BuildContext context) {
                  return {'Help', 'Terms and Conditions', 'Feedback'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
          toolbarHeight: 60.0,
          backgroundColor: Colors.grey[850],
          shadowColor: Colors.grey[400],
        ),

        // Bottom nav bar
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          iconSize: 25.0,
          containerHeight: 65.0,
          showElevation: true,
          curve: Curves.easeIn,
          backgroundColor: Colors.grey[800],

          // Items starting from here:
          items: [
            // Home Item
            BottomNavyBarItem(
              icon: const Icon(Icons.space_dashboard_rounded),
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 17),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),

            // Notification Item
            BottomNavyBarItem(
              icon: const Icon(Icons.notifications),
              title: const Text(
                'Alerts',
                style: TextStyle(fontSize: 17),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),

            // Setting Item
            BottomNavyBarItem(
              icon: const Icon(Icons.settings),
              title: const Text(
                'Setting',
                style: TextStyle(fontSize: 17),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),

            // Account Item
            BottomNavyBarItem(
              icon: const Icon(Icons.account_circle),
              title: const Text(
                'Account',
                style: TextStyle(fontSize: 17),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
            ),
          ],

          // On tap Handler
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Help':
        openYoutube();
        break;
      case 'Terms and Conditions':
        openTerms();
        break;
    }
  }

  // open yt
  void openYoutube() async {
    if (!await launch(_url_youtube)) {
      throw 'Could not open Terms and condition!';
    }
  }

  // open t&c
  void openTerms() async {
    if (!await launch(_url_terms)) {
      throw 'Could not open Terms and condition!';
    }
  }

  openVideoDialog() {
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
                            : "Can'\t Record Video message as the device is not registered with any Service.",
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
}

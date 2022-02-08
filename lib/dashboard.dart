import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:jeevayu/classes/notification.dart';
import 'package:jeevayu/classes/home.dart';
import 'package:jeevayu/classes/settings.dart';
import 'package:jeevayu/classes/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.light, // this will change the brightness of the icons
        statusBarColor: Colors.black, // or any color you want
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
              fontSize: 22,
            ),
          ),
          toolbarHeight: 60.0,
          backgroundColor: Colors.grey[850],
          shadowColor: Colors.grey[500],
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://media.istockphoto.com/photos/o2-picture-id157679265',
              ),
            ),
          ),
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
}

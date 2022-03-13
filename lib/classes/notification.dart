import 'package:flutter/material.dart';
import 'package:jeevayu/helpers/my_notifications.dart';

class NotificationActivity extends StatefulWidget {
  const NotificationActivity({Key? key}) : super(key: key);

  @override
  State<NotificationActivity> createState() => _NotificationActivityState();
}

class _NotificationActivityState extends State<NotificationActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: const MyNotifications(),
    );
  }
}

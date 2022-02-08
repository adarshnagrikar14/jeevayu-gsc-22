import 'package:flutter/material.dart';

class NotificationActivity extends StatefulWidget {
  const NotificationActivity({Key? key}) : super(key: key);

  @override
  State<NotificationActivity> createState() => _NotificationActivityState();
}

class _NotificationActivityState extends State<NotificationActivity> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Notification'),
      ),
    );
  }
}

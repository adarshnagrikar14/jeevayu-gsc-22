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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 8.0),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Icon(Icons.info_outline_rounded),
                ),
                Expanded(
                  child: Text(
                      'Notificaions are Available for a particular session only.'),
                ),
              ],
            ),
          ),
          const Expanded(child: MyNotifications()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NotificationActivity extends StatefulWidget {
  const NotificationActivity({Key? key}) : super(key: key);

  @override
  State<NotificationActivity> createState() => _NotificationActivityState();
}

class _NotificationActivityState extends State<NotificationActivity> {
  late bool _alert;

  @override
  void initState() {
    super.initState();
    setState(() {
      _alert = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: _alert
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image:
                          const AssetImage("assets/social/no_notification.png"),
                      width: MediaQuery.of(context).size.width * 0.68,
                    ),
                    const Text(
                      'No Notifications!',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('Notifications: '),
            ),
    );
  }
}

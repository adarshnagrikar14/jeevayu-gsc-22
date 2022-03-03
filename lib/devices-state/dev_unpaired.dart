import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeevayu/features/notification_api.dart';
import 'package:jeevayu/helpers/qr_reader.dart';

import '../splashscreen.dart';

class DeviceUnpaired extends StatefulWidget {
  const DeviceUnpaired({Key? key}) : super(key: key);

  @override
  _DeviceUnpairedState createState() => _DeviceUnpairedState();
}

class _DeviceUnpairedState extends State<DeviceUnpaired> {
  late bool _loading;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    setState(() {
      _loading = false;
    });
    NotificationApi.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: !_loading
            ? Column(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        handleScan();
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    strokeWidth: 5.0,
                    color: Colors.green,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Text(
                      "Please wait...",
                      style: TextStyle(fontSize: 17.0),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  void handleScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrReader()),
    );
    if (result.toString().length == 16) {
      setState(() {
        _loading = true;
      });

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
            setState(() {
              _loading = false;
            });
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

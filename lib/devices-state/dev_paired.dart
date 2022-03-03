// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jeevayu/features/notification_api.dart';
import 'package:jeevayu/splashscreen.dart';

class DevicePaired extends StatefulWidget {
  const DevicePaired({Key? key}) : super(key: key);

  @override
  _DevicePairedState createState() => _DevicePairedState();
}

class _DevicePairedState extends State<DevicePaired> {
  static const method1 = MethodChannel('com.project/DeviceID');
  late String _devID = "";

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getID();
  }

  Future getID() async {
    final String _val = await method1.invokeMethod('getDeviceID');
    setState(() {
      _devID = _val;
    });
  }

  Future<void> setDevIDNo() async {
    var data = <String, dynamic>{"data": ""};
    String value = await method1.invokeMethod("setDeviceID", data);
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: customDisplay(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          handleHistory();
        },
        child: const Icon(Icons.stop),
      ),
    );
  }

  // custom card to be displayed
  Widget customDisplay() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(
        children: [
          // info
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
                      'This is the real time data. In case of Emergency , use contact tab immediately.'),
                ),
              ],
            ),
          ),

          // main card
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // shadowColor: Colors.grey.shade500,
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: SizedBox(
              // height: 350.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Center(),
                        flex: 2,
                      ),
                      Expanded(
                        child: Text("Hello"),
                        flex: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          // spacing
          const SizedBox(
            height: 200.0,
          )
        ],
      ),
    );
  }

  void handleUnregister() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Notifications');

    Future<QuerySnapshot> books = FirebaseFirestore.instance
        .collection('Notifications')
        .doc(user!.uid)
        .collection("Notifications")
        .get();

    books.then((value) {
      for (var element in value.docs) {
        collection
            .doc(user!.uid)
            .collection("Notifications")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      }
    }).whenComplete(
      () {
        setDevIDNo();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenSplash(),
          ),
        );
      },
    );
  }

  void handleHistory() {
    String liveDate = DateFormat('dd/MM/yy').format(DateTime.now()).toString();
    String liveTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

    FirebaseFirestore.instance.runTransaction(
      (Transaction transaction) async {
        DocumentReference reference = FirebaseFirestore.instance
            .collection('History')
            .doc(user!.uid)
            .collection("History")
            .doc();

        await reference.set(
          {
            "DeviceID": _devID,
            "Date": liveDate,
            "Time": liveTime,
          },
        ).whenComplete(() {
          // handle notification
          handleNotification(
              "Device Disconnected", "Device is unregistered successfully.");

          // handle unregister
          handleUnregister();
        }).onError((error, stackTrace) {
          handleNotification("Error Occurred",
              "There was an error connecting to the server , kindly Retry!");
        });
      },
    );
  }

  void handleNotification(String s, String t) {
    NotificationApi.showNotification(
      title: s,
      body: t,
      payload: "app.notification",
    );
  }
}

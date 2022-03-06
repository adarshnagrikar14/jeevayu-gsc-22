// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jeevayu/features/notification_api.dart';
import 'package:jeevayu/splashscreen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DevicePaired extends StatefulWidget {
  const DevicePaired({Key? key}) : super(key: key);

  @override
  _DevicePairedState createState() => _DevicePairedState();
}

class _DevicePairedState extends State<DevicePaired> {
  static const method1 = MethodChannel('com.project/DeviceID');
  late String _devID = "";

  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _dbref = FirebaseDatabase.instance.reference();
  late Timer _timer;
  late int _percent = 0;

  @override
  void initState() {
    // using timer to update data in 10 sec interval
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      handleWeightData(_devID);
    });

    // gett the device ID
    getID();

    // init
    super.initState();
  }

  Future<void> setDevIDNo() async {
    var data = <String, dynamic>{"data": ""};
    String value = await method1.invokeMethod("setDeviceID", data);
    print(value);
  }

  Future getID() async {
    final String _val = await method1.invokeMethod('getDeviceID');
    setState(() {
      _devID = _val;
    });
    handleWeightData(_val);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: customDisplay(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     handleHistory();
      //   },
      //   child: const Icon(Icons.stop),
      // ),
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 14.0,
                        ),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          percent: _percent / 100,
                          animation: true,
                          backgroundColor: Colors.grey.shade700,
                          animationDuration: 900,
                          circularStrokeCap: CircularStrokeCap.round,
                          lineWidth: 13.0,
                          animateFromLastPercent: true,
                          center: Text(
                            _percent.toString() + " %",
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          rotateLinearGradient: false,
                          linearGradient: LinearGradient(
                            colors: [
                              Colors.green.shade200,
                              Colors.green.shade400,
                              Colors.green,
                            ],
                            begin: Alignment.topLeft,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, left: 35.0),
                              child: Text(
                                "Device ID- " + _devID,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  height: 1.2,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 18.0, left: 35.0, bottom: 8.0),
                              child: Text(
                                'Connected on:\n03/03/2022 | 11:02 P.M',
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 130.0,
                  )
                ],
              ),
            ),
          ),

          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // shadowColor: Colors.grey.shade500,
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 90.0,
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            ),
          ),

          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // shadowColor: Colors.grey.shade500,
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 90.0,
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            ),
          ),

          // info
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 8.0),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white60,
                  ),
                ),
                Expanded(
                  child: Text(
                    'This is the real time data. In case of Emergency, use contact tab immediately.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // handles unregistertion just after history adding
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

  // handles history adding as soon as it disconnects and then trig handleUnregister();
  void handleHistory() {
    String liveDate = DateFormat('dd/MM/yy').format(DateTime.now()).toString();
    String liveTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
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

  handleWeightData(String val) {
    _dbref.child(val).child("Weight").once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      double _value = snapshot.value * 1.25; // for 80Kg weight = 100/80 = 1.25
      setState(() {
        _percent = _value.toInt();
      });
    });
  }
}

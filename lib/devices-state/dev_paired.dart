// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jeevayu/dashboard.dart';
import 'package:jeevayu/features/notification_api.dart';
import 'package:jeevayu/splashscreen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DevicePaired extends StatefulWidget {
  const DevicePaired({Key? key}) : super(key: key);

  @override
  _DevicePairedState createState() => _DevicePairedState();
}

class _DevicePairedState extends State<DevicePaired> {
  static const method1 = MethodChannel('com.project/DeviceID');
  late String _devID = "";

  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  late Timer _timer;
  late int _percent = 0;

  late String _profile;

  late String _numberH = "-- --";
  late String _addressH = "-- --\n-- --";
  late String _nameH = "-- --";

  final Color _bluedark = HexColor('25383c');

  @override
  void initState() {
    // using timer to update data in 10 sec interval
    // _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //   handleWeightData(_devID);
    // });

    // gett the device ID
    getID();

    setState(() {
      _profile = user!.photoURL!;
    });

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
    getCommunications(_val);
  }

  Future getCommunications(String val) async {
    var collection = FirebaseFirestore.instance.collection('Providers');
    var docSnapshot = await collection.doc(val).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String _num = data?['Number'];
      String _add = data?['Address'];
      String _nam = data?['Name'];
      setState(() {
        _numberH = _num;
        _nameH = _nam;
        _addressH = _add;
      });
    }
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
                                  const EdgeInsets.only(top: 25.0, left: 28.0),
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
                                  top: 18.0, left: 28.0, bottom: 8.0),
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

          // hospital info
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
                    // height: 90.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // icon-h
                        const Expanded(
                          child: CircleAvatar(
                            radius: 50.0,
                            child: ClipOval(
                              child: Image(
                                image: AssetImage("assets/social/nurse.png"),
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                          ),
                          flex: 3,
                        ),

                        // details-h
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 22.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nameH,
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _addressH,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  _numberH,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    height: 1.8,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // share qr card
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  enableDrag: true,
                  // backgroundColor: Colors.grey[850],
                  backgroundColor: _bluedark,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 470.0,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                bottom: 4.0,
                                top: 20.0,
                              ),
                              child: Text(
                                'Share QR',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(
                              "To Share, scan the QR below.",
                              style: TextStyle(
                                height: 1.3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20.0, top: 10.0),
                              child: Divider(
                                color: Colors.grey.shade300,
                                height: 1.2,
                              ),
                            ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(12.0),
                                // color: Colors.white,
                                child: QrImage(
                                  data: "JzaS3ZCkpxFy88Zh",
                                  size: 220,
                                  gapless: false,
                                  version: 1,
                                  eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: Colors.black),
                                ),
                              ),
                            ),

                            // btn
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                                  // handleScan();
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 80.0,
                                    vertical: 12.0,
                                  ),
                                  child: Text(
                                    "CLOSE",
                                    style: TextStyle(
                                      fontSize: 23.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Card(
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
                      // height: 90.0,
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          title: Text(
                            "Share this device's QR code",
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.5,
                            ),
                          ),
                          subtitle: Text(
                            "It will enable other users to receive the status of this device.",
                            style: TextStyle(
                              fontSize: 15.0,
                              height: 1.5,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          //
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: SizedBox(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
            ),
          ),

          //
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: SizedBox(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
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
    try {
      _dbref.child(val).child("Weight").once().then((value) {
        print(value.snapshot.value);

        // for 80Kg weight = 100/80 = 1.25
        int _value = value.snapshot.value! as int;

        double _va = (_value.toDouble()) * 1.25;

        setState(() {
          _percent = _va.toInt();
        });
      }).onError((error, stackTrace) {
        print(error);
      });
    } catch (e) {
      print(e);
    }
  }
}

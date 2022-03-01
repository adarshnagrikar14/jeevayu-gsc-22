import 'package:flutter/material.dart';

class VideoMessage extends StatefulWidget {
  const VideoMessage({Key? key}) : super(key: key);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Record Message',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.grey[850],
        toolbarHeight: 60,
        elevation: 10,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          children: const [
            // lottie animation:
            Center(
              child: Image(
                image: AssetImage("assets/social/video-msg.png"),
                height: 250.0,
                width: 250.0,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Text(
                'The feature is being tested. Once done , will be updated soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white70,
                ),
              ),
            ),

            SizedBox(
              height: 220.0,
            )
          ],
        ),
      ),
    );
  }
}

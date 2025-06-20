import 'package:flutter/material.dart';
import 'package:table_calendar_example/entry0.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MaterialApp(
  home: Tsafira(),
));

class Tsafira extends StatefulWidget {
  @override
  _TsafiraState createState() => _TsafiraState();
}

class _TsafiraState extends State<Tsafira> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize the video player
    _controller = VideoPlayerController.asset('assets/splash-video1.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          // Start playing as soon as it's initialized
          _controller.play();
          
          // Add listener to detect when video ends
          _controller.addListener(() {
            if (_controller.value.position >= _controller.value.duration) {
              // Video has ended, navigate to next screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Entry0()),
              );
            }
          });
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isVideoInitialized
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
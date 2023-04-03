import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mediaplayer/screen/videoplayscreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:video_player/video_player.dart';

class VideoItem {
  final String path;
  final String title;

  VideoItem(this.path, this.title);
}

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({super.key});

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  late VideoPlayerController _controller;

  final List<VideoItem> _videos = [];

  final appDir = Directory('/sdcard');

  final colorizeColors = [
    Colors.yellow,
    Colors.red,
    Colors.orange,
    Colors.pink,
  ];

  final colorizeTextStyle =
      const TextStyle(fontSize: 30, fontFamily: 'Horizon');

  @override
  void initState() {
    super.initState();
    _processDirectory(appDir);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processDirectory(Directory dir) {
    // print('Directory: ${dir.path}');
    dir.listSync(recursive: false).forEach((entity) {
      if (entity is Directory &&
          !entity.path.endsWith('/Android/data') &&
          !entity.path.endsWith('/Android/obb')) {
        _processDirectory(entity);
      } else if (entity is File && entity.path.endsWith('.mp4')) {
        // print('MP4 file: ${entity.path}');
        String title = entity.path.split('/').last;
        _videos.add(VideoItem(entity.path, title));
        // _controller = VideoPlayerController.file(File(entity.path))
        //   ..initialize().then((_) {
        //     setState(() {});  //when your thumbnail will show.
        //   });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF28282B),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(245),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.purple, Colors.pink],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: 100,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'Watch',
                                colors: colorizeColors,
                                textStyle: colorizeTextStyle,
                                // speed: Duration(microseconds: 100),
                              ),
                              ColorizeAnimatedText(
                                '\nTo',
                                colors: colorizeColors,
                                textStyle: colorizeTextStyle,
                                // speed: Duration(microseconds: 100),
                              ),
                              ColorizeAnimatedText(
                                '\n\nYour',
                                colors: colorizeColors,
                                textStyle: colorizeTextStyle,
                                // speed: Duration(microseconds: 100),
                              ),
                              ColorizeAnimatedText(
                                '\n\n\nHeart',
                                colors: colorizeColors,
                                textStyle: colorizeTextStyle,
                                // speed: Duration(microseconds: 100),
                              ),
                              ColorizeAnimatedText(
                                '\nWatch \nTo Your \nHeart',
                                colors: colorizeColors,
                                textStyle: colorizeTextStyle,
                                // speed: Duration(microseconds: 100),
                              ),
                            ],
                            isRepeatingAnimation: true,
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 200,
                          width: 240,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                            child: OverflowBox(
                              minHeight: 200,
                              maxHeight: 200,
                              child: Lottie.asset(
                                "assets/starvideo.json",
                                width: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView.builder(
          cacheExtent: 0,
          itemCount: _videos.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                textColor: Colors.white,
                // leading: _controller.value.isInitialized
                //     ? SizedBox(
                //         width: 50.0,
                //         height: 50.0,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: VideoPlayer(_controller),
                //         ),
                //       )
                //     : Image.asset('assets/musicavatar.png'),
                leading: Container(
                  width: 60,
                  height: 50,
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    image: DecorationImage(
                        image: AssetImage('assets/m1.png'), fit: BoxFit.cover),
                  ),
                  child: const Icon(Icons.play_circle),
                ),
                title: Text(
                  _videos[index].title.split('.').first,
                ),
                trailing: SizedBox(
                  height: 40,
                  width: 40,
                  child: OverflowBox(
                    minHeight: 40,
                    maxHeight: 40,
                    child: Lottie.asset(
                      "assets/vpb.json",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  _controller =
                      VideoPlayerController.file(File(_videos[index].path));
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: VideoPlayerWidget(controller: _controller),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

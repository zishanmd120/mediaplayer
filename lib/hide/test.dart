// import 'dart:io';
// import 'package:mediaplayer/screen/videoplayscreen.dart';
// import 'package:mediaplayer/screen/videoscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:video_player/video_player.dart';
//
// class Mp4FileSearcher {
//   static Future<List<File>> searchMp4Files() async {
//
//     final rootDir = Directory('/sdcard');
//     // final rootDir = Directory('/sdcard');
//     print(rootDir);
//     final mp4Files = <File>[];
//     final ignoredDirs = [
//       '/Android',
//       '/.'
//     ];
//     final allDirs = <Directory>[];
//
//     //hey
//     await Permission.storage.request();
//     if(await Permission.storage.isGranted){
//       print("Success");
//     } else {
//       print('Failure');
//     }
//
//     // Get all directories in the root directory
//     await for (final entity in rootDir.list()) {
//       if (entity is Directory && !ignoredDirs.contains(entity.path)) {
//         allDirs.add(entity);
//         print(entity);
//       }
//     }
//
//
//     List<FileSystemEntity> files = rootDir.listSync();
//
//     // Recursively search for MP4 files inside each directory
//     for (final dir in allDirs) {
//       await for (final entity in dir.list(recursive: true)) {
//         if (entity is File && entity.path.endsWith('.mp4')) {
//           mp4Files.add(entity);
//           print(entity);
//           print(mp4Files);
//           // String title = mp4Files.split('/').last;
//           // mp4Files.add(entity[path][title]);
//           // print(title);
//           // print(mp4Files);
//         }
//       }
//     }
//
//     return mp4Files;
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<File> _mp4Files = [];
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMp4Files();
//   }
//
//   Future<void> _loadMp4Files() async {
//     final mp4Files = await Mp4FileSearcher.searchMp4Files();
//     setState(() {
//       _mp4Files = mp4Files;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MP4 Files'),
//       ),
//       body: ListView.builder(
//         itemCount: _mp4Files.length,
//         itemBuilder: (context, index) {
//           final file = _mp4Files[index];
//           print(file);
//           return ListTile(
//             title: Text(file.path),
//             // title: Text('watch ${file.path}'),
//             // subtitle: Text(file.path.characters.first),
//             onTap: () {
//               _controller = VideoPlayerController.file(File(file.path));
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => VideoPlayerWidget(controller: _controller),
//               //   ),
//               // );
//               PersistentNavBarNavigator.pushNewScreen(
//                 context,
//                 screen: VideoPlayerWidget(controller: _controller),
//                 withNavBar: false, // OPTIONAL VALUE. True by default.
//                 pageTransitionAnimation: PageTransitionAnimation.cupertino,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class RTE extends StatefulWidget {
//   const RTE({Key? key}) : super(key: key);
//
//   @override
//   State<RTE> createState() => _RTEState();
// }

// class _RTEState extends State<RTE> {
//   late VideoPlayerController _controller;
//   List<FileSystemEntity> _videos = [];
//
//   void initState() {
//     super.initState();
//     _getVideos();
//   }
//
//   Future<void> _getVideos() async {
//     final appDir =  await getApplicationDocumentsDirectory();
//     final allDirs = await _getAllDirectories(appDir.path);
//     for (final dir in allDirs)  {
//       final files = await dir
//           .list(recursive: true)
//           .where((entity) => entity is File && entity.path.toLowerCase().endsWith('.mp4'))
//           .map((entity) => entity as File)
//           .toList();
//       // Do something with the files.
//       for (final file in files) {
//         if (file is File && file.path.endsWith('.mp4')) {
//           _videos.add(file);
//         }
//         final controller = VideoPlayerController.file(file);
//         await controller.initialize();
//         // Play the video using the controller.
//         // You can use the VideoPlayer widget to display the video.
//         await controller.dispose();
//       }
//       setState(() {});
//     }
//     setState(() {});
//   }
//
//   Future<List<Directory>> _getAllDirectories(String dirPath) async {
//     final dir = Directory(dirPath);
//     final dirs = <Directory>[];
//     await for (final entity in dir.list()) {
//       if (entity is Directory) {
//         dirs.add(entity);
//         dirs.addAll(await _getAllDirectories(entity.path));
//       }
//     }
//     return dirs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _videos.length,
//       itemBuilder: (BuildContext context, int index) {
//         return ListTile(
//           title: Text(_videos[index].path.split('/').last),
//           onTap: () {
//             // _controller = VideoPlayerController.file(_videos[index]);
//             _controller = VideoPlayerController.file(File(_videos[index].path));
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => VideoPlayerWidget(controller: _controller),
//             //   ),
//             // );
//           },
//         );
//       },
//     );
//   }
// }


// class _RTEState extends State<RTE> {
//
//   @override
//   void initState() {
//     super.initState();
//     _getVideos();
//   }
//
//   Future<void> _getVideos() async {
//     final rootDir = Directory('/');
//     final mp4Files = <File>[];
//     final allDirs = <Directory>[];
//
//     // Get all directories in the root directory
//     await for (final entity in rootDir.list()) {
//       if (entity is Directory) {
//         allDirs.add(entity);
//       }
//     }
//
//     // Recursively search for MP4 files inside each directory
//     for (final dir in allDirs) {
//       await for (final entity in dir.list(recursive: true)) {
//         if (entity is File && entity.path.endsWith('.mp4')) {
//           mp4Files.add(entity);
//         }
//       }
//     }
//
//     setState(() {});
//   }
//
//   // Display the list of MP4 files in a ListView
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('MP4 Files')),
//       body: ListView.builder(
//         itemCount: mp4Files.length,
//         itemBuilder: (context, index) {
//           final file = mp4Files[index];
//           return ListTile(title: Text(file.path));
//         },
//       ),
//     );
//   }
// }





// body: OrientationBuilder(
//   builder: (BuildContext context, Orientation orientation) {
//     if (orientation == Orientation.landscape) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);
//     }
//     return GestureDetector(
//       onTap: () {
//         if (widget.controller.value.isPlaying) {
//           widget.controller.pause();
//         } else {
//           widget.controller.play();
//         }
//       },
//       child: Stack(
//         children: <Widget>[
//           Center(
//             child: widget.controller.value.isInitialized
//                 ? AspectRatio(
//               aspectRatio: widget.controller.value.aspectRatio,
//               child: VideoPlayer(widget.controller),
//             )
//                 : CircularProgressIndicator(),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: VideoProgressIndicator(widget.controller,
//                 allowScrubbing: true),
//           ),
//         ],
//       ),
//     );
//   },
// ),


// body: Center(
// child: widget.controller.value.isInitialized
// ? AspectRatio(
// aspectRatio: widget.controller.value.aspectRatio,
// child: VideoPlayer(widget.controller),
// )
// : Container(),
// ),


// body: OrientationBuilder(
//   builder: (BuildContext context, Orientation orientation) {
//     if (orientation != _orientation) {
//       _orientation = orientation;
//       if (_orientation == Orientation.landscape) {
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.landscapeLeft,
//           DeviceOrientation.landscapeRight,
//         ]);
//       } else {
//         SystemChrome.setPreferredOrientations([
//           DeviceOrientation.portraitUp,
//         ]);
//       }
//     }
//     return Center(
//       child: widget.controller.value.isInitialized
//           ? AspectRatio(
//         aspectRatio: widget.controller.value.aspectRatio,
//         child: VideoPlayer(widget.controller),
//       )
//           : CircularProgressIndicator(),
//     );
//   },
// ),


// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     title: 'Video Demo',
//     home: Scaffold(
//       body: Center(
//         child: widget.controller.value.isInitialized
//             ? AspectRatio(
//           aspectRatio: widget.controller.value.aspectRatio,
//           child: VideoPlayer(widget.controller),
//         )
//             : Container(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             widget.controller.value.isPlaying
//                 ? widget.controller.pause()
//                 : widget.controller.play();
//           });
//         },
//         child: Icon(
//           widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     ),
//   );
// }
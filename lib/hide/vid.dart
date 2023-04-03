// Future<void> _requestPermission() async {
//   Map<Permission, PermissionStatus> statuses = await [    Permission.storage,  ].request();
//
//   if (statuses[Permission.storage] != PermissionStatus.granted) {
//     throw Exception('Permission not granted');
//   }
// }
// Future<void> _getVideos() async {
//   // await _requestPermission();
//   // Directory((await _pathProviderProxy.ptr.applicationDocumentsDirectory()).path);
//   // Directory directory = Directory('/storage/emulated/0/0/z');
//   // Directory directory = Directory('/storage/emulated/0/Download');
//   // Directory directory = Directory('/storage/emulated/0/Download');
//   Directory directory = Directory('/sdcard');
//   print(directory);
//   final ignoredDirs = [
//     '/Android',
//   ];
//
//   List<Directory> allDirs = [];
//   await for (final entity in directory.list(recursive: false)) {
//     if (entity is Directory && !ignoredDirs.contains(entity.path)) {
//       allDirs.add(entity);
//       print(entity.path);
//       // print(allDirs);
//     }
//   }
//
//   List<FileSystemEntity> files = directory.listSync();
//
//   for (FileSystemEntity file in files) {
//     if (file is File && file.path.endsWith('.mp4')) {
//       print('Found MP4 file: ${file.path}');
//       String title = file.path.split('/').last;
//       _videos.add(VideoItem(file.path, title));
//     }
//   }
//
//   setState(() {});
// }

// final VideoPlayerController controller;
//
// const VideoPlayerWidget({super.key, required this.controller});
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Center(
//       child: AspectRatio(
//         aspectRatio: controller.value.aspectRatio,
//         child: VideoPlayer(controller),
//       ),
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         if (controller.value.isPlaying) {
//           controller.pause();
//         } else {
//           controller.play();
//         }
//       },
//       child: Icon(
//         controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//       ),
//     ),
//   );
// }
// class VideoListWidget extends StatefulWidget {
//   @override
//   _VideoListWidgetState createState() => _VideoListWidgetState();
// }
//
// class _VideoListWidgetState extends State<VideoListWidget> {
//   late VideoPlayerController _controller;
//   List<FileSystemEntity> _videos = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getVideos();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // Future<void> _requestPermission() async {
//   //   Map<Permission, PermissionStatus> statuses = await [    Permission.mediaLibrary,  ].request();
//   //
//   //   if (statuses[Permission.mediaLibrary] != PermissionStatus.granted) {
//   //     throw Exception('Permission not granted');
//   //   }
//   // }
//
//   Future<void> _getVideos() async {
//     // await _requestPermission();
//     Directory? directory = await getExternalStorageDirectory();
//
//     List<FileSystemEntity> files = directory!.listSync();
//
//     for (FileSystemEntity file in files) {
//       if (file is File && file.path.endsWith('.mp4')) {
//         _videos.add(file);
//       }
//     }
//
//     setState(() {});
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
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => VideoPlayerWidget(controller: _controller),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// double heightScreen = MediaQuery.of(context).size.height; //803.6
// double widthScreen = MediaQuery.of(context).size.width;
// double statusBarHeight = MediaQuery.of(context).padding.top;
// final height = heightScreen - statusBarHeight;
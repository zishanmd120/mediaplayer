// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mediaplayer/screen/musicplayscreen.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:rxdart/rxdart.dart';
//
// class MusicPlayer extends StatefulWidget {
//   const MusicPlayer({Key? key}) : super(key: key);
//
//   @override
//   State<MusicPlayer> createState() => _MusicPlayerState();
// }
//
// class _MusicPlayerState extends State<MusicPlayer> {
//   //define plugn
//   final OnAudioQuery _audioQuery = OnAudioQuery();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   //more variable
//   List<SongModel> songs = [];
//   String currentSongTitle = "";
//   int currentIndex = 0;
//
//   bool isPlayerViewVisible = false;
//
//   //define a method to set the player view visibility
//   void _changePlayerViewVisibility() {
//     setState(() {
//       isPlayerViewVisible = !isPlayerViewVisible;
//     });
//   }
//
//   //duration state stream
//   Stream<DurationState> get _durationStateStream =>
//       Rx.combineLatest2<Duration, Duration?, DurationState>(
//         _audioPlayer.positionStream,
//         _audioPlayer.durationStream,
//             (position, duration) =>
//             DurationState(position: position, total: duration ?? Duration.zero),
//       );
//
//   //req perm from init meth
//   @override
//   void initState() {
//     super.initState();
//     requestStoragePermission();
//     _audioPlayer.currentIndexStream.listen((index) {
//       if (index != null) {
//         _updateCurrentPlayingSongDetails(index);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isPlayerViewVisible) {
//       return Scaffold(
//         backgroundColor: Color(0xFF28282B),
//         body: SingleChildScrollView(
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.only(top: 56, right: 20, left: 20),
//             // decoration: BoxDecoration(color: Colors.transparent),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Flexible(
//                       child: InkWell(
//                         onTap: _changePlayerViewVisibility,
//                         child: Container(
//                           padding: EdgeInsets.all(20),
//                           // decoration: getDecoration(
//                           //   BoxShape.circle,
//                           //   Offset(2, 2),
//                           //   2.0,
//                           //   0.0,
//                           // ),
//                           child: Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       child: Text(
//                         currentSongTitle,
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       flex: 5,
//                     ),
//                     Flexible(
//                       child: InkWell(
//                         onTap: _changePlayerViewVisibility,
//                         child: Container(
//                           // padding: EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             // BoxShape.circle,
//                             // Offset(2, 2),
//                             // 2.0,
//                             // 0.0,
//                           ),
//                           child: Icon(
//                             Icons.info,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 Container(
//                   width: 300,
//                   height: 300,
//                   decoration:
//                   getDecoration(BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                   child: QueryArtworkWidget(
//                     id: songs[currentIndex].id,
//                     type: ArtworkType.AUDIO,
//                     artworkBorder: BorderRadius.circular(200.0),
//                     nullArtworkWidget: Image.network('https://www.freepnglogos.com/uploads/apple-music-logo-circle-png-28.png'),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.zero,
//                       margin: EdgeInsets.only(bottom: 4.0),
//                       decoration: getRectDecoration(
//                         BorderRadius.circular(20),
//                         Offset(2, 2),
//                         2.0,
//                         0.0,
//                       ),
//                       child: StreamBuilder<DurationState>(
//                           stream: _durationStateStream,
//                           builder: (context, snapshot) {
//                             final durationState = snapshot.data;
//                             final progress =
//                                 durationState?.position ?? Duration.zero;
//                             final total = durationState?.total ?? Duration.zero;
//                             return ProgressBar(
//                               progress: progress,
//                               total: total,
//                               barHeight: 20.0,
//                               baseBarColor: Colors.black,
//                               progressBarColor: Colors.red,
//                               thumbColor: Colors.white60.withBlue(99),
//                               timeLabelTextStyle: TextStyle(
//                                 fontSize: 0,
//                               ),
//                               onSeek: (duration) {
//                                 _audioPlayer.seek(duration);
//                               },
//                             );
//                           }),
//                     ),
//                     //position/progress and total text
//                     StreamBuilder<DurationState>(
//                         stream: _durationStateStream,
//                         builder: (context, snapshot) {
//                           final durationState = snapshot.data;
//                           final progress =
//                               durationState?.position ?? Duration.zero;
//                           final total = durationState?.total ?? Duration.zero;
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   progress.toString().split(".")[0],
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Flexible(
//                                 child: Text(
//                                   total.toString().split(".")[0],
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         })
//                   ],
//                 ),
//                 //prev, play/pause, & seek next control buttons
//                 Container(
//                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       //skip to previous
//                       Flexible(
//                         child: InkWell(
//                           onTap: () {
//                             if (_audioPlayer.hasPrevious) {
//                               _audioPlayer.seekToPrevious();
//                             }
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: getDecoration(
//                                 BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                             child: Icon(
//                               Icons.skip_previous,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ),
//                       ),
//                       //play /pause
//                       Flexible(
//                         child: InkWell(
//                           onTap: () {
//                             if (_audioPlayer.playing) {
//                               _audioPlayer.pause();
//                             } else {
//                               _audioPlayer.play();
//                             }
//                           },
//                           child: Container(
//                               padding: EdgeInsets.all(20),
//                               decoration: getDecoration(
//                                   BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                               child: StreamBuilder<bool>(
//                                   stream: _audioPlayer.playingStream,
//                                   builder: (context, snapshot) {
//                                     bool? playingState = snapshot.data;
//                                     if (playingState != null && playingState) {
//                                       return Icon(
//                                         Icons.pause,
//                                         size: 30,
//                                         color: Colors.white70,
//                                       );
//                                     }
//                                     return Icon(
//                                       Icons.play_arrow,
//                                       size: 30,
//                                       color: Colors.white70,
//                                     );
//                                   })),
//                         ),
//                       ),
//                       //skip to next
//                       Flexible(
//                         child: InkWell(
//                           onTap: () {
//                             if (_audioPlayer.hasNext) {
//                               _audioPlayer.seekToNext();
//                             }
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: getDecoration(
//                                 BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                             child: Icon(
//                               Icons.skip_next,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //go to playlist, shuffle, repeat all and one button
//                 Container(
//                   margin: EdgeInsets.only(top: 20, bottom: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       //go to playlist
//                       Flexible(
//                         child: InkWell(
//                           onTap: () {
//                             _changePlayerViewVisibility();
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: getDecoration(
//                                 BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                             child: Icon(
//                               Icons.list_alt,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ),
//                       ),
//                       //playlist shuffle
//                       Flexible(
//                         child: InkWell(
//                           onTap: () {
//                             _audioPlayer.setShuffleModeEnabled(true);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: getDecoration(
//                                 BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                             child: Icon(
//                               Icons.shuffle,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ),
//                       ),
//                       //repeat mode all and one button
//                       Flexible(
//                         child: InkWell(
//                           onTap: () {
//                             _audioPlayer.loopMode == LoopMode.one
//                                 ? _audioPlayer.setLoopMode(LoopMode.all)
//                                 : _audioPlayer.setLoopMode(LoopMode.one);
//                           },
//                           child: Container(
//                               padding: EdgeInsets.all(10),
//                               decoration: getDecoration(
//                                   BoxShape.circle, Offset(2, 2), 2.0, 0.0),
//                               child: StreamBuilder<LoopMode>(
//                                   stream: _audioPlayer.loopModeStream,
//                                   builder: (context, snapshot) {
//                                     final loopmode = snapshot.data;
//                                     if (LoopMode.one == loopmode) {
//                                       return Icon(
//                                         Icons.repeat_one,
//                                         color: Colors.white70,
//                                       );
//                                     }
//                                     return Icon(
//                                       Icons.repeat,
//                                       color: Colors.white70,
//                                     );
//                                   })),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color(0xFF28282B),
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(220),
//           child: Container(
//             width: double.infinity,
//             margin: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [Colors.purple, Colors.pink],
//               ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(horizontal: 30),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 80,
//                         child: Text(
//                           'Listen To Your Heart',
//                           style: TextStyle(
//                               fontSize: 25,
//                               fontStyle: FontStyle.italic,
//                               color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 200,
//                         width: 200,
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 80.0),
//                           child: OverflowBox(
//                             minHeight: 350,
//                             maxHeight: 350,
//                             child: Lottie.asset(
//                               "assets/music.json",
//                               width: 280,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: FutureBuilder<List<SongModel>>(
//           future: _audioQuery.querySongs(
//             sortType: null,
//             orderType: OrderType.ASC_OR_SMALLER,
//             uriType: UriType.EXTERNAL,
//             ignoreCase: true,
//           ),
//           builder: (context, item) {
//             if (item.data == null) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (item.data!.isEmpty) {
//               return const Center(
//                 child: Text("No Song Found"),
//               );
//             }
//             //add songs
//             songs.clear();
//             songs = item.data!;
//
//             return ListView.builder(
//               itemCount: item.data!.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: EdgeInsets.all(5),
//                   padding: EdgeInsets.all(5),
//                   height: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ListTile(
//                     textColor: Colors.white,
//                     // title: Text(item.data![index].title, overflow: TextOverflow.ellipsis,),
//                     // subtitle: Text(item.data![index].displayName, overflow: TextOverflow.ellipsis,),
//                     title: Text(
//                       item.data![index].displayName,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(fontFamily: 'abc'),
//                     ),
//                     trailing: const Icon(
//                       Icons.bar_chart,
//                       color: Colors.white,
//                     ),
//                     leading: QueryArtworkWidget(
//                       id: item.data![index].id,
//                       type: ArtworkType.AUDIO,
//                       nullArtworkWidget: Image.network('https://www.freepnglogos.com/uploads/apple-music-logo-circle-png-28.png'),
//                     ),
//                     onTap: () async {
//                       _changePlayerViewVisibility();
//                       // String? uri = item.data![index].uri;
//                       // await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!),),);
//                       await _audioPlayer.setAudioSource(
//                         createPlayList(item.data),
//                         initialIndex: index,
//                       );
//                       await _audioPlayer.play();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               MusicPlayerScreen(
//                                 visibility: isPlayerViewVisible,
//                                 id : songs[currentIndex].id,
//                                 title: songs[currentIndex].title,
//                                 data: songs[currentIndex].data,
//                                 // id : item.data![index].id,
//                               ),
//                         ),
//                       );
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (context) => MusicPlayerScreen(),
//                       //       settings: RouteSettings(
//                       //       arguments: {
//                       //         'title': item.data![index].title,
//                       //         'id': item.data![index].id,
//                       //         'data': item.data![index].data,
//                       //         'track': item.data![index].track,
//                       //         'album': item.data![index].album,
//                       //         'artist': item.data![index].artist,
//                       //         'displayName': item.data![index].displayName,
//                       //       },
//                       //     ),
//                       //   ),
//                       // );
//                       // PersistentNavBarNavigator.pushNewScreen(
//                       //   context,
//                       //   screen: MusicPlayerScreen(),
//                       //   withNavBar: false, // OPTIONAL VALUE. True by default.
//                       //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
//                       // );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void requestStoragePermission() async {
//     //only if it is not web web does not have permission
//     if (!kIsWeb) {
//       bool permissionStatus = await _audioQuery.permissionsStatus();
//       if (!permissionStatus) {
//         await _audioQuery.permissionsRequest();
//       }
//       //ensure build method is called
//       setState(() {});
//     }
//   }
//
//   ConcatenatingAudioSource createPlayList(List<SongModel>? songs) {
//     List<AudioSource> sources = [];
//     for (var song in songs!) {
//       sources.add(
//         AudioSource.uri(
//           Uri.parse(song.uri!),
//         ),
//       );
//     }
//     return ConcatenatingAudioSource(children: sources);
//   }
//
//   void _updateCurrentPlayingSongDetails(int index) {
//     setState(() {
//       if (songs.isNotEmpty) {
//         currentSongTitle = songs[index].title;
//         currentIndex = index;
//       }
//     });
//   }
//
//   getDecoration(
//       BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
//     return BoxDecoration(
//       color: Color(0xFF9F2B68),
//       shape: shape,
//       boxShadow: [
//         BoxShadow(
//           offset: -offset,
//           color: Colors.white24,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         ),
//         BoxShadow(
//           offset: offset,
//           color: Colors.black,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         ),
//       ],
//     );
//   }
//
//   getRectDecoration(BorderRadius borderRadius, Offset offset, double blurRadius,
//       double spreadRadius) {
//     return BoxDecoration(
//       color: Colors.blueGrey,
//       borderRadius: borderRadius,
//       boxShadow: [
//         BoxShadow(
//           offset: -offset,
//           color: Colors.white24,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         ),
//         BoxShadow(
//           offset: offset,
//           color: Colors.black,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         ),
//       ],
//     );
//   }
// }
//
//
// // if (isPlayerViewVisible) {
// //   return Scaffold(
// //     backgroundColor: Color(0xFF28282B),
// //     body: SingleChildScrollView(
// //       child: Container(
// //         width: double.infinity,
// //         padding: EdgeInsets.only(top: 56, right: 20, left: 20),
// //         // decoration: BoxDecoration(color: Colors.transparent),
// //         child: Column(
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               mainAxisSize: MainAxisSize.max,
// //               children: [
// //                 Flexible(
// //                   child: InkWell(
// //                     onTap: _changePlayerViewVisibility,
// //                     child: Container(
// //                       padding: EdgeInsets.all(20),
// //                       // decoration: getDecoration(
// //                       //   BoxShape.circle,
// //                       //   Offset(2, 2),
// //                       //   2.0,
// //                       //   0.0,
// //                       // ),
// //                       child: Icon(
// //                         Icons.arrow_back_ios,
// //                         color: Colors.white70,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Flexible(
// //                   child: Text(
// //                     currentSongTitle,
// //                     style: TextStyle(
// //                       color: Colors.white70,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 18,
// //                     ),
// //                   ),
// //                   flex: 5,
// //                 ),
// //                 Flexible(
// //                   child: InkWell(
// //                     onTap: _changePlayerViewVisibility,
// //                     child: Container(
// //                       // padding: EdgeInsets.all(20),
// //                       decoration: BoxDecoration(
// //                         // BoxShape.circle,
// //                         // Offset(2, 2),
// //                         // 2.0,
// //                         // 0.0,
// //                       ),
// //                       child: Icon(
// //                         Icons.info,
// //                         color: Colors.white70,
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               ],
// //             ),
// //             Container(
// //               width: 300,
// //               height: 300,
// //               decoration:
// //                   getDecoration(BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //               child: QueryArtworkWidget(
// //                 id: songs[currentIndex].id,
// //                 type: ArtworkType.AUDIO,
// //                 artworkBorder: BorderRadius.circular(200.0),
// //                 nullArtworkWidget: Image.network('https://www.freepnglogos.com/uploads/apple-music-logo-circle-png-28.png'),
// //               ),
// //             ),
// //             Column(
// //               children: [
// //                 Container(
// //                   padding: EdgeInsets.zero,
// //                   margin: EdgeInsets.only(bottom: 4.0),
// //                   decoration: getRectDecoration(
// //                     BorderRadius.circular(20),
// //                     Offset(2, 2),
// //                     2.0,
// //                     0.0,
// //                   ),
// //                   child: StreamBuilder<DurationState>(
// //                       stream: _durationStateStream,
// //                       builder: (context, snapshot) {
// //                         final durationState = snapshot.data;
// //                         final progress =
// //                             durationState?.position ?? Duration.zero;
// //                         final total = durationState?.total ?? Duration.zero;
// //                         return ProgressBar(
// //                           progress: progress,
// //                           total: total,
// //                           barHeight: 20.0,
// //                           baseBarColor: Colors.black,
// //                           progressBarColor: Colors.red,
// //                           thumbColor: Colors.white60.withBlue(99),
// //                           timeLabelTextStyle: TextStyle(
// //                             fontSize: 0,
// //                           ),
// //                           onSeek: (duration) {
// //                             _audioPlayer.seek(duration);
// //                           },
// //                         );
// //                       }),
// //                 ),
// //                 //position/progress and total text
// //                 StreamBuilder<DurationState>(
// //                     stream: _durationStateStream,
// //                     builder: (context, snapshot) {
// //                       final durationState = snapshot.data;
// //                       final progress =
// //                           durationState?.position ?? Duration.zero;
// //                       final total = durationState?.total ?? Duration.zero;
// //                       return Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         mainAxisSize: MainAxisSize.max,
// //                         children: [
// //                           Flexible(
// //                             child: Text(
// //                               progress.toString().split(".")[0],
// //                               style: TextStyle(
// //                                 color: Colors.white70,
// //                                 fontSize: 15,
// //                               ),
// //                             ),
// //                           ),
// //                           Flexible(
// //                             child: Text(
// //                               total.toString().split(".")[0],
// //                               style: TextStyle(
// //                                 color: Colors.white70,
// //                                 fontSize: 15,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       );
// //                     })
// //               ],
// //             ),
// //             //prev, play/pause, & seek next control buttons
// //             Container(
// //               margin: EdgeInsets.only(top: 20, bottom: 20),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 mainAxisSize: MainAxisSize.max,
// //                 children: [
// //                   //skip to previous
// //                   Flexible(
// //                     child: InkWell(
// //                       onTap: () {
// //                         if (_audioPlayer.hasPrevious) {
// //                           _audioPlayer.seekToPrevious();
// //                         }
// //                       },
// //                       child: Container(
// //                         padding: EdgeInsets.all(10),
// //                         decoration: getDecoration(
// //                             BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //                         child: Icon(
// //                           Icons.skip_previous,
// //                           color: Colors.white70,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   //play /pause
// //                   Flexible(
// //                     child: InkWell(
// //                       onTap: () {
// //                         if (_audioPlayer.playing) {
// //                           _audioPlayer.pause();
// //                         } else {
// //                           _audioPlayer.play();
// //                         }
// //                       },
// //                       child: Container(
// //                           padding: EdgeInsets.all(20),
// //                           decoration: getDecoration(
// //                               BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //                           child: StreamBuilder<bool>(
// //                               stream: _audioPlayer.playingStream,
// //                               builder: (context, snapshot) {
// //                                 bool? playingState = snapshot.data;
// //                                 if (playingState != null && playingState) {
// //                                   return Icon(
// //                                     Icons.pause,
// //                                     size: 30,
// //                                     color: Colors.white70,
// //                                   );
// //                                 }
// //                                 return Icon(
// //                                   Icons.play_arrow,
// //                                   size: 30,
// //                                   color: Colors.white70,
// //                                 );
// //                               })),
// //                     ),
// //                   ),
// //                   //skip to next
// //                   Flexible(
// //                     child: InkWell(
// //                       onTap: () {
// //                         if (_audioPlayer.hasNext) {
// //                           _audioPlayer.seekToNext();
// //                         }
// //                       },
// //                       child: Container(
// //                         padding: EdgeInsets.all(10),
// //                         decoration: getDecoration(
// //                             BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //                         child: Icon(
// //                           Icons.skip_next,
// //                           color: Colors.white70,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             //go to playlist, shuffle, repeat all and one button
// //             Container(
// //               margin: EdgeInsets.only(top: 20, bottom: 20),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 mainAxisSize: MainAxisSize.max,
// //                 children: [
// //                   //go to playlist
// //                   Flexible(
// //                     child: InkWell(
// //                       onTap: () {
// //                         _changePlayerViewVisibility();
// //                       },
// //                       child: Container(
// //                         padding: EdgeInsets.all(10),
// //                         decoration: getDecoration(
// //                             BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //                         child: Icon(
// //                           Icons.list_alt,
// //                           color: Colors.white70,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   //playlist shuffle
// //                   Flexible(
// //                     child: InkWell(
// //                       onTap: () {
// //                         _audioPlayer.setShuffleModeEnabled(true);
// //                       },
// //                       child: Container(
// //                         padding: EdgeInsets.all(10),
// //                         decoration: getDecoration(
// //                             BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //                         child: Icon(
// //                           Icons.shuffle,
// //                           color: Colors.white70,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   //repeat mode all and one button
// //                   Flexible(
// //                     child: InkWell(
// //                       onTap: () {
// //                         _audioPlayer.loopMode == LoopMode.one
// //                             ? _audioPlayer.setLoopMode(LoopMode.all)
// //                             : _audioPlayer.setLoopMode(LoopMode.one);
// //                       },
// //                       child: Container(
// //                           padding: EdgeInsets.all(10),
// //                           decoration: getDecoration(
// //                               BoxShape.circle, Offset(2, 2), 2.0, 0.0),
// //                           child: StreamBuilder<LoopMode>(
// //                               stream: _audioPlayer.loopModeStream,
// //                               builder: (context, snapshot) {
// //                                 final loopmode = snapshot.data;
// //                                 if (LoopMode.one == loopmode) {
// //                                   return Icon(
// //                                     Icons.repeat_one,
// //                                     color: Colors.white70,
// //                                   );
// //                                 }
// //                                 return Icon(
// //                                   Icons.repeat,
// //                                   color: Colors.white70,
// //                                 );
// //                               })),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }
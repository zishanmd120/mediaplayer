import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:text_scroll/text_scroll.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //define plugn
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  //more variable
  List<SongModel> songs = [];
  String currentSongTitle = "";
  int currentIndex = 0;

  bool isPlayerViewVisible = false;

  //define a method to set the player view visibility
  void _changePlayerViewVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  //duration state stream
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        _audioPlayer.positionStream,
        _audioPlayer.durationStream,
        (position, duration) =>
            DurationState(position: position, total: duration ?? Duration.zero),
      );

  //req perm from init meth
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  final colorizeColors = [
    Colors.yellow,
    Colors.red,
    Colors.orange,
    Colors.pink,
  ];

  final colorizeTextStyle =
      const TextStyle(fontSize: 30, fontFamily: 'Horizon');

  @override
  Widget build(BuildContext context) {
    if (isPlayerViewVisible) {
      return Scaffold(
        backgroundColor: const Color(0xFF28282B),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 56, right: 20, left: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: _changePlayerViewVisibility,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 9, bottom: 9, left: 18, right: 9),
                          decoration: getDecoration(
                            BoxShape.circle,
                            const Offset(2, 2),
                            2.0,
                            0.0,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextScroll(
                        currentSongTitle,
                        velocity:
                            const Velocity(pixelsPerSecond: Offset(30, 0)),
                        intervalSpaces: 10,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: _changePlayerViewVisibility,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: getDecoration(
                            BoxShape.circle,
                            const Offset(2, 2),
                            2.0,
                            0.0,
                          ),
                          child: const Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                sizedbox(25.0),
                Container(
                  width: 300,
                  height: 300,
                  decoration: getDecoration(
                      BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                  child: QueryArtworkWidget(
                    id: songs[currentIndex].id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(200.0),
                    nullArtworkWidget: Image.asset('assets/musicavatar.png'),
                  ),
                ),
                sizedbox(35.0),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.only(bottom: 4.0),
                      decoration: getRectDecoration(
                        BorderRadius.circular(20.0),
                        const Offset(2, 2),
                        2.0,
                        0.0,
                      ),
                      child: StreamBuilder<DurationState>(
                          stream: _durationStateStream,
                          builder: (context, snapshot) {
                            final durationState = snapshot.data;
                            final progress =
                                durationState?.position ?? Duration.zero;
                            final total = durationState?.total ?? Duration.zero;
                            return ProgressBar(
                              progress: progress,
                              total: total,
                              barHeight: 20.0,
                              baseBarColor: Colors.black,
                              progressBarColor: Colors.blueGrey,
                              thumbColor: Colors.white60.withBlue(99),
                              timeLabelTextStyle: const TextStyle(
                                fontSize: 0,
                              ),
                              onSeek: (duration) {
                                _audioPlayer.seek(duration);
                              },
                            );
                          }),
                    ),
                    //position/progress and total text
                    StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          final progress =
                              durationState?.position ?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Text(
                                  progress.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  total.toString().split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                  ],
                ),
                sizedbox(5.0),
                //prev, play/pause, & seek next control buttons
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //skip to previous
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_audioPlayer.hasPrevious) {
                              _audioPlayer.seekToPrevious();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                            child: const Icon(
                              Icons.skip_previous,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      //play /pause
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_audioPlayer.playing) {
                              _audioPlayer.pause();
                            } else {
                              _audioPlayer.play();
                            }
                          },
                          child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: getDecoration(BoxShape.circle,
                                  const Offset(2, 2), 2.0, 0.0),
                              child: StreamBuilder<bool>(
                                  stream: _audioPlayer.playingStream,
                                  builder: (context, snapshot) {
                                    bool? playingState = snapshot.data;
                                    if (playingState != null && playingState) {
                                      return const Icon(
                                        Icons.pause,
                                        size: 30,
                                        color: Colors.white70,
                                      );
                                    }
                                    return const Icon(
                                      Icons.play_arrow,
                                      size: 30,
                                      color: Colors.white70,
                                    );
                                  })),
                        ),
                      ),
                      //skip to next
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_audioPlayer.hasNext) {
                              _audioPlayer.seekToNext();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                            child: const Icon(
                              Icons.skip_next,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //go to playlist, shuffle, repeat all and one button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //go to playlist
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _changePlayerViewVisibility();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                            child: const Icon(
                              Icons.list_alt,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      //playlist shuffle
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _audioPlayer.setShuffleModeEnabled(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: getDecoration(
                                BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                            child: const Icon(
                              Icons.shuffle,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      //repeat mode all and one button
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _audioPlayer.loopMode == LoopMode.one
                                ? _audioPlayer.setLoopMode(LoopMode.all)
                                : _audioPlayer.setLoopMode(LoopMode.one);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: getDecoration(BoxShape.circle,
                                  const Offset(2, 2), 2.0, 0.0),
                              child: StreamBuilder<LoopMode>(
                                  stream: _audioPlayer.loopModeStream,
                                  builder: (context, snapshot) {
                                    final loopmode = snapshot.data;
                                    if (LoopMode.one == loopmode) {
                                      return const Icon(
                                        Icons.repeat_one,
                                        color: Colors.white70,
                                      );
                                    }
                                    return const Icon(
                                      Icons.repeat,
                                      color: Colors.white70,
                                    );
                                  })),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
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
                              'Listen',
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
                              '\nListen \nTo Your \nHeart',
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
                          padding: const EdgeInsets.only(top: 40.0),
                          child: OverflowBox(
                            minHeight: 320,
                            maxHeight: 320,
                            child: Lottie.asset(
                              "assets/music.json",
                              width: 240,
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
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text("No Song Found"),
            );
          }
          //add songs
          songs.clear();
          songs = item.data!;

          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  textColor: Colors.white,
                  title: Text(
                    item.data![index].displayName.split('.').first,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'abc'),
                  ),
                  trailing: const Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                  ),
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Image.asset('assets/musicavatar.png'),
                  ),
                  onTap: () async {
                    _changePlayerViewVisibility();
                    await _audioPlayer.setAudioSource(
                      createPlayList(item.data),
                      initialIndex: index,
                    );
                    await _audioPlayer.play();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void requestStoragePermission() async {
    //only if it is not web web does not have permission
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      //ensure build method is called
      setState(() {});
    }
  }

  ConcatenatingAudioSource createPlayList(List<SongModel>? songs) {
    List<AudioSource> sources = [];
    for (var song in songs!) {
      sources.add(
        AudioSource.uri(
          Uri.parse(song.uri!),
        ),
      );
    }
    return ConcatenatingAudioSource(children: sources);
  }

  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentIndex = index;
      }
    });
  }

  sizedbox(size) {
    return SizedBox(
      height: size,
    );
  }

  getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: const Color(0xFF9F2B68),
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          // offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }

  getRectDecoration(BorderRadius borderRadius, Offset offset, double blurRadius,
      double spreadRadius) {
    return BoxDecoration(
      color: Colors.blueGrey,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Colors.white24,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Colors.black,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ],
    );
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});

  Duration position, total;
}

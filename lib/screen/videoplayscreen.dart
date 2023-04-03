import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({super.key, required this.controller});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? controller;
  bool _isPlaying = true;
  bool _showControls = false;
  bool _showProgressIndicator = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ]);
  }

  Future<void> _initializeVideoPlayer() async {
    await widget.controller.initialize();
    setState(() {});
    widget.controller.play();
    widget.controller.addListener(_onVideoPlayerChanged);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _onVideoPlayerChanged() {
    if (widget.controller.value.position >= widget.controller.value.duration) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      Navigator.of(context).pop();
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        widget.controller.play();
      } else {
        widget.controller.pause();
      }
    });
  }

  String _formatDuration(Duration duration) {
    return duration.toString().substring(2, 7);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
    widget.controller.removeListener(_onVideoPlayerChanged);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Center(
          child: widget.controller.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: widget.controller.value.aspectRatio,
                    child: VideoPlayer(widget.controller),
                  ),
                )
              : const CircularProgressIndicator(),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
              _showProgressIndicator = !_showProgressIndicator;
            });
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: widget.controller.value.aspectRatio,
                    child: VideoPlayer(widget.controller),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showProgressIndicator ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    widget.controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(bottom: 120),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: IconButton(
                      onPressed: () {
                        _togglePlayPause();
                      },
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.controller.pause();
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 42),
                    child: IconButton(
                      onPressed: () {
                        _toggleFullScreen();
                      },
                      icon: const Icon(
                        Icons.screen_rotation_alt,
                        size: 55,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 100, bottom: 35),
                    child: Text(
                      _formatDuration(widget.controller.value.duration),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 18, bottom: 25),
                    child: Icon(Icons.subtitles, size: 55, color: Colors.white),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10, top: 10),
                    child: Icon(Icons.info_outline_rounded,
                        size: 50, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

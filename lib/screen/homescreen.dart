import 'package:flutter/material.dart';
import 'package:mediaplayer/screen/musicscreen.dart';
import 'package:mediaplayer/screen/videoscreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [const MusicPlayer(), const VideoListWidget()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.white,
        icon: const Icon(
          Icons.library_music_outlined,
          color: Colors.black,
          size: 32,
        ),
        title: ("Music"),
        textStyle: const TextStyle(fontSize: 20),
        activeColorSecondary: Colors.black,
        inactiveIcon: const Icon(
          Icons.library_music_outlined,
          color: Colors.black,
          size: 32,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.video_collection_outlined,
          color: Colors.black,
          size: 32,
        ),
        title: ("Video"),
        textStyle: const TextStyle(fontSize: 20),
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.black,
        inactiveIcon: const Icon(
          Icons.video_collection_outlined,
          color: Colors.black,
          size: 32,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      backgroundColor: const Color(0xFF9F2B68),
      resizeToAvoidBottomInset: true,
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style7,
      navBarHeight: 65.0,
      margin: const EdgeInsets.only(bottom: 30, right: 30, left: 30),
      decoration: NavBarDecoration(
        colorBehindNavBar: const Color(0xFF9F2B68),
        borderRadius: BorderRadius.circular(55),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:whim_chat/src/core/screens/widgets/home_screen_items.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  void onNavigationTap(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onNavigationTap,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/chat.png')),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/people.png')),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(
              'assets/icons/story.png',
            )),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/settings.png')),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

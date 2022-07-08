import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whim_chat/src/core/providers/user_provider.dart';
import 'package:whim_chat/src/core/screens/widgets/home_screen_items.dart';
import 'package:whim_chat/src/core/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _pageController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setUserStatus("Offline");
    }
    if (state == AppLifecycleState.resumed) {
      setUserStatus("Online");
    }
  }

  //Updates PageView's page index with respect to the currenty selected nav tab
  void onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  //Updates PageView's display Item with respect to the currenty selected nav tab
  void onNavigationTap(int index) {
    _pageController.jumpToPage(index);
  }

  void setUserStatus(String status) async {
    await DatabaseService()
        .updateUserStatus(context.read<UserProvider>().userId, status);
  }

  @override
  Widget build(BuildContext context) {
    //To update user's status when screen is launched after authentication
    setUserStatus('Online');
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

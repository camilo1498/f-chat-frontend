import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/chat_page/chat_page.dart';
import 'package:chat_app/src/presentation/pages/contacts_page/contacts_page.dart';
import 'package:chat_app/src/presentation/pages/home_page/home_page_controller.dart';
import 'package:chat_app/src/presentation/pages/profile_page/profile_page.dart';
import 'package:chat_app/src/presentation/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController _homePageController;

  @override
  void initState() {
   _homePageController = HomePageController();
    super.initState();
  }
  @override
  void dispose() {
    _homePageController.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User _user = User.fromJson(GetStorage().read('user') ?? {});

    return Consumer<HomePageProvider>(
      builder: (_, homeProvider, __) {
        return Scaffold(
          backgroundColor: HexColor.fromHex('#EFEEEE'),
          body: _pages(homeProvider: homeProvider),
          bottomNavigationBar: _bottomNavigationBAr(homeProvider: homeProvider),
        );
      },
    );
  }

  Widget _pages({required HomePageProvider homeProvider}) {
    return IndexedStack(
      index: homeProvider.tapIndex,
      children: const [ChatPage(), ContactsPage(), ProfilePage()],
    );
  }

  Widget _bottomNavigationBAr({required HomePageProvider homeProvider}) {
    return BottomNavigationBar(
      backgroundColor: HexColor.fromHex('#1C2938'),
      selectedItemColor: HexColor.fromHex('#EFEEEE'),
      unselectedItemColor: HexColor.fromHex('#EFEEEE').withOpacity(0.5),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) {
        _homePageController.changeTapIndex(
            homeProvider: homeProvider, index: index);
      },
      currentIndex: homeProvider.tapIndex,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(
              Icons.chat,
              size: 20,
            ),
            label: 'Chats',
            backgroundColor: HexColor.fromHex('#1C2938')),
        BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              size: 20,
            ),
            label: 'Users',
            backgroundColor: HexColor.fromHex('#1C2938')),
        BottomNavigationBarItem(
            icon: const Icon(
              Icons.settings,
              size: 20,
            ),
            label: 'Profile',
            backgroundColor: HexColor.fromHex('#1C2938')),
      ],
    );
  }
}

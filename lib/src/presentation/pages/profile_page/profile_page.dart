import 'dart:io';

import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/profile_page/profile_controller.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/loading_indicartor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// form key
    final GlobalKey _scaffoldKey = GlobalKey();

    final ProfileController _profileController =
    ProfileController(context: context);

    /// mediaQuery
    final _size = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return Consumer<UserProvider>(
      builder: (_, userProvider, __) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: HexColor.fromHex('#EFEEEE'),
          appBar: AppBar(
            backgroundColor: HexColor.fromHex('#1C2938'),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'User info',
                style: TextStyle(
                  color: HexColor.fromHex('#EFEEEE'),
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: _size.size.width,
                height: _size.size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: HexColor.fromHex('#1C2938'),
                                        blurRadius: 5,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(360),
                                child: _profileController.getUserData().image !=
                                    null
                                    ?  FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      _profileController
                                          .getUserData()
                                          .image
                                          .toString()),
                                  placeholder: const AssetImage(
                                      'assets/images/user_placeholder.png'),
                                  placeholderErrorBuilder: (_,__,___){
                                    return const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/user_placeholder.png'),
                                    );
                                  },
                                  imageErrorBuilder: (_,__,___){
                                    return const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/user_placeholder.png'),
                                    );
                                  },
                                ) : const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/user_placeholder.png'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: HexColor.fromHex('#EFEEEE'),
                                      shape: BoxShape.circle),
                                  child: AnimatedOnTapButton(
                                    onTap: () async =>
                                    await _profileController
                                        .updatePhoto(
                                        scaffoldKey: _scaffoldKey),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.image_outlined,
                                          color: HexColor.fromHex('#EFEEEE'),
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      _card(
                        icon: Icons.person,
                        title: 'Username',
                        subTitle:
                        '${_profileController.getUserData().name} '
                            '${_profileController.getUserData().lastname}',
                      ),
                      _card(
                        icon: Icons.email,
                        title: 'Email',
                        subTitle: _profileController
                            .getUserData()
                            .email
                            .toString(),
                      ),
                      _card(
                        icon: Icons.phone,
                        title: 'Phone number',
                        subTitle: _profileController
                            .getUserData()
                            .phone
                            .toString(),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Spacer(),
                      AnimatedOnTapButton(
                        onTap: () => _profileController.openUpdateScreen(_scaffoldKey, userProvider),
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: HexColor.fromHex('#1C2938'),
                                    blurRadius: 5,
                                    offset: const Offset(0, 1))
                              ]),
                          child: Text(
                            'Edit info',
                            style: TextStyle(
                                color: HexColor.fromHex('#EFEEEE'),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      AnimatedOnTapButton(
                        onTap: () async => _profileController.logOut(),
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: HexColor.fromHex('#1C2938'),
                                    blurRadius: 5,
                                    offset: const Offset(0, 1))
                              ]),
                          child: Text(
                            'logout',
                            style: TextStyle(
                                color: HexColor.fromHex('#EFEEEE'),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Spacer(flex: 1,)
                    ],
                  ),
                ),
              ),
              if (userProvider.loading)
                const LoadingIndicator()
            ],
          ),
        );
      },
    );
  }

  /// list tile card
  Widget _card(
      {required String title,
        required String subTitle,
        required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
          leading: Icon(
            icon,
            color: HexColor.fromHex('#1C2938'),
          ),
          title: Text(
            title,
            style: TextStyle(
                color: HexColor.fromHex('#1C2938'),
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(color: HexColor.fromHex('#1C2938')),
          )),
    );
  }
}

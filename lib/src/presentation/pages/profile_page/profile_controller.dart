import 'dart:io';

import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/profile_page/update_profile_page/update_profile_controller.dart';
import 'package:chat_app/src/presentation/pages/profile_page/update_profile_page/update_profile_page.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/providers/home_page_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/dialog.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:flutter/material.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class ProfileController {
  /// context
  final BuildContext context;
  ProfileController({required this.context});

  /// load user data from storage
  User user = User.fromJson(GetStorage().read('user') ?? {});

  /// update user controller
  final UpdateProfileController _updateProfileController =
      UpdateProfileController();

  User getUserData() {
    return Provider.of<UserProvider>(context).user;
  }

  Future logOut() async {
    await Provider.of<AuthProvider>(context, listen: false).logOut();
    Provider.of<HomePageProvider>(context, listen: false).tapIndex = 0;
  }

  openUpdateScreen() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return const UpdateProfilePage();
        });
  }

  updateUserData({required User u}) async {
    await Provider.of<UserProvider>(context, listen: false)
        .updateUserInfo(user: u)
        .then((res) {
      Navigator.pop(context);
      showAlertDialog(
          context: context,
          title: res.success == true ? 'Success' : 'Error',
          message: res.message);
    });
  }

  updatePhoto({required GlobalKey scaffoldKey}) async {
    User _update = User(
        id: user.id,
        name: user.name,
        lastname: user.lastname,
        phone: user.phone,
        email: user.email,
        sessionToken: user.sessionToken,
        image: user.image);
    showDialog(
        context: context,
        builder: (_) {
          return GalleryMediaPicker(
            pathList: (path) async {
              if (path.isNotEmpty) {
                String _image = await path[0]['path'];
                Navigator.pop(context);
                await Provider.of<UserProvider>(context, listen: false)
                    .updateUserInfo(user: _update, image: File(_image))
                    .then((res) {
                  showAlertDialog(
                      context: context,
                      title: res.success == true ? 'Success' : 'Error',
                      message: res.message);
                });
              }
            },
            maxPickImages: 1,
            singlePick: true,
            onlyImages: true,
          );
        });
  }
}

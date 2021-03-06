import 'dart:io';

import 'package:chat_app/src/core/validations/textField_validator.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/presentation/pages/profile_page/update_profile_page/update_profile_page.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/providers/home_page_provider.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
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

  /// controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  /// focus node
  final FocusNode emailNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode lastnameNode = FocusNode();
  final FocusNode phoneNode = FocusNode();

  /// change field
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  /// get user local session
  User getUserData() {
    return Provider.of<UserProvider>(context).user;
  }

  /// delete user local session
  Future logOut() async {
    await Provider.of<AuthProvider>(context, listen: false).logOut();
    Provider.of<HomePageProvider>(context, listen: false).tapIndex = 0;
  }

  /// open update page in a dialog window
  openUpdateScreen(scaffoldKey, UserProvider userProvider) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return UpdateProfilePage().updatePhoto(context: context, scaffoldKey: scaffoldKey, userProvider: userProvider);
        });
  }


  updatePhoto({required GlobalKey scaffoldKey}) async {
    /// instance user data
    User _update = User(
        id: user.id,
        name: user.name,
        lastname: user.lastname,
        phone: user.phone,
        email: user.email,
        sessionToken: user.sessionToken,
        image: user.image);
    /// show gallery in dialog
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          /// open gallery
          return GalleryMediaPicker(
            pathList: (path) async {
              if (path.isNotEmpty) {
                String _image = await path[0]['path'];
                /// close gallery view
                Navigator.pop(context);
                /// send req to server
                await Provider.of<UserProvider>(context, listen: false)
                    .updateUserInfo(user: _update, image: File(_image))
                    .then((res) {
                  showToast(message: res.message);
                });
              }
            },
            maxPickImages: 1,
            singlePick: true,
            onlyImages: true,
          );
        });

  }

  /// update user data
  updateData({required BuildContext context, required GlobalKey scaffoldKey, required UserProvider userProvider}) async {
    /// validate fields
    if (!isEmail(emailController.text.trim()) ||
        !isText(nameController.text.trim()) ||
        !isText(lastnameController.text.trim()) ||
        !isPhone(phoneController.text.trim())) {
    } else {
      /// instance user data
      User _update = User(
          id: user.id,
          name: nameController.text.trim(),
          lastname: lastnameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          sessionToken: user.sessionToken,
          image: user.image);
      /// close dialog
      Navigator.pop(context);
      /// send req to server
      await userProvider.updateUserInfo(user: _update)
          .then((res) {
        showToast(message: res.message);
      });

    }
  }

}

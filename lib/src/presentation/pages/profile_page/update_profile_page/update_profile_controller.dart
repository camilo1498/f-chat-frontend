import 'package:chat_app/src/core/validations/textField_validator.dart';
import 'package:chat_app/src/presentation/pages/profile_page/profile_controller.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/models/user.dart';

class UpdateProfileController {
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

  updateData({required BuildContext context}) async {
    if (!isEmail(emailController.text.trim()) ||
        !isText(nameController.text.trim()) ||
        !isText(lastnameController.text.trim()) ||
        !isPhone(phoneController.text.trim())) {
      print('fill all fields');
    } else {
      User _update = User(
          id: user.id,
          name: nameController.text.trim(),
          lastname: lastnameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          sessionToken: user.sessionToken,
          image: user.image);
      await ProfileController(context: context).updateUserData(u: _update);
    }
  }
}

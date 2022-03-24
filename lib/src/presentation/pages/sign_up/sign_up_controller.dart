import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/core/validations/textField_validator.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:chat_app/src/data/repositories/env.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:flutter/material.dart';

class SignUpController {
  /// controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController pwdController2 = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  /// focus node
  final FocusNode emailNode = FocusNode();
  final FocusNode pwdNode = FocusNode();
  final FocusNode pwdNode2 = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode lastnameNode = FocusNode();
  final FocusNode phoneNode = FocusNode();

  /// change field
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// sign up function
  void signUp(
      {required AuthProvider authProvider,
      required GlobalKey scaffoldKey,
      required BuildContext context}) async {
    if (!isEmail(emailController.text.trim()) ||
        !isPassword(pwdController.text.trim()) ||
        !isPassword(pwdController2.text.trim()) ||
        !isText(nameController.text.trim()) ||
        !isText(lastnameController.text.trim()) ||
        !isPhone(phoneController.text.trim())) {
      snackBar(
          scaffoldGlobalKey: scaffoldKey,
          message: "Please check the fields and try again.",
          color: HexColor.fromHex('#1C2938'),
          labelText: 'close',
          textColor: HexColor.fromHex('#EFEEEE'));

      /// validate if both password fields match
    } else if (pwdController.text.trim() != pwdController2.text.trim()) {
      snackBar(
          scaffoldGlobalKey: scaffoldKey,
          message: "Password do not match.",
          color: HexColor.fromHex('#1C2938'),
          labelText: 'close',
          textColor: HexColor.fromHex('#EFEEEE'));
    } else {
      User _user = User(
          name: nameController.text.trim(),
          lastname: lastnameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          image: Environment.imageUrl,
          password: pwdController2.text.trim());

      await authProvider.register(user: _user).then((value) {
        if (value.success == true) {
          Navigator.pop(context);
        } else {
          snackBar(
              scaffoldGlobalKey: scaffoldKey,
              message: value.message ?? 'Login error',
              color: HexColor.fromHex('#1C2938'),
              labelText: 'close',
              textColor: HexColor.fromHex('#EFEEEE'));
        }
      });
    }
  }
}

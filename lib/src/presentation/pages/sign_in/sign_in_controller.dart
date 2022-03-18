import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/core/validations/textField_validator.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:flutter/material.dart';

class SignInController {
  /// controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  /// focus node
  final FocusNode emailNode = FocusNode();
  final FocusNode pwdNode = FocusNode();

  /// change field
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// sign in function
  void signIn(
      {required AuthProvider authProvider,
      required GlobalKey scaffoldKey}) async {
    if (!isEmail(emailController.text.trim()) ||
        !isPassword(pwdController.text.trim())) {
      snackBar(
          scaffoldGlobalKey: scaffoldKey,
          message: "Please check the fields and try again.",
          color: HexColor.fromHex('#1C2938'),
          labelText: 'close',
          textColor: HexColor.fromHex('#EFEEEE'));
    } else {
      await authProvider
          .login(
              email: emailController.text.trim(),
              password: pwdController.text.trim())
          .then((value) {
        if (value.success == false) {
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

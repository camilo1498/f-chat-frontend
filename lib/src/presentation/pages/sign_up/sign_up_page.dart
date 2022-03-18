// ignore_for_file: unrelated_type_equality_checks

import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/sign_up/sign_up_controller.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/auth_text_field.dart';
import 'package:chat_app/src/presentation/widgets/loading_indicartor.dart';
import 'package:chat_app/src/presentation/widgets/sign_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  /// form key
  final GlobalKey _scaffoldKey = GlobalKey();

  /// sign up controller
  final SignUpController _signUpController = SignUpController();

  /// mediaQuery
  final _size = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, authProvider, __) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            children: [
              Scaffold(
                key: _scaffoldKey,
                backgroundColor: HexColor.fromHex('#EFEEEE'),
                appBar: AppBar(
                  backgroundColor: HexColor.fromHex('#EFEEEE'),
                  elevation: 0,
                  leading: Align(
                    alignment: Alignment.center,
                    child: AnimatedOnTapButton(
                      onTap: () {
                        /// close page
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: HexColor.fromHex('#1C2938'),
                        size: 30,
                      ),
                    ),
                  ),
                ),
                body:

                    /// form view
                    Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      height: _size.size.height,
                      width: _size.size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          /// logo
                          SizedBox(
                              width: 210,
                              child: Image.asset('assets/icons/logo.png')),
                          const SizedBox(
                            height: 30,
                          ),

                          /// title
                          SizedBox(
                            width: _size.size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Register form',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Archive',
                                  color: HexColor.fromHex('#1C2938'),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          /// name field
                          AuthTextField(
                            textFieldType: TextFieldType.text,
                            textEditingController:
                                _signUpController.nameController,
                            textFocusNode: _signUpController.nameNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.text,
                            hintText: 'name',
                            validationText: "• Write your name",
                            onFieldSubmitted: () {
                              _signUpController.fieldFocusChange(
                                  context,
                                  _signUpController.nameNode,
                                  _signUpController.lastnameNode);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// lastname field
                          AuthTextField(
                            textFieldType: TextFieldType.text,
                            textEditingController:
                                _signUpController.lastnameController,
                            textFocusNode: _signUpController.lastnameNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.text,
                            hintText: 'lastname',
                            validationText: "• Write your lastname",
                            onFieldSubmitted: () {
                              _signUpController.fieldFocusChange(
                                  context,
                                  _signUpController.lastnameNode,
                                  _signUpController.phoneNode);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// phone field
                          AuthTextField(
                            textFieldType: TextFieldType.text,
                            textEditingController:
                                _signUpController.phoneController,
                            textFocusNode: _signUpController.phoneNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.phone,
                            hintText: 'phone number',
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validationText: "• Write your phone number",
                            onFieldSubmitted: () {
                              _signUpController.fieldFocusChange(
                                  context,
                                  _signUpController.phoneNode,
                                  _signUpController.emailNode);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// email field
                          AuthTextField(
                            textFieldType: TextFieldType.email,
                            textEditingController:
                                _signUpController.emailController,
                            textFocusNode: _signUpController.emailNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r"\s\b|\b\s")),
                            ],
                            hintText: 'Email address',
                            validationText: "• Invalid email",
                            onFieldSubmitted: () {
                              _signUpController.fieldFocusChange(
                                  context,
                                  _signUpController.emailNode,
                                  _signUpController.pwdNode);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// password field
                          AuthTextField(
                            textFieldType: TextFieldType.password,
                            textEditingController:
                                _signUpController.pwdController,
                            textFocusNode: _signUpController.pwdNode,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.text,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r"\s\b|\b\s")),
                            ],
                            hintText: 'Password',
                            validationText:
                                "• The password must have at least 8 characters.\n• The password must have at least one lowercase letter.\n• The password must have at least one uppercase letter.\n• The password must have numbers.\n• The password must have characters specials.",
                            onFieldSubmitted: () {
                              _signUpController.fieldFocusChange(
                                  context,
                                  _signUpController.pwdNode,
                                  _signUpController.pwdNode2);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /// password field
                          AuthTextField(
                            textFieldType: TextFieldType.password,
                            textEditingController:
                                _signUpController.pwdController2,
                            textFocusNode: _signUpController.pwdNode2,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.text,
                            inputFormatter: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r"\s\b|\b\s")),
                            ],
                            hintText: 'Confirm password',
                            validationText:
                                "• The password must have at least 8 characters.\n• The password must have at least one lowercase letter.\n• The password must have at least one uppercase letter.\n• The password must have numbers.\n• The password must have characters specials.",
                            onFieldSubmitted: () {
                              _signUpController.pwdNode.unfocus();
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          /// sign button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SignButton(
                              size: _size,
                              title: 'Sign up',
                              onTap: () => _signUpController.signUp(
                                  context: context,
                                  scaffoldKey: _scaffoldKey,
                                  authProvider: authProvider),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (authProvider.loading) const LoadingIndicator()
            ],
          ),
        );
      },
    );
  }
}

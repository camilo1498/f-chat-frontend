// ignore_for_file: must_be_immutable

import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/profile_page/profile_controller.dart';
import 'package:chat_app/src/presentation/providers/user_provider.dart';
import 'package:chat_app/src/presentation/widgets/alert_sheets/snackbar.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UpdateProfilePage {

  updatePhoto({required BuildContext context, required GlobalKey scaffoldKey, required UserProvider userProvider}){
    final ProfileController _profileController = ProfileController(context: context);
    _profileController.nameController.text =
    _profileController.user.name!;
    _profileController.lastnameController.text =
    _profileController.user.lastname!;
    _profileController.emailController.text =
    _profileController.user.email!;
    _profileController.phoneController.text =
    _profileController.user.phone!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          decoration: BoxDecoration(
            color: HexColor.fromHex('#EFEEEE'),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(
                  hintText: 'Name',
                  validationText: 'invalid name',
                  textFieldType: TextFieldType.text,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textEditingController:
                  _profileController.nameController,
                  textFocusNode: _profileController.nameNode,
                  onFieldSubmitted: () =>
                      _profileController.fieldFocusChange(
                          context,
                          _profileController.nameNode,
                          _profileController.lastnameNode),
                ),
                const SizedBox(
                  height: 10,
                ),
                AuthTextField(
                  hintText: 'Lastname',
                  validationText: 'invalid lastname',
                  textFieldType: TextFieldType.text,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textEditingController:
                  _profileController.lastnameController,
                  textFocusNode: _profileController.lastnameNode,
                  onFieldSubmitted: () =>
                      _profileController.fieldFocusChange(
                          context,
                          _profileController.lastnameNode,
                          _profileController.emailNode),
                ),
                const SizedBox(
                  height: 10,
                ),
                AuthTextField(
                  hintText: 'Email',
                  validationText: 'invalid email',
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
                  ],
                  textFieldType: TextFieldType.email,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textEditingController:
                  _profileController.emailController,
                  textFocusNode: _profileController.emailNode,
                  onFieldSubmitted: () =>
                      _profileController.fieldFocusChange(
                          context,
                          _profileController.emailNode,
                          _profileController.phoneNode),
                ),
                const SizedBox(
                  height: 10,
                ),
                AuthTextField(
                    hintText: 'Phone',
                    validationText: 'invalid phone number',
                    textFieldType: TextFieldType.text,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatter: [
                      FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
                    ],
                    textEditingController:
                    _profileController.phoneController,
                    textFocusNode: _profileController.phoneNode,
                    onFieldSubmitted: () {
                      _profileController.phoneNode.unfocus();
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOnTapButton(
                      onTap: () async =>
                          await _profileController.updateData(context: context, scaffoldKey: scaffoldKey, userProvider: userProvider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
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
                          'Update',
                          style: TextStyle(
                              color: HexColor.fromHex('#EFEEEE'),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    AnimatedOnTapButton(
                      onTap: () async => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
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
                          'Cancel',
                          style: TextStyle(
                              color: HexColor.fromHex('#EFEEEE'),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
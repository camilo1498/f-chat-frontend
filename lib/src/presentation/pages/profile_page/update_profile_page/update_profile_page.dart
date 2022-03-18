// ignore_for_file: must_be_immutable

import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/profile_page/profile_controller.dart';
import 'package:chat_app/src/presentation/pages/profile_page/update_profile_page/update_profile_controller.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:chat_app/src/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UpdateProfileController _updateProfileController = UpdateProfileController();
    _updateProfileController.nameController.text = _updateProfileController.user.name!;
    _updateProfileController.lastnameController.text = _updateProfileController.user.lastname!;
    _updateProfileController.emailController.text = _updateProfileController.user.email!;
    _updateProfileController.phoneController.text = _updateProfileController.user.phone!;
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
                  textEditingController: _updateProfileController.nameController,
                  textFocusNode: _updateProfileController.nameNode,
                  onFieldSubmitted: () => _updateProfileController
                      .fieldFocusChange(context, _updateProfileController.nameNode, _updateProfileController.lastnameNode),
                ),
                const SizedBox(height: 10,),
                AuthTextField(
                  hintText: 'Lastname',
                  validationText: 'invalid lastname',
                  textFieldType: TextFieldType.text,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textEditingController: _updateProfileController.lastnameController,
                  textFocusNode: _updateProfileController.lastnameNode,
                  onFieldSubmitted: () => _updateProfileController
                      .fieldFocusChange(context, _updateProfileController.lastnameNode, _updateProfileController.emailNode),
                ),
                const SizedBox(height: 10,),
                AuthTextField(
                  hintText: 'Email',
                  validationText: 'invalid email',
                  inputFormatter: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r"\s\b|\b\s")),
                  ],
                  textFieldType: TextFieldType.email,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textEditingController: _updateProfileController.emailController,
                  textFocusNode: _updateProfileController.emailNode,
                  onFieldSubmitted: () => _updateProfileController
                      .fieldFocusChange(context, _updateProfileController.emailNode, _updateProfileController.phoneNode),
                ),
                const SizedBox(height: 10,),
                AuthTextField(
                    hintText: 'Phone',
                    validationText: 'invalid phone number',
                    textFieldType: TextFieldType.text,
                    textInputType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatter: [
                      FilteringTextInputFormatter.deny(
                          RegExp(r"\s\b|\b\s")),
                    ],
                    textEditingController: _updateProfileController.phoneController,
                    textFocusNode: _updateProfileController.phoneNode,
                    onFieldSubmitted: (){
                      _updateProfileController.phoneNode.unfocus();
                    }),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOnTapButton(
                      onTap: () async => _updateProfileController.updateData(context: context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: HexColor.fromHex('#1C2938'),
                                  blurRadius: 5,
                                  offset: const Offset(0,1)
                              )
                            ]
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: HexColor.fromHex('#EFEEEE'),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    AnimatedOnTapButton(
                      onTap: () async => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: HexColor.fromHex('#1C2938'),
                                  blurRadius: 5,
                                  offset: const Offset(0,1)
                              )
                            ]
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: HexColor.fromHex('#EFEEEE'),
                              fontWeight: FontWeight.bold
                          ),
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
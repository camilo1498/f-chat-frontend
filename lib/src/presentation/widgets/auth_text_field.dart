import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/core/validations/textField_validator.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TextFieldType { email, password, text }

class AuthTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final FocusNode? textFocusNode;
  final String? hintText;
  final TextFieldType textFieldType;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Function() onFieldSubmitted;
  final String validationText;
  final List<TextInputFormatter>? inputFormatter;
  const AuthTextField(
      {Key? key,
      required this.onFieldSubmitted,
      this.textEditingController,
      this.textFocusNode,
      this.hintText,
      this.validationText = '',
      this.inputFormatter,
      this.textFieldType = TextFieldType.email,
      this.textInputType = TextInputType.emailAddress,
      this.textInputAction = TextInputAction.next})
      : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String _text = '';
  final _toolTipController = JustTheController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 100),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: HexColor.fromHex('#1C2938').withOpacity(0.5),
                    width: 2)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                /// text field
                Expanded(
                  child: TextFormField(
                    controller: widget.textEditingController,
                    focusNode: widget.textFocusNode,
                    keyboardType: widget.textInputType,
                    textInputAction: widget.textInputAction,
                    obscureText: widget.textFieldType == TextFieldType.email ||
                            widget.textFieldType == TextFieldType.text
                        ? false
                        : _obscureText,
                    onChanged: (value) => setState(() {
                      _text = value;
                    }),
                    inputFormatters: widget.inputFormatter ?? [],
                    onFieldSubmitted: (val) => widget.onFieldSubmitted,
                    style: TextStyle(
                      color: HexColor.fromHex('#1C2938'),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: Colors.grey[900]!.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                /// show password
                if (widget.textFieldType == TextFieldType.password)
                  AnimatedOnTapButton(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      !_obscureText
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: !_obscureText ? Colors.red : Colors.grey,
                    ),
                  ),
                const SizedBox(
                  width: 5,
                ),

                /// show error validation
                if (widget.textFieldType == TextFieldType.email
                    ? !isEmail(_text)
                    : (widget.textFieldType == TextFieldType.password
                        ? !isPassword(_text)
                        : !isText(_text)))
                  AnimatedOnTapButton(
                    onTap: () {
                      _toolTipController.showTooltip(
                        autoClose: true,
                      );
                    },
                    child: IgnorePointer(
                      child: JustTheTooltip(
                        controller: _toolTipController,
                        showDuration: const Duration(seconds: 3),
                        backgroundColor: HexColor.fromHex('#1C2938'),
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.validationText,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: HexColor.fromHex('#EFEEEE')),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}

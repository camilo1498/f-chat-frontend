import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/pages/sign_in/sign_in_controller.dart';
import 'package:chat_app/src/presentation/pages/sign_up/sign_up_page.dart';
import 'package:chat_app/src/presentation/providers/auth_provider.dart';
import 'package:chat_app/src/presentation/widgets/animations/page_transition_animation.dart';
import 'package:chat_app/src/presentation/widgets/auth_text_field.dart';
import 'package:chat_app/src/presentation/widgets/loading_indicartor.dart';
import 'package:chat_app/src/presentation/widgets/sign_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  /// Scaffold key
  final GlobalKey _scaffoldKey = GlobalKey();

  /// sign in controller
  final SignInController _signInController = SignInController();

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
        return Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              Container(
                color: HexColor.fromHex('#EFEEEE'),
                child: Stack(
                  children: [
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
                              const Spacer(),

                              /// logo
                              SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.asset('assets/icons/logo.png')),
                              const SizedBox(
                                height: 20,
                              ),

                              /// title
                              SizedBox(
                                width: _size.size.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    'Welcome',
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

                              /// email field
                              AuthTextField(
                                textFieldType: TextFieldType.email,
                                textEditingController:
                                    _signInController.emailController,
                                textFocusNode: _signInController.emailNode,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.emailAddress,
                                inputFormatter: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r"\s\b|\b\s")),
                                ],
                                hintText: 'Email address',
                                validationText: "• Invalid email",
                                onFieldSubmitted: () {
                                  _signInController.fieldFocusChange(
                                      context,
                                      _signInController.emailNode,
                                      _signInController.pwdNode);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              /// password field
                              AuthTextField(
                                textFieldType: TextFieldType.password,
                                textEditingController:
                                    _signInController.pwdController,
                                textFocusNode: _signInController.pwdNode,
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.text,
                                inputFormatter: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r"\s\b|\b\s")),
                                ],
                                hintText: 'Password',
                                validationText:
                                    "• The password must have at least 8 characters.\n• The password must have at least one lowercase letter.\n• The password must have at least one uppercase letter.\n• The password must have numbers.\n• The password must have characters specials.",
                                onFieldSubmitted: () async {
                                  _signInController.pwdNode.unfocus();
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Spacer(),

                              /// sign button
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: SignButton(
                                  size: _size,
                                  title: 'Sign in',
                                  onTap: () => _signInController.signIn(
                                      authProvider: authProvider,
                                      scaffoldKey: _scaffoldKey),
                                ),
                              ),
                              const Spacer(flex: 2),

                              /// have account text
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text:
                                                "Don't you have an account yet?\n",
                                            style: TextStyle(
                                              color: Colors.grey[900]!
                                                  .withOpacity(0.5),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.2,
                                            ),
                                          ),
                                          TextSpan(
                                              text: 'Sign up',
                                              style: TextStyle(
                                                color:
                                                    HexColor.fromHex('#1C2938'),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  /// set vibration
                                                  HapticFeedback.lightImpact();

                                                  /// open sign up page
                                                  Navigator.of(context).push(
                                                      PageTransitionAnimation(
                                                          child:
                                                              const SignUpPage(),
                                                          direction:
                                                              AxisDirection
                                                                  .left));
                                                })
                                        ]),
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// safe area top color
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: HexColor.fromHex('#EFEEEE'),
                      height: _size.padding.top,
                      width: _size.size.width,
                    ),
                  ],
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

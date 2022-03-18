import 'package:chat_app/src/core/extensions/hex_color.dart';
import 'package:chat_app/src/presentation/widgets/animations/animated_onTap_button.dart';
import 'package:flutter/material.dart';

Future<bool> errorDialog(
    {required context, required String message, required String title}) async {
  return (await showDialog(
        context: context,
        barrierColor: Colors.black38,
        barrierDismissible: true,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetAnimationDuration: const Duration(milliseconds: 300),
          insetAnimationCurve: Curves.ease,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 5, right: 20, left: 20),
              alignment: Alignment.center,
              height: 230,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: HexColor.fromHex('#1C2938'),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white10,
                        offset: Offset(0, 1),
                        blurRadius: 4),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  /// title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: HexColor.fromHex('#EFEEEE'),
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white54,
                          letterSpacing: 0.1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  /// close
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedOnTapButton(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: HexColor.fromHex('#EFEEEE'),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Close',
                            style: TextStyle(
                                fontSize: 16,
                                color: HexColor.fromHex('#1C2938'),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )) ??
      false;
}

showAlertDialog({required BuildContext context ,String? title, String? message}){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: HexColor.fromHex('#1C2938'),
          title: Text(
            title!,
            style: TextStyle(
                color: HexColor.fromHex('#EFEEEE'),
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            message!,
            style: TextStyle(
                color: HexColor.fromHex('#EFEEEE').withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),
          ),
          actions: [
            AnimatedOnTapButton(
              onTap: () async => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  'Ok',
                  style: TextStyle(
                      color: HexColor.fromHex('#EFEEEE'),
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        );
      });

}
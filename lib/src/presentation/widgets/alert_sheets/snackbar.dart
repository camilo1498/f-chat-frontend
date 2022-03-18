import 'package:flutter/material.dart';

snackBar(
    {required scaffoldGlobalKey,
    required String message,
    required Color color,
    required String labelText,
    required Color textColor}) {
  scaffoldGlobalKey.currentState.removeCurrentSnackBar();
  SnackBar _snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(
          color: textColor, fontWeight: FontWeight.w600, fontSize: 13),
    ),
    elevation: 5,
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    action: SnackBarAction(
      onPressed: () {},
      label: labelText,
    ),
  );
  return scaffoldGlobalKey.currentState.showSnackBar(_snackBar);
}

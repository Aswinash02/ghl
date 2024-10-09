import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart';

class ToastComponent {
  static showDialog(String msg, {int duration = 0, int gravity = 0}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: duration != 0 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: gravity != 0 ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      backgroundColor: const Color.fromRGBO(239, 239, 239, .9),
      textColor: MyTheme.font_grey,
      fontSize: 16.0,
    );
  }
}

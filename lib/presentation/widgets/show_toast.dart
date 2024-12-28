import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info , warning}

void showToast({
  required String message,
  ToastType type = ToastType.info,
}) {
  Color backgroundColor;
  Color textColor = Colors.white;
  IconData icon;

  switch (type) {
    case ToastType.success:
      backgroundColor = Colors.black.withOpacity(0.9);
      icon = Icons.check_circle_outlined;
      break;
    case ToastType.error:
      backgroundColor = Color(0xFF363636);
      icon = Icons.error_outline;
      break;
    case ToastType.warning:
      backgroundColor = Color(0xFF424242);
      icon = Icons.warning_amber_outlined;
      break;
    case ToastType.info:
    default:
      backgroundColor = Color(0xFF2D2D2D);
      icon = Icons.info_outline;
      break;
  }



  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0
  );
}


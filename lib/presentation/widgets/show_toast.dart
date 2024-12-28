import 'package:flutter/material.dart';

enum ToastType { success, error, info, warning }

void showToast({
  required String message,
  required BuildContext context,
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

  final overlay = Overlay.of(context);
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              )
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
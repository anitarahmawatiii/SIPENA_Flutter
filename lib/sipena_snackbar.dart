import 'package:flutter/material.dart';

abstract final class SipenaSnackBar {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF168575),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

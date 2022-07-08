import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 1),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration,
      ),
    );
  }
}

class ValidatorUtil {
  static String? validateEmptyText(
    String? value, {
    String errorMessage = "Field can't be empty",
  }) {
    if (value != null && value.isNotEmpty) {
      return null;
    } else {
      return errorMessage;
    }
  }
}

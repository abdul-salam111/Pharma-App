import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class AppToasts {
  static void showSuccessToast(BuildContext context, String message) {
    Flushbar(
      title: "Success",
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  static void showErrorToast(BuildContext context, String message) {
    Flushbar(
      title: "Error",
      message: message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  static void showWarningToast(BuildContext context, String message) {
    Flushbar(
      title: "Warning",
      message: message,
      backgroundColor: Colors.orange,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}

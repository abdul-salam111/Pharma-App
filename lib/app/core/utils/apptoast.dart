import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';

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

  static void showLoaderDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  static void dismiss() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

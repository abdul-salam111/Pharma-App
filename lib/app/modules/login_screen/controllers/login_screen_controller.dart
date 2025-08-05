import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final keyController = TextEditingController();
  final phoneContrller = TextEditingController();
  final passwordController = TextEditingController();
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    keyController.dispose();
    phoneContrller.dispose();
    passwordController.dispose();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pharma_app/app/routes/app_pages.dart';
import 'package:pharma_app/app/services/session_manager.dart';

// import 'session_manager.dart';

class SplashServices {
  void isLoggedIn() {
  Future.delayed(Duration(seconds: 2),(){
     checkLoginStatus();
  });
  }

  Future<void> checkLoginStatus() async {
    try {
      await SessionController().getUserfromSharedpref();

      if (SessionController().islogin == true) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN_SCREEN);
      }
    } catch (e) {
      debugPrint('Error in checkLoginStatus: $e');
    }
  }
}

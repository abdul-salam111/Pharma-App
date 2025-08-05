// import 'dart:async';
// import 'package:anmol_marketing/routes/app_routes.dart';
// import 'package:anmol_marketing/services/session_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';

// // import 'session_manager.dart';

// class SplashServices {
//   void isLoggedIn() {
//     checkLoginStatus();
//   }

//   Future<void> checkLoginStatus() async {
//     try {
//       await SessionController().getUserfromSharedpref();

//       if (SessionController().islogin == true) {
//         Get.offAllNamed(AppRoutes.navbar);
//       } else {
//         Get.offAllNamed(AppRoutes.login);
//       }
//     } catch (e) {
//       debugPrint('Error in checkLoginStatus: $e');
//     }
//   }
// }

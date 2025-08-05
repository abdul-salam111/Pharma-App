// import 'dart:convert';

// import 'package:anmol_marketing/data/models/get_models/get_login_response.dart';
// import 'package:anmol_marketing/services/storage.dart';

// class SessionController {
//   GetLoginResponse getUserDetails = GetLoginResponse();

//   static final SessionController _session = SessionController._internal();
//   bool islogin = false;
//   String? userId;
//   SessionController._internal();

//   static SessionController get instance => _session;

//   factory SessionController() {
//     return _session;
//   }


//   Future<void> saveUserInStorage(GetLoginResponse user) async {
//     await storage.setValues(StorageKeys.userDetails, jsonEncode(user));
//     await storage.setValues(StorageKeys.loggedIn, 'true');
//      await storage.setValues(
//         StorageKeys.userId,
//         user.customer!.customerId!.toString(),
//       );
//       await storage.setValues(
//         StorageKeys.token,
//         user.authToken!.accessToken!,
//       );
//   }

//   Future<void> getUserfromSharedpref() async {
//     try {
//       final userData = await storage.readValues(StorageKeys.userDetails);
//       if (userData != null) {
//         SessionController().getUserDetails = GetLoginResponse.fromJson(
//           jsonDecode(userData),
//         );
//       }
//       final isLoggedIn = await storage.readValues(StorageKeys.loggedIn);
//       SessionController().islogin = (isLoggedIn == 'true' ? true : false);
//     } catch (e) {
//       throw Exception(e);
//     }
//   }
// }

import 'dart:convert';
import 'package:pharma_app/app/data/models/get_models/login_response_model.dart';
import 'package:pharma_app/app/services/storage.dart';

class SessionController {
  LoginResponseModel getUserDetails = LoginResponseModel();

  static final SessionController _session = SessionController._internal();
  bool islogin = false;
  String? userId;
  SessionController._internal();

  static SessionController get instance => _session;

  factory SessionController() {
    return _session;
  }

  Future<void> saveUserInStorage(LoginResponseModel user) async {
    await storage.setValues(StorageKeys.userDetails, jsonEncode(user));
    await storage.setValues(StorageKeys.loggedIn, 'true');
    await storage.setValues(StorageKeys.userId, user.userId.toString());
    // await storage.setValues(
    //   StorageKeys.token,
    //   user.authToken!.accessToken!,
    // );
  }

  Future<void> getUserfromSharedpref() async {
    try {
      final userData = await storage.readValues(StorageKeys.userDetails);
      if (userData != null) {
        SessionController().getUserDetails = LoginResponseModel.fromJson(
          jsonDecode(userData),
        );
      }
      final isLoggedIn = await storage.readValues(StorageKeys.loggedIn);
      SessionController().islogin = (isLoggedIn == 'true' ? true : false);
    } catch (e) {
      throw Exception(e);
    }
  }
}

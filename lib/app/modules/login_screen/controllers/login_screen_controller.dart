import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/models/post_models/login_model.dart';
import 'package:pharma_app/app/repositories/auth_repository/auth_repository.dart';
import 'package:pharma_app/app/routes/app_pages.dart';
import 'package:pharma_app/app/services/session_manager.dart';

class LoginScreenController extends GetxController {
  final keyController = TextEditingController();
  final phoneContrller = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  Future loginUser() async {
    try {
      isLoading.value = true;
      final userData = await AuthRepository.loginUser(
        loginUser: LoginUserModel(
          password: passwordController.text.trim(),
          customerKey: keyController.text.trim(),
          mobileNo: phoneContrller.text.trim(),
        ),
      );
      await SessionController().saveUserInStorage(userData);
      await SessionController().getUserfromSharedpref();
      await Get.toNamed(Routes.HOME);
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      AppToasts.showErrorToast(Get.context!, error.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    keyController.dispose();
    phoneContrller.dispose();
    passwordController.dispose();
  }
}

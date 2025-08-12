import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/core/utils/validators.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';
import 'package:pharma_app/app/modules/widgets/custom_textfield.dart';
import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  const LoginScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.focusScope.unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.appLogo),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: padding30,
              child: Column(
                crossAxisAlignment: crossAxisStart,
                children: [
                  heightBox(150),
                  Text(
                    "Welcome Back",
                    style: context.headlineMediumStyle!.copyWith(
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  heightBox(5),
                  Text(
                    "Please login to continue",
                    style: context.bodyMediumStyle!.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                  heightBox(40),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: controller.keyController,
                          hintText: "Customer Key",
                          prefixIcon: Iconsax.key,
                          keyboardType: TextInputType.text,
                          borderColor: AppColors.darkGreyColor,
                          fillColor: AppColors.halfWhiteColor,
                          validator: (p0) =>
                              Validator.validateRequired("Customer Key"),
                        ),
                        heightBox(10),
                        CustomTextFormField(
                          controller: controller.phoneContrller,
                          hintText: "Mobile Number",
                          prefixIcon: Iconsax.call,
                          keyboardType: TextInputType.phone,
                          borderColor: AppColors.darkGreyColor,
                          fillColor: AppColors.halfWhiteColor,
                          validator: (p0) =>
                              Validator.validateRequired("Mobile Number"),
                        ),
                        heightBox(10),
                        CustomTextFormField(
                          obscureText: true,
                          controller: controller.passwordController,
                          hintText: "Password",
                          prefixIcon: Iconsax.lock,
                          keyboardType: TextInputType.text,
                          borderColor: AppColors.darkGreyColor,
                          fillColor: AppColors.halfWhiteColor,
                          validator: (p0) =>
                              Validator.validateRequired("Password"),
                        ),
                        heightBox(40),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Obx(
                            () => CustomButton(
                              isLoading: controller.isLoading.value,
                              radius: 10,
                              text: "Sign In",
                              onPressed: () async {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  await controller.loginUser();
                                }
                              },
                              backgroundColor: AppColors.appPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

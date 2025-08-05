import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/core.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? label;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int maxLines; // For multiline support

  final RxBool isObscure = true.obs;
  final Color fillColor;
  final Color borderColor;
  final Color labelColor;
  final bool isrequired;
  final int labelfontSize;
  final bool readonly;

  CustomTextFormField({
    super.key,
    this.hintText,
    this.label,
    this.readonly = false,
    this.prefixIcon,
    this.isrequired = false,
    this.fillColor = AppColors.appLightThemeBackground,
    this.borderColor = Colors.transparent,
    this.controller,
    this.labelColor = AppColors.greyTextColor,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.labelfontSize = 16,
    this.onChanged,
    this.onTap,
    this.maxLines = 1, // Default is single line
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisStart,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label!,
                  style: context.bodySmallStyle!.copyWith(
                    color: labelColor,

                    fontSize: labelfontSize.toDouble(),
                  ),
                ),
                isrequired
                    ? TextSpan(
                        text: "*",
                        style: context.bodyMediumStyle!.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: labelfontSize.toDouble(),
                        ),
                      )
                    : TextSpan(),
              ],
            ),
          ),
        heightBox((5)),
        obscureText
            ? Obx(
                () => TextFormField(
                  cursorColor: Colors.black,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  readOnly: readonly,
                  style: context.bodySmallStyle!.copyWith(
                    color: AppColors.blackTextColor,
                  ),
                  controller: controller,
                  obscureText: obscureText ? isObscure.value : false,
                  keyboardType: keyboardType,
                  maxLines: obscureText
                      ? 1
                      : maxLines, // Force single line if obscureText is true
                  decoration: InputDecoration(
                    hintStyle: context.bodySmallStyle!.copyWith(
                      color: AppColors.greyTextColor,
                    ),
                    hintText: hintText,
                    prefixIcon: prefixIcon != null
                        ? Icon(prefixIcon, color: AppColors.greyColor, size: 20)
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: fillColor,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.greyColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 10),
                    suffixIcon: obscureText
                        ? IconButton(
                            icon: Icon(
                              isObscure.value ? Iconsax.eye_slash : Iconsax.eye,
                              color: AppColors.greyColor,
                              size: 20,
                            ),
                            onPressed: () {
                              isObscure
                                  .toggle(); // Toggle the value of isObscure
                            },
                          )
                        : null,
                  ),
                  validator: validator,
                  onChanged: onChanged,
                  onTap: onTap,
                ),
              )
            : TextFormField(
                cursorColor: Colors.black,

                autofocus: false,
                textCapitalization: TextCapitalization.words,
                readOnly: readonly,
                style: context.bodySmallStyle!.copyWith(
                  color: AppColors.blackTextColor,
                ),
                controller: controller,
                obscureText: obscureText ? isObscure.value : false,
                keyboardType: keyboardType,
                maxLines: obscureText
                    ? 1
                    : maxLines, // Force single line if obscureText is true
                decoration: InputDecoration(
                  hintStyle: context.bodySmallStyle!.copyWith(
                    color: AppColors.greyColor,
                  ),
                  hintText: hintText,
                  prefixIcon: prefixIcon != null
                      ? Icon(prefixIcon, color: AppColors.greyColor, size: 20)
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.only(left: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.greyColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: fillColor,
                  filled: true,
                  suffixIcon: obscureText
                      ? IconButton(
                          icon: Icon(
                            isObscure.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.greyColor,
                          ),
                          onPressed: () {
                            isObscure.toggle(); // Toggle the value of isObscure
                          },
                        )
                      : null,
                ),
                validator: validator,
                onChanged: onChanged,
                onTap: onTap,
              ),
      ],
    );
  }
}

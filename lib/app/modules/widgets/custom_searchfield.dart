import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pharma_app/app/core/core.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final RxBool showClearButton = false.obs;
    final FocusNode? focusNode;

  CustomSearchField({
    super.key,
    this.hintText = "Search",
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
      this.focusNode,
  }) {
    // Initialize listener to show/hide clear button
    controller?.addListener(() {
      showClearButton.value = controller?.text.isNotEmpty ?? false;
    });
  }

  void _clearText() {
    controller?.clear();  // This clears the text
    if (onChanged != null) {
      onChanged!('');  // Notify parent widget (if needed)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        child: TextField(
           focusNode: focusNode,
          autofocus: false,
          controller: controller,
          onChanged: (text) {
            showClearButton.value = text.isNotEmpty; // Show button if text exists
            if (onChanged != null) onChanged!(text);
          },
          onTap: onTap,
          readOnly: readOnly,
          style: context.bodySmallStyle!.copyWith(color: AppColors.greyColor),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: hintText,
            hintStyle: context.bodySmallStyle!.copyWith(
              color: AppColors.greyColor,
            ),
            prefixIcon: Icon(
              Iconsax.search_normal,
              color: AppColors.greyColor,
              size: 20,
            ),
            suffixIcon: showClearButton.value
                ? IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppColors.greyColor,
                      size: 20,
                    ),
                    onPressed: _clearText, // Clears text on tap
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.darkGreyColor.withAlpha((0.6 * 255).toInt()),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.darkGreyColor.withAlpha((0.6 * 255).toInt()),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.greyColor),
            ),
          ),
        ),
      ),
    );
  }
}
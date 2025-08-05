
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pharma_app/app/core/core.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomSearchField({
    Key? key,
    this.hintText = "Search",
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      child: TextField(
        autofocus: false,
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
      
        style: context.bodySmallStyle!.copyWith(color: AppColors.greyColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          hintStyle: context.bodySmallStyle!.copyWith(
            color: AppColors.greyColor,
          ),
          prefixIcon: Icon(Iconsax.search_normal, color: AppColors.greyColor,size: 20,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color:  AppColors.darkGreyColor.withAlpha((0.6 * 255).toInt()),),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(  color: AppColors.darkGreyColor.withAlpha((0.6 * 255).toInt()),),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.greyColor),
          ),
        ),
      ),
    );
  }
}

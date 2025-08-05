// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';
import '../controllers/select_customer_controller.dart';

class SelectCustomerView extends GetView<SelectCustomerController> {
  const SelectCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Customer'), centerTitle: true),
      body: Padding(
        padding: padding14,
        child: Column(
          children: [heightBox(20), _buildCustomerSelectionCard(context)],
        ),
      ),
    );
  }

  Widget _buildCustomerSelectionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      padding: padding24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(context),
          heightBox(30),
          _buildSectorDropdown(context),
          heightBox(20),
          _buildTownDropdown(context),
          heightBox(20),
          _buildCustomerDropdown(context),
          heightBox(20),
          Obx(
            () => controller.isSelectionComplete
                ? Container(
                    width: double.infinity,
                    padding: padding14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: crossAxisStart,
                      children: [
                        Text(
                          "Customer Details",
                          style: context.bodyMediumStyle!.copyWith(
                            color: AppColors.blackTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        heightBox(20),
                        Row(
                          mainAxisAlignment: mainAxisSpaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Address:",
                                style: context.displayLargeStyle!.copyWith(
                                  color: AppColors.blackTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: crossAxisEnd,
                                children: [
                                  Text(
                                    "${controller.selectedCustomer.value?.address}",
                                    style: context.displayLargeStyle!.copyWith(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        heightBox(10),
                        Row(
                          mainAxisAlignment: mainAxisSpaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Contact Person:",
                                style: context.displayLargeStyle!.copyWith(
                                  color: AppColors.blackTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: crossAxisEnd,

                                children: [
                                  Text(
                                    "${controller.selectedCustomer.value?.customerContact}",
                                    style: context.displayLargeStyle!.copyWith(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        heightBox(10),
                        Row(
                          mainAxisAlignment: mainAxisSpaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Phone:",
                                style: context.displayLargeStyle!.copyWith(
                                  color: AppColors.blackTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: crossAxisEnd,

                                children: [
                                  Text(
                                    "${controller.selectedCustomer.value?.phoneNumber}",
                                    style: context.displayLargeStyle!.copyWith(
                                      color: AppColors.greyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
          heightBox(40),
          _buildSelectButton(context),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildCardTitle(BuildContext context) {
    return Text(
      "Select Customer",
      style: context.bodyMediumStyle!.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectorDropdown(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.05,
      child: Obx(
        () => _buildDropdownSearch<String>(
          items: controller.sectors,
          selectedItem: controller.selectedSector.value,
          hintText: "Sector",
          searchHint: "Search Sector...",
          enabled: true,
          onChanged: (value) => controller.onSectorChanged(value),
          context: context,
        ),
      ),
    );
  }

  Widget _buildTownDropdown(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.05,
      child: Obx(
        () => _buildDropdownSearch<String>(
          items: controller.towns,
          selectedItem: controller.selectedTown.value,
          hintText: "Town",
          searchHint: "Search Town...",
          enabled: controller.selectedSector.value.isNotEmpty,
          onChanged: (value) => controller.onTownChanged(value),
          context: context,
        ),
      ),
    );
  }

  Widget _buildCustomerDropdown(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.05,
      child: Obx(
        () => _buildDropdownSearch<CustomerModel>(
          items: controller.customers,
          selectedItem: controller.selectedCustomer.value,
          hintText: "Customer",
          searchHint: "Search Customer...",
          enabled: controller.selectedTown.value.isNotEmpty,
          onChanged: (value) => controller.onCustomerChanged(value),
          context: context,
        ),
      ),
    );
  }

  Widget _buildDropdownSearch<T>({
    required List<T> items,
    required dynamic selectedItem,
    required String hintText,
    required String searchHint,
    required bool enabled,
    required Function(T?) onChanged,
    required BuildContext context,
  }) {
    return DropdownSearch<T>(
      items: (filter, _) => items,
      selectedItem: selectedItem == "" ? null : selectedItem,
      onChanged: onChanged,
      enabled: enabled,
      compareFn: (T a, T b) {
        if (T == CustomerModel) {
          return (a as CustomerModel).name == (b as CustomerModel).name;
        }
        return a == b;
      },
      itemAsString: (item) {
        if (item is CustomerModel) return item.name;
        return item.toString();
      },
      popupProps: _buildPopupProps(searchHint, context),
      decoratorProps: DropDownDecoratorProps(
        baseStyle: context.bodySmallStyle!.copyWith(
          color: AppColors.greyTextColor,
        ),
        decoration: _buildInputDecoration(
          hintText: hintText,
          enabled: enabled,
          context: context,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required bool enabled,
    required BuildContext context,
  }) {
    final Color iconColor = enabled
        ? AppColors.greyTextColor
        : AppColors.greyTextColor.withOpacity(0.5);

    return InputDecoration(
      hintText: hintText,
      contentPadding: EdgeInsets.zero,
      hintStyle: context.bodySmallStyle!.copyWith(color: iconColor),
      // suffixIcon: Icon(Iconsax.arrow_down_1, color: iconColor, size: 15),
      border: _buildUnderlineBorder(AppColors.borderColor),
      enabledBorder: _buildUnderlineBorder(AppColors.borderColor),
      focusedBorder: _buildUnderlineBorder(AppColors.greyColor),
      disabledBorder: _buildUnderlineBorder(
        AppColors.borderColor.withOpacity(0.5),
      ),
    );
  }

  UnderlineInputBorder _buildUnderlineBorder(Color color) {
    return UnderlineInputBorder(borderSide: BorderSide(color: color));
  }

  PopupProps<T> _buildPopupProps<T>(String searchHint, BuildContext context) {
    return PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: searchHint,
          hintStyle: context.bodySmallStyle!.copyWith(
            color: AppColors.greyTextColor,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal,
            size: 20,
            color: AppColors.greyColor,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greyTextColor),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greyTextColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      menuProps: const MenuProps(backgroundColor: Colors.white, elevation: 8),
      itemBuilder: (context, item, isDisabled, isSelected) {
        if (item is CustomerModel) {
          return ListTile(
            title: Text(
              item.name,
              style: context.bodySmallStyle!.copyWith(
                color: isSelected
                    ? AppColors.appPrimaryColor
                    : AppColors.blackTextColor,
              ),
            ),
            subtitle: Text(
              item.address,
              style: context.bodySmallStyle!.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
            enabled: !isDisabled,
            selected: isSelected,
          );
        }

        // Fallback if item is not CustomerModel
        return ListTile(
          title: Text(item.toString(), style: context.bodySmallStyle),
        );
      },
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.screenHeight * 0.06,
      child: Obx(() {
        final bool isEnabled = controller.isSelectionComplete;
        return CustomButton(
          radius: 10,
          text: "Select Customer",
          onPressed: isEnabled ? controller.onCustomerSelected : () {},
          backgroundColor: isEnabled
              ? AppColors.appPrimaryColor
              : AppColors.greyColor,
        );
      }),
    );
  }
}

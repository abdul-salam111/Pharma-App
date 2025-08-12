// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/modules/widgets/custom_button.dart';
import '../controllers/select_customer_controller.dart';

class SelectCustomerView extends GetView<SelectCustomerController> {
  const SelectCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Customer'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.refreshData(),
            icon: const Icon(Iconsax.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isAnyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Padding(
          padding: padding14,
          child: Column(
            children: [
              heightBox(20),
              _buildCustomerSelectionCard(context),
            ],
          ),
        );
      }),
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
          _buildCustomerDetailsSection(context),
          heightBox(40),
          _buildSelectButton(context),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsSection(BuildContext context) {
    return Obx(
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
                  _buildDetailRow(
                    context,
                    "Name:",
                    controller.selectedCustomerModel?.customerName ?? "N/A",
                  ),
                  heightBox(10),
                  _buildDetailRow(
                    context,
                    "Address:",
                    controller.selectedCustomerModel?.address ?? "N/A",
                  ),
                  heightBox(10),
                  _buildDetailRow(
                    context,
                    "Contact Person:",
                    controller.selectedCustomerModel?.contactPerson ?? "N/A",
                  ),
                  heightBox(10),
                  _buildDetailRow(
                    context,
                    "Phone:",
                    controller.selectedCustomerModel?.phone1 ?? "N/A",
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: mainAxisSpaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: context.displayLargeStyle!.copyWith(
              color: AppColors.blackTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.displayLargeStyle!.copyWith(
              color: AppColors.greyTextColor,
            ),
          ),
        ),
      ],
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
        () => _buildDropdownSearch<GetSectorsModel>(
          items: controller.sectors,
          selectedItem: controller.selectedSector.value,
          hintText: "Select Sector",
          searchHint: "Search Sector...",
          enabled: controller.sectors.isNotEmpty,
          onChanged: (value) => controller.onSectorChanged(value),
          context: context,
          itemAsString: (item) => item?.sectorName ?? "",
          isLoading: controller.isLoadingSectors.value,
        ),
      ),
    );
  }

  Widget _buildTownDropdown(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.05,
      child: Obx(
        () => _buildDropdownSearch<GetTownsModel>(
          items: controller.towns,
          selectedItem: controller.selectedTown.value,
          hintText: "Select Town",
          searchHint: "Search Town...",
          enabled: controller.selectedSector.value != null && controller.towns.isNotEmpty,
          onChanged: (value) => controller.onTownChanged(value),
          context: context,
          itemAsString: (item) => item?.townName ?? "",
        ),
      ),
    );
  }

  Widget _buildCustomerDropdown(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.05,
      child: Obx(
        () => _buildDropdownSearch<GetCustomersModel>(
          items: controller.customers,
          selectedItem: controller.selectedCustomer.value,
          hintText: "Select Customer",
          searchHint: "Search Customer...",
          enabled: controller.selectedTown.value != null && controller.customers.isNotEmpty,
          onChanged: (value) => controller.onCustomerChanged(value),
          context: context,
          itemAsString: (item) => item?.customerName ?? "",
        ),
      ),
    );
  }

  Widget _buildDropdownSearch<T>({
    required List<T> items,
    required T? selectedItem,
    required String hintText,
    required String searchHint,
    required bool enabled,
    required Function(T?) onChanged,
    required BuildContext context,
    required String Function(T?) itemAsString,
    bool isLoading = false,
  }) {
    return DropdownSearch<T>(
      items: (filter, _) => items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      enabled: enabled && !isLoading,
      compareFn: (T? a, T? b) {
        if (a == null || b == null) return a == b;
        return itemAsString(a) == itemAsString(b);
      },
      itemAsString: itemAsString,
      popupProps: _buildPopupProps<T>(searchHint, context, itemAsString),
      decoratorProps: DropDownDecoratorProps(
        baseStyle: context.bodySmallStyle!.copyWith(
          color: AppColors.greyTextColor,
        ),
        decoration: _buildInputDecoration(
          hintText: isLoading ? "Loading..." : hintText,
          enabled: enabled && !isLoading,
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

  PopupProps<T> _buildPopupProps<T>(
    String searchHint,
    BuildContext context,
    String Function(T?) itemAsString,
  ) {
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
        String displayText = itemAsString(item);
        String? subtitle;
        
        // Add subtitle for customers to show additional info
        if (T == GetCustomersModel && item != null) {
          final customer = item as GetCustomersModel;
          subtitle = customer.address;
        }
        
        return ListTile(
          title: Text(
            displayText,
            style: context.bodySmallStyle!.copyWith(
              color: isSelected
                  ? AppColors.appPrimaryColor
                  : AppColors.blackTextColor,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: context.bodySmallStyle!.copyWith(
                    color: AppColors.greyTextColor,
                  ),
                )
              : null,
          enabled: !isDisabled,
          selected: isSelected,
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
          onPressed: isEnabled
              ? () {
                  controller.onCustomerSelected();
               
                }
              : (){},
          backgroundColor: isEnabled
              ? AppColors.appPrimaryColor
              : AppColors.greyColor,
        );
      }),
    );
  }
}
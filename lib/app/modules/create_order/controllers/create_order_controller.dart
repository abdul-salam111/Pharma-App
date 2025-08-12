import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
   final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}

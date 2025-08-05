import 'package:get/get.dart';

import '../controllers/select_customer_controller.dart';

class SelectCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectCustomerController>(
      () => SelectCustomerController(),
    );
  }
}

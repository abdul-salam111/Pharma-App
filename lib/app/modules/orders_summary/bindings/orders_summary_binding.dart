import 'package:get/get.dart';

import '../controllers/orders_summary_controller.dart';

class OrdersSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersSummaryController>(
      () => OrdersSummaryController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/orders_on_date_controller.dart';

class OrdersOnDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersOnDateController>(
      () => OrdersOnDateController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/order_details_on_date_controller.dart';

class OrderDetailsOnDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsOnDateController>(
      () => OrderDetailsOnDateController(),
    );
  }
}

import 'package:get/get.dart';

import '../modules/all_products/bindings/all_products_binding.dart';
import '../modules/all_products/views/all_products_view.dart';
import '../modules/create_order/bindings/create_order_binding.dart';
import '../modules/create_order/views/create_order_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/order_details_on_date/bindings/order_details_on_date_binding.dart';
import '../modules/order_details_on_date/views/order_details_on_date_view.dart';
import '../modules/orders_on_date/bindings/orders_on_date_binding.dart';
import '../modules/orders_on_date/views/orders_on_date_view.dart';
import '../modules/orders_summary/bindings/orders_summary_binding.dart';
import '../modules/orders_summary/views/orders_summary_view.dart';
import '../modules/select_customer/bindings/select_customer_binding.dart';
import '../modules/select_customer/views/select_customer_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_CUSTOMER,
      page: () => const SelectCustomerView(),
      binding: SelectCustomerBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRODUCTS,
      page: () => const AllProductsView(),
      binding: AllProductsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ORDER,
      page: () => const CreateOrderView(),
      binding: CreateOrderBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS_SUMMARY,
      page: () => const OrdersSummaryView(),
      binding: OrdersSummaryBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS_ON_DATE,
      page: () => const OrdersOnDateView(),
      binding: OrdersOnDateBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS_ON_DATE,
      page: () => const OrderDetailsOnDateView(),
      binding: OrderDetailsOnDateBinding(),
    ),
  ];
}

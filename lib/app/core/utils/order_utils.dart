import 'package:pharma_app/app/data/models/post_models/create_order_for_local.dart';

class OrderUtils {
  static double calculateProductTotal(OrderProducts product) {
    return product.quantity * product.price;
  }

  static double calculateCompanyTotal(List<OrderProducts> products) {
    return products.fold(
      0.0,
      (sum, product) => sum + (product.quantity * product.price),
    );
  }

  static int calculateCompanyTotalProducts(List<OrderProducts> products) {
    return products.length; // Count of distinct products, not sum of quantities
  }

  static int calculateCompanyTotalItems(List<OrderProducts> products) {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }

  static double calculateGrandTotal(List<OrderCompanies> companies) {
    return companies.fold(
      0.0,
      (sum, company) => sum + company.companyTotalAmount,
    );
  }

  static int calculateGrandTotalItems(List<OrderCompanies> companies) {
    return companies.fold(0, (sum, company) => sum + company.companyTotalItems);
  }
}

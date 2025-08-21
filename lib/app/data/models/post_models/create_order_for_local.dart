class OrderModel {
  final String orderId;
  final String orderDate;
  final String syncDate;
  final double grandTotal;
  final int totalProducts;
  final List<OrderCompany> companies;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.grandTotal,
    required this.syncDate,
    required this.totalProducts,
    required this.companies,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      orderDate: json['orderDate'],
      syncDate: json['syncDate'],
      grandTotal: json['grandTotal'],
      totalProducts: json['totalProducts'],
      companies: [], // This would be populated separately
    );
  }
}

class OrderCompany {
  final int companyId;
  final String companyName;
  final double companyTotal;
  final int totalProducts;
  final List<OrderProduct> products;

  OrderCompany({
    required this.companyId,
    required this.companyName,
    required this.companyTotal,
    required this.totalProducts,
    required this.products,
  });

  factory OrderCompany.fromJson(Map<String, dynamic> json) {
    return OrderCompany(
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyTotal: json['companyTotal'],
      totalProducts: json['totalProducts'],
      products: [],
    );
  }
}

class OrderProduct {
  final int productId;
  final String productName;
  final String qty;
  final double bns;
  final double discRatio;
  final double price;

  OrderProduct({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.bns,
    required this.discRatio,
    required this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: json['productId'],
      productName: json['productName'],
      qty: json['qty'],
      bns: json['bns'],
      discRatio: json['discRatio'],
      price: json['price'],
    );
  }
}

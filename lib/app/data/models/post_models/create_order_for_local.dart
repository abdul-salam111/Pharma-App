class OrderItems {
  final int? orderId;
  final String customerId;
  final String customerName;
  final List<OrderCompanies> companies;
  final DateTime orderDate;
  final DateTime? syncDate;
  final String syncedStatus;
  final double totalAmount;
  final int totalItems;

  OrderItems({
    this.orderId,
    required this.customerId,
    required this.customerName,
    required this.companies,
    required this.orderDate,
    this.syncDate,
    this.syncedStatus = 'No',
    required this.totalAmount,
    required this.totalItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'orderDate': orderDate.toIso8601String(),
      'syncDate': syncDate?.toIso8601String(),
      'synced': syncedStatus,
      'grandTotalProducts': totalItems,
      'grandTotalAmount': totalAmount,
    };
  }

  factory OrderItems.fromMap(Map<String, dynamic> map) {
    return OrderItems(
      orderId: map['orderId'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      companies: [], // Will be populated separately
      orderDate: DateTime.parse(map['orderDate']),
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      syncedStatus: map['synced'],
      totalAmount: map['grandTotalAmount'],
      totalItems: map['grandTotalProducts'],
    );
  }

  /// copyWith method
  OrderItems copyWith({
    int? orderId,
    String? customerId,
    String? customerName,
    List<OrderCompanies>? companies,
    DateTime? orderDate,
    DateTime? syncDate,
    String? syncedStatus,
    double? totalAmount,
    int? totalItems,
  }) {
    return OrderItems(
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      companies: companies ?? this.companies,
      orderDate: orderDate ?? this.orderDate,
      syncDate: syncDate ?? this.syncDate,
      syncedStatus: syncedStatus ?? this.syncedStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class OrderCompanies {
  final int? companyOrderId;
  final int orderId;
  final String companyId;
  final String companyName;

  final List<OrderProducts> products;
  final double companyTotalAmount;
  final int companyTotalItems;

  OrderCompanies({
    this.companyOrderId,
    required this.orderId,
    required this.companyId,
    required this.companyName,
    required this.products,

    required this.companyTotalAmount,
    required this.companyTotalItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'companyOrderId': companyOrderId,
      'orderId': orderId,
      'companyId': companyId,
      'companyName': companyName,
      'totalCompanyProducts': companyTotalItems,
      'totalCompanyAmount': companyTotalAmount,
   
    };
  }

  factory OrderCompanies.fromMap(Map<String, dynamic> map) {
    return OrderCompanies(
      companyOrderId: map['companyOrderId'],
      orderId: map['orderId'],
      companyId: map['companyId'],
      companyName: map['companyName'],
      products: [], // Will be populated separately
      companyTotalAmount: map['totalCompanyAmount'],
      companyTotalItems: map['totalCompanyProducts'],
    
    );
  }

  /// copyWith method
  OrderCompanies copyWith({
    int? companyOrderId,
    int? orderId,
    String? companyId,
    String? companyName,
    String? companyAddress,
    List<OrderProducts>? products,
    double? companyTotalAmount,
    int? companyTotalItems,
  }) {
    return OrderCompanies(
      companyOrderId: companyOrderId ?? this.companyOrderId,
      orderId: orderId ?? this.orderId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,

      products: products ?? this.products,
      companyTotalAmount: companyTotalAmount ?? this.companyTotalAmount,
      companyTotalItems: companyTotalItems ?? this.companyTotalItems,
    );
  }
}

class OrderProducts {
  final int? orderProductId;
  final int? companyOrderId;
  final String productId;
  final String productName;
  final int quantity;
  final int bonus;
  final double discRatio;
  final double price;

  OrderProducts({
    this.orderProductId,
     this.companyOrderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    this.bonus = 0,
    this.discRatio = 0,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderProductId': orderProductId,
      'companyOrderId': companyOrderId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'bonus': bonus,
      'discRatio': discRatio,
      'price': price,
    };
  }

  factory OrderProducts.fromMap(Map<String, dynamic> map) {
    return OrderProducts(
      orderProductId: map['orderProductId'],
      companyOrderId: map['companyOrderId'],
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      bonus: map['bonus'],
      discRatio: map['discRatio'],
      price: map['price'],
    );
  }

  /// copyWith method
  OrderProducts copyWith({
    int? orderProductId,
    int? companyOrderId,
    String? productId,
    String? productName,
    int? quantity,
    int? bonus,
    double? discRatio,
    double? price,
  }) {
    return OrderProducts(
      orderProductId: orderProductId ?? this.orderProductId,
      companyOrderId: companyOrderId ?? this.companyOrderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      bonus: bonus ?? this.bonus,
      discRatio: discRatio ?? this.discRatio,
      price: price ?? this.price,
    );
  }
}

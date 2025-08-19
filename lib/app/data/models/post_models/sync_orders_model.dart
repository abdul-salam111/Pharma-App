class Security {
  final String mobileNo;
  final String password;
  final String customerKey;
  final int tenantId;

  Security({
    required this.mobileNo,
    required this.password,
    required this.customerKey,
    required this.tenantId,
  });

  factory Security.fromJson(Map<String, dynamic> json) {
    return Security(
      mobileNo: json["MobileNo"] ?? "",
      password: json["Password"] ?? "",
      customerKey: json["CustomerKey"] ?? "",
      tenantId: json["TenantID"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "MobileNo": mobileNo,
        "Password": password,
        "CustomerKey": customerKey,
        "TenantID": tenantId,
      };
}

class OrderRow {
  final int orderId;
  final int productId;
  final String tenantProdId;
  final int qty;
  final int bonus;
  final double discRatio;
  final double price;
  final int id;
  final int tenantId;

  OrderRow({
    required this.orderId,
    required this.productId,
    required this.tenantProdId,
    required this.qty,
    required this.bonus,
    required this.discRatio,
    required this.price,
    required this.id,
    required this.tenantId,
  });

  factory OrderRow.fromJson(Map<String, dynamic> json) {
    return OrderRow(
      orderId: json["OrderId"] ?? 0,
      productId: json["ProductId"] ?? 0,
      tenantProdId: json["TenantProdId"] ?? "",
      qty: json["Qty"] ?? 0,
      bonus: json["Bonus"] ?? 0,
      discRatio: (json["DiscRatio"] ?? 0).toDouble(),
      price: (json["Price"] ?? 0).toDouble(),
      id: json["ID"] ?? 0,
      tenantId: json["TenantID"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "ProductId": productId,
        "TenantProdId": tenantProdId,
        "Qty": qty,
        "Bonus": bonus,
        "DiscRatio": discRatio,
        "Price": price,
        "ID": id,
        "TenantID": tenantId,
      };
}

class OrderData {
  final int tenantOrderId;
  final int salesmanOrderId;
  final int deviceOrderId;
  final int customerId;
  final int salesmanId;
  final String orderTime;
  final String syncDate;
  final List<OrderRow> orderRows;
  final int id;
  final int tenantId;

  OrderData({
    required this.tenantOrderId,
    required this.salesmanOrderId,
    required this.deviceOrderId,
    required this.customerId,
    required this.salesmanId,
    required this.orderTime,
    required this.syncDate,
    required this.orderRows,
    required this.id,
    required this.tenantId,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      tenantOrderId: json["TenantOrderId"] ?? 0,
      salesmanOrderId: json["SalesmanOrderId"] ?? 0,
      deviceOrderId: json["DeviceOrderID"] ?? 0,
      customerId: json["CustomerId"] ?? 0,
      salesmanId: json["SalesmanId"] ?? 0,
      orderTime: json["OrderTime"] ?? "",
      syncDate: json["SyncDate"] ?? "",
      orderRows: (json["OrderRows"] as List<dynamic>? ?? [])
          .map((e) => OrderRow.fromJson(e))
          .toList(),
      id: json["ID"] ?? 0,
      tenantId: json["TenantID"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "TenantOrderId": tenantOrderId,
        "SalesmanOrderId": salesmanOrderId,
        "DeviceOrderID": deviceOrderId,
        "CustomerId": customerId,
        "SalesmanId": salesmanId,
        "OrderTime": orderTime,
        "SyncDate": syncDate,
        "OrderRows": orderRows.map((e) => e.toJson()).toList(),
        "ID": id,
        "TenantID": tenantId,
      };
}

class OrdersRequest {
  final Security security;
  final List<OrderData> dataList;

  OrdersRequest({required this.security, required this.dataList});

  factory OrdersRequest.fromJson(Map<String, dynamic> json) {
    return OrdersRequest(
      security: Security.fromJson(json["Security"] ?? {}),
      dataList: (json["DataList"] as List<dynamic>? ?? [])
          .map((e) => OrderData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "Security": security.toJson(),
        "DataList": dataList.map((e) => e.toJson()).toList(),
      };
}

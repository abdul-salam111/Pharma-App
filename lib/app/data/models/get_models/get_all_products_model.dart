class GetAllProductsModel {
  final int? companyId;
  final String? strCompanyId;
  final String? productId;
  final int? groupId;
  final String? productName;
  final String? packing;
  final double? tradePrice;
  final double? saleDiscRatio;
  final int? currentStock;
  final bool? isInActive;
  final int? id;
  final int? tenantId;

  GetAllProductsModel({
    this.companyId,
    this.strCompanyId,
    this.productId,
    this.groupId,
    this.productName,
    this.packing,
    this.tradePrice,
    this.saleDiscRatio,
    this.currentStock,
    this.isInActive,
    this.id,
    this.tenantId,
  });

  factory GetAllProductsModel.fromJson(Map<String, dynamic> json) {
    return GetAllProductsModel(
      companyId: json['CompanyId'] as int?,
      strCompanyId: json['StrCompanyId'] as String?,
      productId: json['ProductId'] as String?,
      groupId: json['GroupId'] as int?,
      productName: json['ProductName'] as String?,
      packing: json['Packing'] as String?,
      tradePrice: (json['TradePrice'] as num?)?.toDouble(),
      saleDiscRatio: (json['SaleDiscRatio'] as num?)?.toDouble(),
      currentStock: json['CurrentStock'] as int?,
      isInActive: json['IsInActive'] as bool?,
      id: json['ID'] as int?,
      tenantId: json['TenantID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CompanyId': companyId,
      'StrCompanyId': strCompanyId,
      'ProductId': productId,
      'GroupId': groupId,
      'ProductName': productName,
      'Packing': packing,
      'TradePrice': tradePrice,
      'SaleDiscRatio': saleDiscRatio,
      'CurrentStock': currentStock,
      'IsInActive': isInActive,
      'ID': id,
      'TenantID': tenantId,
    };
  }

  List<GetAllProductsModel> productsFromJson(List<dynamic> jsonList) =>
    jsonList.map((e) => GetAllProductsModel.fromJson(e)).toList();

}

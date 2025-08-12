// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    final String? userId;
    final String? salesmanId;
    final String? userName;
    final String? customerKey;
    final int? maxDeviceOrderId;
    final String? tenantId;
    final String? result;

    LoginResponseModel({
        this.userId,
        this.salesmanId,
        this.userName,
        this.customerKey,
        this.maxDeviceOrderId,
        this.tenantId,
        this.result,
    });

    LoginResponseModel copyWith({
        String? userId,
        String? salesmanId,
        String? userName,
        String? customerKey,
        int? maxDeviceOrderId,
        String? tenantId,
        String? result,
    }) => 
        LoginResponseModel(
            userId: userId ?? this.userId,
            salesmanId: salesmanId ?? this.salesmanId,
            userName: userName ?? this.userName,
            customerKey: customerKey ?? this.customerKey,
            maxDeviceOrderId: maxDeviceOrderId ?? this.maxDeviceOrderId,
            tenantId: tenantId ?? this.tenantId,
            result: result ?? this.result,
        );

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        userId: json["UserId"],
        salesmanId: json["SalesmanId"],
        userName: json["UserName"],
        customerKey: json["CustomerKey"],
        maxDeviceOrderId: json["MaxDeviceOrderId"],
        tenantId: json["TenantID"],
        result: json["Result"],
    );

    Map<String, dynamic> toJson() => {
        "UserId": userId,
        "SalesmanId": salesmanId,
        "UserName": userName,
        "CustomerKey": customerKey,
        "MaxDeviceOrderId": maxDeviceOrderId,
        "TenantID": tenantId,
        "Result": result,
    };
}

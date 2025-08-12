// To parse this JSON data, do
//
//     final loginUserModel = loginUserModelFromJson(jsonString);

import 'dart:convert';

LoginUserModel loginUserModelFromJson(String str) => LoginUserModel.fromJson(json.decode(str));

String loginUserModelToJson(LoginUserModel data) => json.encode(data.toJson());

class LoginUserModel {
    final int? tenantId;
    final String? password;
    final String customerKey;
    final String mobileNo;

    LoginUserModel({
         this.tenantId,
         this.password,
        required this.customerKey,
        required this.mobileNo,
    });

    LoginUserModel copyWith({
        int? tenantId,
        String? password,
        String? customerKey,
        String? mobileNo,
    }) => 
        LoginUserModel(
            tenantId: tenantId ?? this.tenantId,
            password: password ?? this.password,
            customerKey: customerKey ?? this.customerKey,
            mobileNo: mobileNo ?? this.mobileNo,
        );

    factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
        tenantId: json["TenantId"],
        password: json["Password"],
        customerKey: json["CustomerKey"],
        mobileNo: json["MobileNo"],
    );

    Map<String, dynamic> toJson() => {
        "TenantId": tenantId,
        "Password": password,
        "CustomerKey": customerKey,
        "MobileNo": mobileNo,
    };
}

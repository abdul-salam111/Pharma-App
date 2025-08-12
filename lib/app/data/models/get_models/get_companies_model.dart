// To parse this JSON data, do
//
//     final getCompaniesModel = getCompaniesModelFromJson(jsonString);

import 'dart:convert';

List<GetCompaniesModel> getCompaniesModelFromJson(String str) => List<GetCompaniesModel>.from(json.decode(str).map((x) => GetCompaniesModel.fromJson(x)));

String getCompaniesModelToJson(List<GetCompaniesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCompaniesModel {
    final String? companyId;
    final String? companyName;
    final dynamic asmTitle;
    final dynamic distributionCode;
    final int? id;
    final int? tenantId;

    GetCompaniesModel({
        this.companyId,
        this.companyName,
        this.asmTitle,
        this.distributionCode,
        this.id,
        this.tenantId,
    });

    GetCompaniesModel copyWith({
        String? companyId,
        String? companyName,
        dynamic asmTitle,
        dynamic distributionCode,
        int? id,
        int? tenantId,
    }) => 
        GetCompaniesModel(
            companyId: companyId ?? this.companyId,
            companyName: companyName ?? this.companyName,
            asmTitle: asmTitle ?? this.asmTitle,
            distributionCode: distributionCode ?? this.distributionCode,
            id: id ?? this.id,
            tenantId: tenantId ?? this.tenantId,
        );

    factory GetCompaniesModel.fromJson(Map<String, dynamic> json) => GetCompaniesModel(
        companyId: json["CompanyId"],
        companyName: json["CompanyName"],
        asmTitle: json["ASMTitle"],
        distributionCode: json["DistributionCode"],
        id: json["ID"],
        tenantId: json["TenantID"],
    );

    Map<String, dynamic> toJson() => {
        "CompanyId": companyId,
        "CompanyName": companyName,
        "ASMTitle": asmTitle,
        "DistributionCode": distributionCode,
        "ID": id,
        "TenantID": tenantId,
    };
} 

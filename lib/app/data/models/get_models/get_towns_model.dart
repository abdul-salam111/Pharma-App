// To parse this JSON data, do
//
//     final getTownsModel = getTownsModelFromJson(jsonString);

import 'dart:convert';

List<GetTownsModel> getTownsModelFromJson(String str) => List<GetTownsModel>.from(json.decode(str).map((x) => GetTownsModel.fromJson(x)));

String getTownsModelToJson(List<GetTownsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTownsModel {
    final int? actualSectorId;
    final int? actualTownId;
    final String? townName;
    final int? id;
    final int? tenantId;

    GetTownsModel({
        this.actualSectorId,
        this.actualTownId,
        this.townName,
        this.id,
        this.tenantId,
    });

    GetTownsModel copyWith({
        int? actualSectorId,
        int? actualTownId,
        String? townName,
        int? id,
        int? tenantId,
    }) => 
        GetTownsModel(
            actualSectorId: actualSectorId ?? this.actualSectorId,
            actualTownId: actualTownId ?? this.actualTownId,
            townName: townName ?? this.townName,
            id: id ?? this.id,
            tenantId: tenantId ?? this.tenantId,
        );

    factory GetTownsModel.fromJson(Map<String, dynamic> json) => GetTownsModel(
        actualSectorId: json["ActualSectorId"],
        actualTownId: json["ActualTownId"],
        townName: json["TownName"],
        id: json["ID"],
        tenantId: json["TenantID"],
    );

    Map<String, dynamic> toJson() => {
        "ActualSectorId": actualSectorId,
        "ActualTownId": actualTownId,
        "TownName": townName,
        "ID": id,
        "TenantID": tenantId,
    };
}

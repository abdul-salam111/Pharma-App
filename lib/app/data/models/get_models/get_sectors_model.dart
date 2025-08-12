// To parse this JSON data, do
//
//     final getSectorsModel = getSectorsModelFromJson(jsonString);

import 'dart:convert';

List<GetSectorsModel> getSectorsModelFromJson(String str) => List<GetSectorsModel>.from(json.decode(str).map((x) => GetSectorsModel.fromJson(x)));

String getSectorsModelToJson(List<GetSectorsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSectorsModel {
    final int? actualSectorId;
    final String? sectorName;
    final int? id;
    final int? tenantId;

    GetSectorsModel({
        this.actualSectorId,
        this.sectorName,
        this.id,
        this.tenantId,
    });

    GetSectorsModel copyWith({
        int? actualSectorId,
        String? sectorName,
        int? id,
        int? tenantId,
    }) => 
        GetSectorsModel(
            actualSectorId: actualSectorId ?? this.actualSectorId,
            sectorName: sectorName ?? this.sectorName,
            id: id ?? this.id,
            tenantId: tenantId ?? this.tenantId,
        );

    factory GetSectorsModel.fromJson(Map<String, dynamic> json) => GetSectorsModel(
        actualSectorId: json["ActualSectorId"],
        sectorName: json["SectorName"],
        id: json["ID"],
        tenantId: json["TenantID"],
    );

    Map<String, dynamic> toJson() => {
        "ActualSectorId": actualSectorId,
        "SectorName": sectorName,
        "ID": id,
        "TenantID": tenantId,
    };
}

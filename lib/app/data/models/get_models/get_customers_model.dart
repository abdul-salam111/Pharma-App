class GetCustomersModel {
  final String? customerId;
  final int? actualTownId;
  final String? customerName;
  final String? address;
  final String? city;
  final String? contactPerson;
  final String? phone1;
  final String? phone2;
  final String? phone3;
  final String? gsm;
  final String? email;
  final String? ntn;
  final String? stn;
  final String? customerType;
  final String? cnic;
  final int? id;
  final int? tenantId;

  GetCustomersModel({
    this.customerId,
    this.actualTownId,
    this.customerName,
    this.address,
    this.city,
    this.contactPerson,
    this.phone1,
    this.phone2,
    this.phone3,
    this.gsm,
    this.email,
    this.ntn,
    this.stn,
    this.customerType,
    this.cnic,
    this.id,
    this.tenantId,
  });

  factory GetCustomersModel.fromJson(Map<String, dynamic> json) {
    return GetCustomersModel(
      customerId: json['CustomerId'] as String?,
      actualTownId: json['ActualTownId'] as int?,
      customerName: json['CustomerName'] as String?,
      address: json['Address'] as String?,
      city: json['City'] as String?,
      contactPerson: json['ContactPerson'] as String?,
      phone1: json['Phone1'] as String?,
      phone2: json['Phone2'] as String?,
      phone3: json['Phone3'] as String?,
      gsm: json['GSM'] as String?,
      email: json['Email'] as String?,
      ntn: json['NTN'] as String?,
      stn: json['STN'] as String?,
      customerType: json['CustomerType'] as String?,
      cnic: json['CNIC'] as String?,
      id: json['ID'] as int?,
      tenantId: json['TenantID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerId': customerId,
      'ActualTownId': actualTownId,
      'CustomerName': customerName,
      'Address': address,
      'City': city,
      'ContactPerson': contactPerson,
      'Phone1': phone1,
      'Phone2': phone2,
      'Phone3': phone3,
      'GSM': gsm,
      'Email': email,
      'NTN': ntn,
      'STN': stn,
      'CustomerType': customerType,
      'CNIC': cnic,
      'ID': id,
      'TenantID': tenantId,
    };
  }

  static List<GetCustomersModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GetCustomersModel.fromJson(json)).toList();
  }
}

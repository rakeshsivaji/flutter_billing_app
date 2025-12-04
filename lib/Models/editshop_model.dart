// To parse this JSON data, do
//
//     final editShopModel = editShopModelFromJson(jsonString);

import 'dart:convert';

EditShopModel editShopModelFromJson(String str) =>
    EditShopModel.fromJson(json.decode(str));

String editShopModelToJson(EditShopModel data) => json.encode(data.toJson());

class EditShopModel {
  int status;
  Data data;

  EditShopModel({
    required this.status,
    required this.data,
  });

  factory EditShopModel.fromJson(Map<String, dynamic> json) => EditShopModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  int storeId;
  String path;
  String name;
  String ownerName;
  String address;
  String phone;
  String billType;

  Data({
    required this.storeId,
    required this.path,
    required this.name,
    required this.ownerName,
    required this.address,
    required this.phone,
    required this.billType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeId: json['store_id'],
        path: json['path'],
        name: json['name'],
        ownerName: json['owner_name'],
        address: json['address'],
        phone: json['phone'],
        billType: json['bill_type'],
      );

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'path': path,
        'name': name,
        'owner_name': ownerName,
        'address': address,
        'phone': phone,
        'bill_type': billType,
      };
}

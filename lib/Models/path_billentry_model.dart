// To parse this JSON data, do
//
//     final PathBillEntryModel = PathBillEntryModelFromJson(jsonString);

import 'dart:convert';

PathBillEntryModel PathBillEntryModelFromJson(String str) =>
    PathBillEntryModel.fromJson(json.decode(str));

String PathBillEntryModelToJson(PathBillEntryModel data) =>
    json.encode(data.toJson());

class PathBillEntryModel {
  int status;
  List<BillPathEntryData> data;

  PathBillEntryModel({
    required this.status,
    required this.data,
  });

  factory PathBillEntryModel.fromJson(Map<String, dynamic> json) =>
      PathBillEntryModel(
        status: json['status'],
        data: List<BillPathEntryData>.from(json['data'].map((x) => BillPathEntryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BillPathEntryData {
  int orderId;
  String storeName;
  String pathName;
  String storeAddress;
  String ownerName;
  String ownerPhone;
  String status;

  BillPathEntryData({
    required this.orderId,
    required this.storeName,
    required this.pathName,
    required this.storeAddress,
    required this.ownerName,
    required this.ownerPhone,
    required this.status,
  });

  factory BillPathEntryData.fromJson(Map<String, dynamic> json) => BillPathEntryData(
        orderId: json['order_id'],
        storeName: json['store_name'],
        pathName: json['path_name'],
        storeAddress: json['store_address'],
        ownerName: json['owner_name'],
        ownerPhone: json['owner_phone'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'store_name': storeName,
        'path_name': pathName,
        'store_address': storeAddress,
        'owner_name': ownerName,
        'owner_phone': ownerPhone,
        'status': status,
      };
}

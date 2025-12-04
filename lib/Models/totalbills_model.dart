// To parse this JSON data, do
//
//     final totalBillsModel = totalBillsModelFromJson(jsonString);

import 'dart:convert';

TotalBillsModel totalBillsModelFromJson(String str) =>
    TotalBillsModel.fromJson(json.decode(str));

String totalBillsModelToJson(TotalBillsModel data) =>
    json.encode(data.toJson());

class TotalBillsModel {
  int status;
  List<Datum> data;

  TotalBillsModel({
    required this.status,
    required this.data,
  });

  factory TotalBillsModel.fromJson(Map<String, dynamic> json) =>
      TotalBillsModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int billId;
  String orderNo;
  String date;
  String path;
  String storeName;
  String storeAddress;

  Datum({
    required this.billId,
    required this.orderNo,
    required this.date,
    required this.path,
    required this.storeName,
    required this.storeAddress,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        billId: json['bill_id'],
        orderNo: json['order_no'],
        date: json['date'],
        path: json['path'],
        storeName: json['store_name'],
        storeAddress: json['store_address'],
      );

  Map<String, dynamic> toJson() => {
        'bill_id': billId,
        'order_no': orderNo,
        'date': date,
        'path': path,
        'store_name': storeName,
        'store_address': storeAddress,
      };
}

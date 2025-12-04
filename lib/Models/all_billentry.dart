// To parse this JSON data, do
//
//     final allBillEntryModel = allBillEntryModelFromJson(jsonString);

import 'dart:convert';

AllBillEntryModel allBillEntryModelFromJson(String str) => AllBillEntryModel.fromJson(json.decode(str));

String allBillEntryModelToJson(AllBillEntryModel data) => json.encode(data.toJson());

class AllBillEntryModel {
    int status;
    List<Datum> data;

    AllBillEntryModel({
        required this.status,
        required this.data,
    });

    factory AllBillEntryModel.fromJson(Map<String, dynamic> json) => AllBillEntryModel(
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

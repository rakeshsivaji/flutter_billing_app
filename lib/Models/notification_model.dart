// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    int status;
    List<Datum> data;

    NotificationModel({
        required this.status,
        required this.data,
    });

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int orderId;
    String storeName;
    String pathName;
    String storeAddress;
    String ownerName;
    String ownerPhone;
    String status;

    Datum({
        required this.orderId,
        required this.storeName,
        required this.pathName,
        required this.storeAddress,
        required this.ownerName,
        required this.ownerPhone,
        required this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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

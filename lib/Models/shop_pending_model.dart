// To parse this JSON data, do
//
//     final shopPendingModel = shopPendingModelFromJson(jsonString);

import 'dart:convert';

ShopPendingModel shopPendingModelFromJson(String str) => ShopPendingModel.fromJson(json.decode(str));

String shopPendingModelToJson(ShopPendingModel data) => json.encode(data.toJson());

class ShopPendingModel {
    int status;
    List<ShopPendingDataModel> data;

    ShopPendingModel({
        required this.status,
        required this.data,
    });

    factory ShopPendingModel.fromJson(Map<String, dynamic> json) => ShopPendingModel(
        status: json['status'],
        data: List<ShopPendingDataModel>.from(json['data'].map((x) => ShopPendingDataModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ShopPendingDataModel {
    String storeName;
    String storeAddress;
    String pathName;
    String date;
    List<PendingQuantity> pendingQuantity;

    ShopPendingDataModel({
        required this.storeName,
        required this.storeAddress,
        required this.pathName,
        required this.date,
        required this.pendingQuantity,
    });

    factory ShopPendingDataModel.fromJson(Map<String, dynamic> json) => ShopPendingDataModel(
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        pathName: json['path_name'],
        date: json['date'],
        pendingQuantity: List<PendingQuantity>.from(json['pending_quantity'].map((x) => PendingQuantity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'store_name': storeName,
        'store_address': storeAddress,
        'path_name': pathName,
        'date': date,
        'pending_quantity': List<dynamic>.from(pendingQuantity.map((x) => x.toJson())),
    };
}

class PendingQuantity {
    String name;
    String quantity;

    PendingQuantity({
        required this.name,
        required this.quantity,
    });

    factory PendingQuantity.fromJson(Map<String, dynamic> json) => PendingQuantity(
        name: json['name'],
        quantity: json['quantity'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
    };
}

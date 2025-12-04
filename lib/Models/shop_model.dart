// To parse this JSON data, do
//
//     final shopModel = shopModelFromJson(jsonString);

import 'dart:convert';

ShopModel shopModelFromJson(String str) => ShopModel.fromJson(json.decode(str));

String shopModelToJson(ShopModel data) => json.encode(data.toJson());

class ShopModel {
    int status;
    List<ShopData> data;

    ShopModel({
        required this.status,
        required this.data,
    });

    factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        status: json['status'],
        data: List<ShopData>.from(json['data'].map((x) => ShopData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ShopData {
    int storeId;
    String? path;
    String name;
    String ownerName;
    String address;
    String phone;

    ShopData({
        required this.storeId,
        this.path,
        required this.name,
        required this.ownerName,
        required this.address,
        required this.phone,
    });

    factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
        storeId: json['store_id'],
        path: json['path'],
        name: json['name'],
        ownerName: json['owner_name'],
        address: json['address'],
        phone: json['phone'],
    );

    Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'path': path,
        'name': name,
        'owner_name': ownerName,
        'address': address,
        'phone': phone,
    };
}

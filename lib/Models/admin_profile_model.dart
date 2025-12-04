// To parse this JSON data, do
//
//     final adminProfileModel = adminProfileModelFromJson(jsonString);

import 'dart:convert';

AdminProfileModel adminProfileModelFromJson(String str) => AdminProfileModel.fromJson(json.decode(str));

String adminProfileModelToJson(AdminProfileModel data) => json.encode(data.toJson());

class AdminProfileModel {
    int status;
    Data data;

    AdminProfileModel({
        required this.status,
        required this.data,
    });

    factory AdminProfileModel.fromJson(Map<String, dynamic> json) => AdminProfileModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    int userId;
    String name;
    String phone;
    String image;
    String stockCreate;
    String collectionPath;
    String? collectionPathName;

    Data({
        required this.userId,
        required this.name,
        required this.phone,
        required this.image,
        required this.stockCreate,
        required this.collectionPath,
        this.collectionPathName,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json['user_id'],
        name: json['name'],
        phone: json['phone'],
        image: json['image'],
        stockCreate: json['stock_create'],
        collectionPath: json['collection_path'],
        collectionPathName: json['collection_path_name'],
    );

    Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'phone': phone,
        'image': image,
        'stock_create': stockCreate,
        'collection_path': collectionPath,
        'collection_path_name': collectionPathName,
    };
}

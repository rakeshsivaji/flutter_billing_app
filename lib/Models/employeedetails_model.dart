// To parse this JSON data, do
//
//     final employeeDetailsModel = employeeDetailsModelFromJson(jsonString);

import 'dart:convert';

EmployeeDetailsModel employeeDetailsModelFromJson(String str) => EmployeeDetailsModel.fromJson(json.decode(str));

String employeeDetailsModelToJson(EmployeeDetailsModel data) => json.encode(data.toJson());

class EmployeeDetailsModel {
    int status;
    Data data;

    EmployeeDetailsModel({
        required this.status,
        required this.data,
    });

    factory EmployeeDetailsModel.fromJson(Map<String, dynamic> json) => EmployeeDetailsModel(
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
    String email;
    String aadharNumber;
    String address;
    String stockCreate;
    String image;
    String collectionPathId;

    Data({
        required this.userId,
        required this.name,
        required this.phone,
        required this.email,
        required this.aadharNumber,
        required this.address,
        required this.stockCreate,
        required this.image,
        required this.collectionPathId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json['user_id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email']??'',
        aadharNumber: json['aadhar_no']??'',
        address: json['address']??'',
        stockCreate: json['stock_create'],
        image: json['image'],
        collectionPathId: json['collection_path_id'],
    );

    Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'phone': phone,
        'email': email,
        'aadhar_no': aadharNumber,
        'address': address,
        'stock_create': stockCreate,
        'image': image,
        'collection_path_id': collectionPathId,
    };
}

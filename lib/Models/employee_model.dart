// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  int status;
  List<Datum> data;

  EmployeeModel({
    required this.status,
    required this.data,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int userId;
  String name;
  String phone;
  String email;
  String address;
  String stockCreate;
  String image;
  String isActive;

  Datum({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.stockCreate,
    required this.image,
    required this.isActive,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json['user_id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'] ?? '',
        address: json['address'] ?? '',
        stockCreate: json['stock_create'] ?? '',
        image: json['image'],
        isActive: json['is_active'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'stock_create': stockCreate,
        'image': image,
        'is_active': isActive,
      };
}

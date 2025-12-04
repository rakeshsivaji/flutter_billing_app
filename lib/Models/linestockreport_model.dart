// To parse this JSON data, do
//
//     final linestockreportModel = linestockreportModelFromJson(jsonString);

import 'dart:convert';

LinestockreportModel linestockreportModelFromJson(String str) =>
    LinestockreportModel.fromJson(json.decode(str));

String linestockreportModelToJson(LinestockreportModel data) =>
    json.encode(data.toJson());

class LinestockreportModel {
  int status;
  List<Datum> data;
  String? downloadUrl;

  LinestockreportModel({
    required this.status,
    required this.data,
    this.downloadUrl
  });

  factory LinestockreportModel.fromJson(Map<String, dynamic> json) =>
      LinestockreportModel(
        status: json['status'],
        downloadUrl: json['download_url'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'download_url': downloadUrl,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int totalStock;
  int pendingStock;
  dynamic totalAmount;
  dynamic pendingAmount;
  dynamic collectedAmount;
  List<Product> products;
  String date;
  String name;

  Datum({
    required this.totalStock,
    required this.pendingStock,
    required this.totalAmount,
    required this.pendingAmount,
    this.collectedAmount,
    required this.products,
    required this.date,
    required this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalStock: json['total_stock'],
        pendingStock: json['pending_stock'],
        totalAmount: json['total_amount'],
        pendingAmount: json['pending_amount'],
        collectedAmount: json['collected_amount'],
        products: List<Product>.from(
            json['products'].map((x) => Product.fromJson(x))),
        date: json['date'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'total_stock': totalStock,
        'pending_stock': pendingStock,
        'total_amount': totalAmount,
        'pending_amount': pendingAmount,
        'collected_amount': collectedAmount,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
        'date': date,
        'name': name,
      };
}

class Product {
  String name;
  dynamic totalQuantity;
  int pendingQuantity;

  Product({
    required this.name,
    required this.totalQuantity,
    required this.pendingQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json['name'],
        totalQuantity: json['total_quantity'],
        pendingQuantity: json['pending_quantity'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'total_quantity': totalQuantity,
        'pending_quantity': pendingQuantity,
      };
}

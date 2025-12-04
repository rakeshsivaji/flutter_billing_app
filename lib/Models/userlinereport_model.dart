// To parse this JSON data, do
//
//     final userlinereportModel = userlinereportModelFromJson(jsonString);

import 'dart:convert';

UserlinereportModel userlinereportModelFromJson(String str) =>
    UserlinereportModel.fromJson(json.decode(str));

String userlinereportModelToJson(UserlinereportModel data) =>
    json.encode(data.toJson());

class UserlinereportModel {
  int status;
  Data data;

  UserlinereportModel({
    required this.status,
    required this.data,
  });

  factory UserlinereportModel.fromJson(Map<String, dynamic> json) =>
      UserlinereportModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  Delivery delivery;
  Pending pending;

  Data({
    required this.delivery,
    required this.pending,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        delivery: Delivery.fromJson(json['delivery']),
        pending: Pending.fromJson(json['pending']),
      );

  Map<String, dynamic> toJson() => {
        'delivery': delivery.toJson(),
        'pending': pending.toJson(),
      };
}

class Delivery {
  String lineId;
  String date;
  String name;
  int totalStock;
  int pendingStock;
  dynamic totalAmount;
  dynamic pendingAmount;
  dynamic collectionAmount;
  List<Product> products;

  Delivery({
    required this.lineId,
    required this.date,
    required this.name,
    required this.totalStock,
    required this.pendingStock,
    required this.totalAmount,
    required this.pendingAmount,
    required this.products,
    this.collectionAmount,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    lineId: json['line_id'],
    date: json['date'],
    name: json['name'],
    totalStock: json['total_stock'],
    pendingStock: json['pending_stock'],
    totalAmount: json['total_amount'],
    pendingAmount: json['pending_amount'],
    collectionAmount: json['collect_amount'],
    products: json['products'] != null
        ? List<Product>.from(
        json['products'].map((x) => Product.fromJson(x)))
        : [], // Handle null case by providing an empty list
  );

  Map<String, dynamic> toJson() => {
    'line_id': lineId,
    'date': date,
    'name': name,
    'total_stock': totalStock,
    'pending_stock': pendingStock,
    'total_amount': totalAmount,
    'pending_amount': pendingAmount,
    'collect_amount': collectionAmount,
    'products': List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  String name;
  String totalQuantity;
  String pendingQuantity;

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

class Pending {
  int totalPending;
  List<TotalProductPending> totalProductPending;

  Pending({
    required this.totalPending,
    required this.totalProductPending,
  });

  factory Pending.fromJson(Map<String, dynamic> json) => Pending(
        totalPending: json['total_pending'],
        totalProductPending: List<TotalProductPending>.from(
            json['total_product_pending']
                .map((x) => TotalProductPending.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'total_pending': totalPending,
        'total_product_pending':
            List<dynamic>.from(totalProductPending.map((x) => x.toJson())),
      };
}

class TotalProductPending {
  String productName;
  dynamic productAmount;
  dynamic productTotalAmount;
  int totalPendingQuantity;

  TotalProductPending({
    required this.productName,
    required this.productAmount,
    required this.productTotalAmount,
    required this.totalPendingQuantity,
  });

  factory TotalProductPending.fromJson(Map<String, dynamic> json) =>
      TotalProductPending(
        productName: json['product_name'],
        productAmount: json['product_amount'],
        productTotalAmount: json['product_total_amount'],
        totalPendingQuantity: json['total_pending_quantity'],
      );

  Map<String, dynamic> toJson() => {
        'product_name': productName,
        'product_amount': productAmount,
        'product_total_amount': productTotalAmount,
        'total_pending_quantity': totalPendingQuantity,
      };
}

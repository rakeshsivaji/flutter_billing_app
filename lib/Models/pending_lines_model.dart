// To parse this JSON data, do
//
//     final pendingLinesModel = pendingLinesModelFromJson(jsonString);

import 'dart:convert';

PendingLinesModel pendingLinesModelFromJson(String str) => PendingLinesModel.fromJson(json.decode(str));

String pendingLinesModelToJson(PendingLinesModel data) => json.encode(data.toJson());

class PendingLinesModel {
    int status;
    List<Datum> data;

    PendingLinesModel({
        required this.status,
        required this.data,
    });

    factory PendingLinesModel.fromJson(Map<String, dynamic> json) => PendingLinesModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String lineId;
    String lineName;
    int totalPendingQuantity;
    dynamic totalPendingAmount;
    List<Product> products;

    Datum({
        required this.lineId,
        required this.lineName,
        required this.totalPendingQuantity,
        required this.totalPendingAmount,
        required this.products,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lineId: json['line_id'],
        lineName: json['line_name'],
        totalPendingQuantity: json['total_pending_quantity'],
        totalPendingAmount: json['total_pending_amount'],
        products: List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'line_id': lineId,
        'line_name': lineName,
        'total_pending_quantity': totalPendingQuantity,
        'total_pending_amount': totalPendingAmount,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    String productId;
    String productName;
    int pendingQuantity;
    String amount;
    dynamic totalAmount;

    Product({
        required this.productId,
        required this.productName,
        required this.pendingQuantity,
        required this.amount,
        required this.totalAmount,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['product_id'],
        productName: json['product_name'],
        pendingQuantity: json['pending_quantity'],
        amount: json['amount'],
        totalAmount: json['total_amount'],
    );

    Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'pending_quantity': pendingQuantity,
        'amount': amount,
        'total_amount': totalAmount,
    };
}

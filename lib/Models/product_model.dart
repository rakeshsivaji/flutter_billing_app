// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    int status;
    List<Datum> data;

    ProductModel({
        required this.status,
        required this.data,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int productId;
    String name;
    String amount;
    String image;

    Datum({
        required this.productId,
        required this.name,
        required this.amount,
        required this.image,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json['product_id'],
        name: json['name'],
        amount: json['amount'],
        image: json['image'],
    );

    Map<String, dynamic> toJson() => {
        'product_id': productId,
        'name': name,
        'amount': amount,
        'image': image,
    };
}

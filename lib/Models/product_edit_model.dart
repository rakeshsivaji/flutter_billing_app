// To parse this JSON data, do
//
//     final productEditModel = productEditModelFromJson(jsonString);

import 'dart:convert';

ProductEditModel productEditModelFromJson(String str) => ProductEditModel.fromJson(json.decode(str));

String productEditModelToJson(ProductEditModel data) => json.encode(data.toJson());

class ProductEditModel {
    int status;
    Data data;

    ProductEditModel({
        required this.status,
        required this.data,
    });

    factory ProductEditModel.fromJson(Map<String, dynamic> json) => ProductEditModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    int productId;
    String categoryId;
    String name;
    String amount;
    String image;
    String status;

    Data({
        required this.productId,
        required this.categoryId,
        required this.name,
        required this.amount,
        required this.image,
        required this.status,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        productId: json['product_id'],
        categoryId: json['category_id'],
        name: json['name'],
        amount: json['amount'],
        image: json['image'],
        status: json['status'],
    );

    Map<String, dynamic> toJson() => {
        'product_id': productId,
        'category_id': categoryId,
        'name': name,
        'amount': amount,
        'image': image,
        'status': status,
    };
}

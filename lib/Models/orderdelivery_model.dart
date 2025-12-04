// To parse this JSON data, do
//
//     final orderDeliveryModel = orderDeliveryModelFromJson(jsonString);

import 'dart:convert';

OrderDeliveryModel orderDeliveryModelFromJson(String str) => OrderDeliveryModel.fromJson(json.decode(str));

String orderDeliveryModelToJson(OrderDeliveryModel data) => json.encode(data.toJson());

class OrderDeliveryModel {
    int status;
    Data data;

    OrderDeliveryModel({
        required this.status,
        required this.data,
    });

    factory OrderDeliveryModel.fromJson(Map<String, dynamic> json) => OrderDeliveryModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    List<Product> product;
    List<Category> category;

    Data({
        required this.product,
        required this.category,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        product: List<Product>.from(json['product'].map((x) => Product.fromJson(x))),
        category: List<Category>.from(json['category'].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'product': List<dynamic>.from(product.map((x) => x.toJson())),
        'category': List<dynamic>.from(category.map((x) => x.toJson())),
    };
}

class Category {
    int categoryId;
    String name;

    Category({
        required this.categoryId,
        required this.name,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json['category_id'],
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
    };
}

class Product {
    int productId;
    String name;
    String image;
    String amount;

    Product({
        required this.productId,
        required this.name,
        required this.image,
        required this.amount,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['product_id'],
        name: json['name'],
        image: json['image'],
        amount: json['amount'],
    );

    Map<String, dynamic> toJson() => {
        'product_id': productId,
        'name': name,
        'image': image,
        'amount': amount,
    };
}

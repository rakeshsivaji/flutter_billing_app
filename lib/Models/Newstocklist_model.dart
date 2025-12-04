// To parse this JSON data, do
//
//     final newStockListModel = newStockListModelFromJson(jsonString);

import 'dart:convert';

NewStockListModel newStockListModelFromJson(String str) => NewStockListModel.fromJson(json.decode(str));

String newStockListModelToJson(NewStockListModel data) => json.encode(data.toJson());

class NewStockListModel {
    int status;
    List<Datum> data;

    NewStockListModel({
        required this.status,
        required this.data,
    });

    factory NewStockListModel.fromJson(Map<String, dynamic> json) => NewStockListModel(
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
    dynamic price;
    int quantity;
    String image;
    dynamic amount;

    Datum({
        required this.productId,
        required this.name,
        required this.price,
        required this.quantity,
        required this.image,
        required this.amount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json['product_id'],
        name: json['name'],
        price: json['price'],
        quantity: json['quantity'],
        image: json['image'],
        amount: json['amount'],
    );

    Map<String, dynamic> toJson() => {
        'product_id': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
        'amount': amount,
    };
}

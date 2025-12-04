// To parse this JSON data, do
//
//     final stockHistoryModel = stockHistoryModelFromJson(jsonString);

import 'dart:convert';

StockHistoryModel stockHistoryModelFromJson(String str) => StockHistoryModel.fromJson(json.decode(str));

String stockHistoryModelToJson(StockHistoryModel data) => json.encode(data.toJson());

class StockHistoryModel {
    int status;
    List<Datum> data;

    StockHistoryModel({
        required this.status,
        required this.data,
    });

    factory StockHistoryModel.fromJson(Map<String, dynamic> json) => StockHistoryModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String date;
    String amount;
    List<StockItem> stockItem;

    Datum({
        required this.date,
        required this.amount,
        required this.stockItem,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json['date'],
        amount: json['amount'],
        stockItem: List<StockItem>.from(json['stock_item'].map((x) => StockItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'date': date,
        'amount': amount,
        'stock_item': List<dynamic>.from(stockItem.map((x) => x.toJson())),
    };
}

class StockItem {
    String name;
    String price;
    String quantity;
    String image;
    String amount;

    StockItem({
        required this.name,
        required this.price,
        required this.quantity,
        required this.image,
        required this.amount,
    });

    factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        name: json['name'],
        price: json['price'],
        quantity: json['quantity'],
        image: json['image'],
        amount: json['amount'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
        'amount': amount,
    };
}

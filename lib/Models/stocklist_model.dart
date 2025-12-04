// To parse this JSON data, do
//
//     final stockListModel = stockListModelFromJson(jsonString);

import 'dart:convert';

StockListModel stockListModelFromJson(String str) =>
    StockListModel.fromJson(json.decode(str));

String stockListModelToJson(StockListModel data) => json.encode(data.toJson());

class StockListModel {
  int status;
  Data data;

  StockListModel({
    required this.status,
    required this.data,
  });

  factory StockListModel.fromJson(Map<String, dynamic> json) => StockListModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  int? id;
  String date;
  dynamic amount;
  List<StockItem> stockItem;
  bool? isEdit;
  bool? isPlusShow;

  Data({
    this.id,
    required this.date,
    required this.amount,
    required this.stockItem,
    this.isEdit,
    this.isPlusShow,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        date: json['date'] == null ? '' : json['date'],
        amount: json['amount'],
        isEdit: json['is_edit_show'],
        isPlusShow: json['is_plus_show'],
        stockItem: List<StockItem>.from(
            json['stock_item'].map((x) => StockItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'amount': amount,
        'is_edit_show': isEdit,
        'is_plus_show': isPlusShow,
        'stock_item': List<dynamic>.from(stockItem.map((x) => x.toJson())),
      };
}

class StockItem {
  String? productId;
  String name;
  String price;
  String quantity;
  String image;
  String amount;

  StockItem({
    this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.amount,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
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

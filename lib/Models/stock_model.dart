// To parse this JSON data, do
//
//     final stockModel = stockModelFromJson(jsonString);

import 'dart:convert';

StockModel stockModelFromJson(String str) => StockModel.fromJson(json.decode(str));

String stockModelToJson(StockModel data) => json.encode(data.toJson());

class StockModel {
    int status;
    Data data;

    StockModel({
        required this.status,
        required this.data,
    });

    factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    StockItem stockItem;

    Data({
        required this.stockItem,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        stockItem: StockItem.fromJson(json['stock_item']),
    );

    Map<String, dynamic> toJson() => {
        'stock_item': stockItem.toJson(),
    };
}

class StockItem {
    List<FinalDatum> finalData;
    dynamic total;

    StockItem({
        required this.finalData,
        required this.total,
    });

    factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        finalData: List<FinalDatum>.from(json['finalData'].map((x) => FinalDatum.fromJson(x))),
        total: json['total'],
    );

    Map<String, dynamic> toJson() => {
        'finalData': List<dynamic>.from(finalData.map((x) => x.toJson())),
        'total': total,
    };
}

class FinalDatum {
    int orderListItemId;
    String productId;
    String name;
    String price;
    String image;
    String quantity;
    dynamic totalPrice;

    FinalDatum({
        required this.orderListItemId,
        required this.productId,
        required this.name,
        required this.price,
        required this.image,
        required this.quantity,
        required this.totalPrice,
    });

    factory FinalDatum.fromJson(Map<String, dynamic> json) => FinalDatum(
        orderListItemId: json['order_list_item_id'],
        productId: json['product_id'],
        name: json['name'],
        price: json['price'],
        image: json['image'],
        quantity: json['quantity'],
        totalPrice: json['total_price'],
    );

    Map<String, dynamic> toJson() => {
        'order_list_item_id': orderListItemId,
        'product_id': productId,
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
        'total_price': totalPrice,
    };
}

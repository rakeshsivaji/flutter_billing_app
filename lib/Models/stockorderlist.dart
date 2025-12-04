// To parse this JSON data, do
//
//     final stockOrderListModel = stockOrderListModelFromJson(jsonString);

import 'dart:convert';

StockOrderListModel stockOrderListModelFromJson(String str) => StockOrderListModel.fromJson(json.decode(str));

String stockOrderListModelToJson(StockOrderListModel data) => json.encode(data.toJson());

class StockOrderListModel {
    int status;
    Data data;

    StockOrderListModel({
        required this.status,
        required this.data,
    });

    factory StockOrderListModel.fromJson(Map<String, dynamic> json) => StockOrderListModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    OrderListItem orderListItem;

    Data({
        required this.orderListItem,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderListItem: OrderListItem.fromJson(json['order_list_item']),
    );

    Map<String, dynamic> toJson() => {
        'order_list_item': orderListItem.toJson(),
    };
}

class OrderListItem {
    List<FinalDatum> finalData;
    int total;

    OrderListItem({
        required this.finalData,
        required this.total,
    });

    factory OrderListItem.fromJson(Map<String, dynamic> json) => OrderListItem(
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
    int totalPrice;

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

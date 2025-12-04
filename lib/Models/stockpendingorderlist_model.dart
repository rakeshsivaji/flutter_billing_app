// To parse this JSON data, do
//
//     final stockPendingOrderListModel = stockPendingOrderListModelFromJson(jsonString);

import 'dart:convert';

StockPendingOrderListModel stockPendingOrderListModelFromJson(String str) => StockPendingOrderListModel.fromJson(json.decode(str));

String stockPendingOrderListModelToJson(StockPendingOrderListModel data) => json.encode(data.toJson());

class StockPendingOrderListModel {
    int status;
    Data data;

    StockPendingOrderListModel({
        required this.status,
        required this.data,
    });

    factory StockPendingOrderListModel.fromJson(Map<String, dynamic> json) => StockPendingOrderListModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    PendingItem pendingItem;

    Data({
        required this.pendingItem,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        pendingItem: PendingItem.fromJson(json['pending_item']),
    );

    Map<String, dynamic> toJson() => {
        'pending_item': pendingItem.toJson(),
    };
}

class PendingItem {
    List<PendingFinalDatum> pendingFinalData;
    int total;

    PendingItem({
        required this.pendingFinalData,
        required this.total,
    });

    factory PendingItem.fromJson(Map<String, dynamic> json) => PendingItem(
        pendingFinalData: List<PendingFinalDatum>.from(json['pendingFinalData'].map((x) => PendingFinalDatum.fromJson(x))),
        total: json['total'],
    );

    Map<String, dynamic> toJson() => {
        'pendingFinalData': List<dynamic>.from(pendingFinalData.map((x) => x.toJson())),
        'total': total,
    };
}

class PendingFinalDatum {
    int orderListItemId;
    String productId;
    String name;
    String price;
    String image;
    String quantity;
    int totalPrice;

    PendingFinalDatum({
        required this.orderListItemId,
        required this.productId,
        required this.name,
        required this.price,
        required this.image,
        required this.quantity,
        required this.totalPrice,
    });

    factory PendingFinalDatum.fromJson(Map<String, dynamic> json) => PendingFinalDatum(
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

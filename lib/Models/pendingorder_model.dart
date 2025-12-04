// To parse this JSON data, do
//
//     final pendingOrderModel = pendingOrderModelFromJson(jsonString);

import 'dart:convert';

PendingOrderModel pendingOrderModelFromJson(String str) => PendingOrderModel.fromJson(json.decode(str));

String pendingOrderModelToJson(PendingOrderModel data) => json.encode(data.toJson());

class PendingOrderModel {
    int status;
    Data data;

    PendingOrderModel({
        required this.status,
        required this.data,
    });

    factory PendingOrderModel.fromJson(Map<String, dynamic> json) => PendingOrderModel(
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
    List<FinalDatum> finalData;
    dynamic total;

    PendingItem({
        required this.finalData,
        this.total,
    });

    factory PendingItem.fromJson(Map<String, dynamic> json) => PendingItem(
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

// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) => OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
    int status;
    Data data;

    OrderListModel({
        required this.status,
        required this.data,
    });

    factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
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
    dynamic total;

    OrderListItem({
        required this.finalData,
        this.total,
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

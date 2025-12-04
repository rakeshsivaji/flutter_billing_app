// To parse this JSON data, do
//
//     final tomorrowOrderListModel = tomorrowOrderListModelFromJson(jsonString);

import 'dart:convert';

TomorrowOrderListModel tomorrowOrderListModelFromJson(String str) => TomorrowOrderListModel.fromJson(json.decode(str));

String tomorrowOrderListModelToJson(TomorrowOrderListModel data) => json.encode(data.toJson());

class TomorrowOrderListModel {
    int status;
    Data data;

    TomorrowOrderListModel({
        required this.status,
        required this.data,
    });

    factory TomorrowOrderListModel.fromJson(Map<String, dynamic> json) => TomorrowOrderListModel(
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
    List<TomorrowFinalDatum> tomorrowFinalData;
    dynamic total;

    OrderListItem({
        required this.tomorrowFinalData,
        required this.total,
    });

    factory OrderListItem.fromJson(Map<String, dynamic> json) => OrderListItem(
        tomorrowFinalData: List<TomorrowFinalDatum>.from(json['tomorrowFinalData'].map((x) => TomorrowFinalDatum.fromJson(x))),
        total: json['total'],
    );

    Map<String, dynamic> toJson() => {
        'tomorrowFinalData': List<dynamic>.from(tomorrowFinalData.map((x) => x.toJson())),
        'total': total,
    };
}

class TomorrowFinalDatum {
    int orderListItemId;
    String productId;
    String name;
    String price;
    String image;
    String quantity;
    dynamic totalPrice;

    TomorrowFinalDatum({
        required this.orderListItemId,
        required this.productId,
        required this.name,
        required this.price,
        required this.image,
        required this.quantity,
        required this.totalPrice,
    });

    factory TomorrowFinalDatum.fromJson(Map<String, dynamic> json) => TomorrowFinalDatum(
        orderListItemId: json['order_list_item_id'],
        productId: json['product_id'],
        name: json['name'] == null ? '' : json['name'],
        price: json['price']== null ? '' : json['price'],
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

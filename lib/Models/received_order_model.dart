// To parse this JSON data, do
//
//     final orderReceivedModel = orderReceivedModelFromJson(jsonString);

import 'dart:convert';

OrderReceivedModel orderReceivedModelFromJson(String str) => OrderReceivedModel.fromJson(json.decode(str));

String orderReceivedModelToJson(OrderReceivedModel data) => json.encode(data.toJson());

class OrderReceivedModel {
    int status;
    Data data;

    OrderReceivedModel({
        required this.status,
        required this.data,
    });

    factory OrderReceivedModel.fromJson(Map<String, dynamic> json) => OrderReceivedModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    List<OrderReceived> orderReceived;

    Data({
        required this.orderReceived,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderReceived: List<OrderReceived>.from(json['order_received'].map((x) => OrderReceived.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'order_received': List<dynamic>.from(orderReceived.map((x) => x.toJson())),
    };
}

class OrderReceived {
    int orderId;
    String pathName;
    String storeName;
    String storeAddress;
    String date;
    List<Order> orders;

    OrderReceived({
        required this.orderId,
        required this.pathName,
        required this.storeName,
        required this.storeAddress,
        required this.date,
        required this.orders,
    });

    factory OrderReceived.fromJson(Map<String, dynamic> json) => OrderReceived(
        orderId: json['order_id'],
        pathName: json['path_name'],
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        date: json['date'],
        orders: List<Order>.from(json['orders'].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'path_name': pathName,
        'store_name': storeName,
        'store_address': storeAddress,
        'date': date,
        'orders': List<dynamic>.from(orders.map((x) => x.toJson())),
    };
}

class Order {
    String time;
    List<ListOrder> listOrders;

    Order({
        required this.time,
        required this.listOrders,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        time: json['time'],
        listOrders: List<ListOrder>.from(json['list_orders'].map((x) => ListOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'time': time,
        'list_orders': List<dynamic>.from(listOrders.map((x) => x.toJson())),
    };
}

class ListOrder {
    String name;
    String quantity;
    String amount;

    ListOrder({
        required this.name,
        required this.quantity,
        required this.amount,
    });

    factory ListOrder.fromJson(Map<String, dynamic> json) => ListOrder(
        name: json['name'],
        quantity: json['quantity'],
        amount: json['amount'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'amount': amount,
    };
}

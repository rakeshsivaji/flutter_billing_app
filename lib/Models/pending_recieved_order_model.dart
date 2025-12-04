// To parse this JSON data, do
//
//     final pendingRecievedOrderModel = pendingRecievedOrderModelFromJson(jsonString);

import 'dart:convert';

PendingRecievedOrderModel pendingRecievedOrderModelFromJson(String str) => PendingRecievedOrderModel.fromJson(json.decode(str));

String pendingRecievedOrderModelToJson(PendingRecievedOrderModel data) => json.encode(data.toJson());

class PendingRecievedOrderModel {
    int status;
    Data data;

    PendingRecievedOrderModel({
        required this.status,
        required this.data,
    });

    factory PendingRecievedOrderModel.fromJson(Map<String, dynamic> json) => PendingRecievedOrderModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    List<DataPendingOrder> pendingOrder;

    Data({
        required this.pendingOrder,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        pendingOrder: List<DataPendingOrder>.from(json['pending_order'].map((x) => DataPendingOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'pending_order': List<dynamic>.from(pendingOrder.map((x) => x.toJson())),
    };
}

class DataPendingOrder {
    String orderId;
    String storeName;
    String storeAddress;
    String pathName;
    String date;
    List<PendingOrderPendingOrder> pendingOrders;

    DataPendingOrder({
        required this.orderId,
        required this.storeName,
        required this.storeAddress,
        required this.pathName,
        required this.date,
        required this.pendingOrders,
    });

    factory DataPendingOrder.fromJson(Map<String, dynamic> json) => DataPendingOrder(
        orderId: json['order_id']??'',
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        pathName: json['path_name'],
        date: json['date'],
        pendingOrders: List<PendingOrderPendingOrder>.from(json['pending_orders'].map((x) => PendingOrderPendingOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'store_name': storeName,
        'store_address': storeAddress,
        'path_name': pathName,
        'date': date,
        'pending_orders': List<dynamic>.from(pendingOrders.map((x) => x.toJson())),
    };
}

class PendingOrderPendingOrder {
    String name;
    String quantity;
    String amount;

    PendingOrderPendingOrder({
        required this.name,
        required this.quantity,
        required this.amount,
    });

    factory PendingOrderPendingOrder.fromJson(Map<String, dynamic> json) => PendingOrderPendingOrder(
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

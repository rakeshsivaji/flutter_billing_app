// To parse this JSON data, do
//
//     final tomorrowRecievedOrderModel = tomorrowRecievedOrderModelFromJson(jsonString);

import 'dart:convert';

TomorrowRecievedOrderModel tomorrowRecievedOrderModelFromJson(String str) => TomorrowRecievedOrderModel.fromJson(json.decode(str));

String tomorrowRecievedOrderModelToJson(TomorrowRecievedOrderModel data) => json.encode(data.toJson());

class TomorrowRecievedOrderModel {
    int status;
    Data data;

    TomorrowRecievedOrderModel({
        required this.status,
        required this.data,
    });

    factory TomorrowRecievedOrderModel.fromJson(Map<String, dynamic> json) => TomorrowRecievedOrderModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    List<DataTomorrowOrder> tomorrowOrder;

    Data({
        required this.tomorrowOrder,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        tomorrowOrder: List<DataTomorrowOrder>.from(json['tomorrow_order'].map((x) => DataTomorrowOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'tomorrow_order': List<dynamic>.from(tomorrowOrder.map((x) => x.toJson())),
    };
}

class DataTomorrowOrder {
    String orderId;
    String storeName;
    String storeAddress;
    String pathName;
    String date;
    List<TomorrowOrderTomorrowOrder> tomorrowOrders;

    DataTomorrowOrder({
        required this.orderId,
        required this.storeName,
        required this.storeAddress,
        required this.pathName,
        required this.date,
        required this.tomorrowOrders,
    });

    factory DataTomorrowOrder.fromJson(Map<String, dynamic> json) => DataTomorrowOrder(
        orderId: json['order_id']??'',
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        pathName: json['path_name'],
        date: json['date'],
        tomorrowOrders: List<TomorrowOrderTomorrowOrder>.from(json['tomorrow_orders'].map((x) => TomorrowOrderTomorrowOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'store_name': storeName,
        'store_address': storeAddress,
        'path_name': pathName,
        'date': date,
        'tomorrow_orders': List<dynamic>.from(tomorrowOrders.map((x) => x.toJson())),
    };
}

class TomorrowOrderTomorrowOrder {
    String name;
    String quantity;
    String amount;

    TomorrowOrderTomorrowOrder({
        required this.name,
        required this.quantity,
        required this.amount,
    });

    factory TomorrowOrderTomorrowOrder.fromJson(Map<String, dynamic> json) => TomorrowOrderTomorrowOrder(
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

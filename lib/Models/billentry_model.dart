// To parse this JSON data, do
//
//     final billEntryModel = billEntryModelFromJson(jsonString);

import 'dart:convert';

BillEntryModel billEntryModelFromJson(String str) => BillEntryModel.fromJson(json.decode(str));

String billEntryModelToJson(BillEntryModel data) => json.encode(data.toJson());

class BillEntryModel {
    int status;
    Data data;

    BillEntryModel({
        required this.status,
        required this.data,
    });

    factory BillEntryModel.fromJson(Map<String, dynamic> json) => BillEntryModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    int orderId;
    Store store;
    Order order;
    List<OrderItem> orderItem;
    int totalAmount;
    int totalPaymentAmount;

    Data({
        required this.orderId,
        required this.store,
        required this.order,
        required this.orderItem,
        required this.totalAmount,
        required this.totalPaymentAmount,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderId: json['order_id'],
        store: Store.fromJson(json['store']),
        order: Order.fromJson(json['order']),
        orderItem: List<OrderItem>.from(json['order_item'].map((x) => OrderItem.fromJson(x))),
        totalAmount: json['total_amount'],
        totalPaymentAmount: json['total_payment_amount'],
    );

    Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'store': store.toJson(),
        'order': order.toJson(),
        'order_item': List<dynamic>.from(orderItem.map((x) => x.toJson())),
        'total_amount': totalAmount,
        'total_payment_amount': totalPaymentAmount,
    };
}

class Order {
    String orderNo;
    String date;

    Order({
        required this.orderNo,
        required this.date,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderNo: json['order_no'],
        date: json['date'],
    );

    Map<String, dynamic> toJson() => {
        'order_no': orderNo,
        'date': date,
    };
}

class OrderItem {
    int orderItemId;
    String name;
    String quantity;
    int amount;

    OrderItem({
        required this.orderItemId,
        required this.name,
        required this.quantity,
        required this.amount,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderItemId: json['order_item_id'],
        name: json['name'],
        quantity: json['quantity'],
        amount: json['amount'],
    );

    Map<String, dynamic> toJson() => {
        'order_item_id': orderItemId,
        'name': name,
        'quantity': quantity,
        'amount': amount,
    };
}

class Store {
    String storeName;
    String storeAddress;

    Store({
        required this.storeName,
        required this.storeAddress,
    });

    factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeName: json['store_name'],
        storeAddress: json['store_address'],
    );

    Map<String, dynamic> toJson() => {
        'store_name': storeName,
        'store_address': storeAddress,
    };
}

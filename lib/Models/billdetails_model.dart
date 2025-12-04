// To parse this JSON data, do
//
//     final billDetailsModel = billDetailsModelFromJson(jsonString);

import 'dart:convert';

BillDetailsModel billDetailsModelFromJson(String str) => BillDetailsModel.fromJson(json.decode(str));

String billDetailsModelToJson(BillDetailsModel data) => json.encode(data.toJson());

class BillDetailsModel {
    int status;
    Data data;

    BillDetailsModel({
        required this.status,
        required this.data,
    });

    factory BillDetailsModel.fromJson(Map<String, dynamic> json) => BillDetailsModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    int billId;
    int orderId;
    String pathName;
    Store store;
    Order order;
    List<OrderItem> orderItem;
    dynamic pendingAmount;
    String totalPaymentAmount;
    dynamic totalAmount;
    String downloadUrl;

    Data({
        required this.billId,
        required this.orderId,
        required this.pathName,
        required this.store,
        required this.order,
        required this.orderItem,
        required this.pendingAmount,
        required this.totalPaymentAmount,
        required this.totalAmount,
        required this.downloadUrl,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        billId: json['bill_id'],
        orderId: json['order_id'],
        pathName: json['path_name'],
        store: Store.fromJson(json['store']),
        order: Order.fromJson(json['order']),
        orderItem: List<OrderItem>.from(json['order_item'].map((x) => OrderItem.fromJson(x))),
        pendingAmount: json['pending_amount'],
        totalPaymentAmount: json['total_payment_amount'],
        totalAmount: json['total_amount'],
        downloadUrl: json['download_url'],
    );

    Map<String, dynamic> toJson() => {
        'bill_id': billId,
        'order_id': orderId,
        'path_name': pathName,
        'store': store.toJson(),
        'order': order.toJson(),
        'order_item': List<dynamic>.from(orderItem.map((x) => x.toJson())),
        'pending_amount': pendingAmount,
        'total_payment_amount': totalPaymentAmount,
        'total_amount': totalAmount,
        'download_url': downloadUrl,
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
    String productAmount;
    dynamic amount;

    OrderItem({
        required this.orderItemId,
        required this.name,
        required this.quantity,
        required this.productAmount,
        required this.amount,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderItemId: json['order_item_id'],
        name: json['name'],
        quantity: json['quantity'],
        productAmount: json['product_amount'],
        amount: json['amount'],
    );

    Map<String, dynamic> toJson() => {
        'order_item_id': orderItemId,
        'name': name,
        'quantity': quantity,
        'product_amount': productAmount,
        'amount': amount,
    };
}

class Store {
    String storeName;
    String storeAddress;
    String phone;

    Store({
        required this.storeName,
        required this.storeAddress,
        required this.phone,
    });

    factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        phone: json['phone'],
    );

    Map<String, dynamic> toJson() => {
        'store_name': storeName,
        'store_address': storeAddress,
        'phone': phone,
    };
}

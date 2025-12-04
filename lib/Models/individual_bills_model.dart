// To parse this JSON data, do
//
//     final individualBillsModel = individualBillsModelFromJson(jsonString);

import 'dart:convert';

IndividualBillsModel individualBillsModelFromJson(String str) =>
    IndividualBillsModel.fromJson(json.decode(str));

String individualBillsModelToJson(IndividualBillsModel data) =>
    json.encode(data.toJson());

class IndividualBillsModel {
  int? status;
  List<Datum>? data;

  IndividualBillsModel({
    this.status,
    this.data,
  });

  factory IndividualBillsModel.fromJson(Map<String, dynamic> json) =>
      IndividualBillsModel(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<Datum>.from(json['data']!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? date;
  String? storeName;
  String? storeAddress;
  String? pathName;
  String? time;
  Orders? orders;

  Datum({
    this.date,
    this.storeName,
    this.storeAddress,
    this.pathName,
    this.time,
    this.orders,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json['date'],
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        pathName: json['path_name'],
        time: json['time'],
        orders: json['orders'] == null ? null : Orders.fromJson(json['orders']),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'store_name': storeName,
        'store_address': storeAddress,
        'path_name': pathName,
        'time': time,
        'orders': orders?.toJson(),
      };
}

class Orders {
  String? billIds;
  String? orderIds;
  String? orderNos;
  List<OrderItem>? orderItems;
  dynamic totalAmount;
  dynamic pendingAmount;
  dynamic totalPaymentAmount;

  Orders({
    this.billIds,
    this.orderIds,
    this.orderNos,
    this.orderItems,
    this.totalAmount,
    this.pendingAmount,
    this.totalPaymentAmount,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        billIds: json['bill_ids'],
        orderIds: json['order_ids'],
        orderNos: json['order_nos'],
        orderItems: json['order_items'] == null
            ? []
            : List<OrderItem>.from(
                json['order_items']!.map((x) => OrderItem.fromJson(x))),
        totalAmount: json['total_amount'],
        pendingAmount: json['pending_amount'],
        totalPaymentAmount: json['total_payment_amount'],
      );

  Map<String, dynamic> toJson() => {
        'bill_ids': billIds,
        'order_ids': orderIds,
        'order_nos': orderNos,
        'order_items': orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
        'total_amount': totalAmount,
        'pending_amount': pendingAmount,
        'total_payment_amount': totalPaymentAmount,
      };
}

class OrderItem {
  int? orderItemId;
  String? name;
  String? quantity;
  String? productAmount;
  dynamic amount;

  OrderItem({
    this.orderItemId,
    this.name,
    this.quantity,
    this.productAmount,
    this.amount,
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

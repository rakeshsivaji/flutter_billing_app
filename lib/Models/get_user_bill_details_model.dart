// To parse this JSON data, do
//
//     final getUserBillDetailsModel = getUserBillDetailsModelFromJson(jsonString);

import 'dart:convert';

GetUserBillDetailsModel getUserBillDetailsModelFromJson(String str) => GetUserBillDetailsModel.fromJson(json.decode(str));

String getUserBillDetailsModelToJson(GetUserBillDetailsModel data) => json.encode(data.toJson());

class GetUserBillDetailsModel {
  int? status;
  Data? data;

  GetUserBillDetailsModel({
    this.status,
    this.data,
  });

  factory GetUserBillDetailsModel.fromJson(Map<String, dynamic> json) => GetUserBillDetailsModel(
    status: json['status'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class Data {
  List<int>? billId;
  int? orderId;
  String? pathName;
  Store? store;
  Order? order;
  List<OrderItem>? orderItems;
  dynamic pendingAmount;
  dynamic totalPaymentAmount;
  dynamic totalAmount;

  Data({
    this.billId,
    this.orderId,
    this.pathName,
    this.store,
    this.order,
    this.orderItems,
    this.pendingAmount,
    this.totalPaymentAmount,
    this.totalAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    billId: json['bill_id'] == null ? [] : List<int>.from(json['bill_id']!.map((x) => x)),
    orderId: json['order_id'],
    pathName: json['path_name'],
    store: json['store'] == null ? null : Store.fromJson(json['store']),
    order: json['order'] == null ? null : Order.fromJson(json['order']),
    orderItems: json['order_items'] == null ? [] : List<OrderItem>.from(json['order_items']!.map((x) => OrderItem.fromJson(x))),
    pendingAmount: json['pending_amount'],
    totalPaymentAmount: json['total_payment_amount'],
    totalAmount: json['total_amount'],
  );

  Map<String, dynamic> toJson() => {
    'bill_id': billId == null ? [] : List<dynamic>.from(billId!.map((x) => x)),
    'order_id': orderId,
    'path_name': pathName,
    'store': store?.toJson(),
    'order': order?.toJson(),
    'order_items': orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
    'pending_amount': pendingAmount,
    'total_payment_amount': totalPaymentAmount,
    'total_amount': totalAmount,
  };
}

class Order {
  String? orderNo;
  String? date;

  Order({
    this.orderNo,
    this.date,
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
  String? dateTime;
  List<Item>? items;

  OrderItem({
    this.dateTime,
    this.items,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    dateTime: json['date_time'],
    items: json['items'] == null ? [] : List<Item>.from(json['items']!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'date_time': dateTime,
    'items': items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  List<int>? orderItemId;
  String? name;
  int? quantity;
  String? productAmount;
  dynamic amount;

  Item({
    this.orderItemId,
    this.name,
    this.quantity,
    this.productAmount,
    this.amount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    orderItemId: json['order_item_id'] == null ? [] : List<int>.from(json['order_item_id']!.map((x) => x)),
    name: json['name'],
    quantity: json['quantity'],
    productAmount: json['product_amount'],
    amount: json['amount'],
  );

  Map<String, dynamic> toJson() => {
    'order_item_id': orderItemId == null ? [] : List<dynamic>.from(orderItemId!.map((x) => x)),
    'name': name,
    'quantity': quantity,
    'product_amount': productAmount,
    'amount': amount,
  };
}

class Store {
  String? storeName;
  String? storeAddress;
  String? phone;

  Store({
    this.storeName,
    this.storeAddress,
    this.phone,
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

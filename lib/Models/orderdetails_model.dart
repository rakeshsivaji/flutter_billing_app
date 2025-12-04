// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));
String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  int? status;
  Data? data;

  OrderDetailsModel({
    this.status,
    this.data,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    status: json['status'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };

  OrderDetailsModel copyWith({
    int? status,
    Data? data,
  }) {
    return OrderDetailsModel(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? orderId;
  Store? store;
  Order? order;
  List<TotalOrder>? totalOrders;
  dynamic totalAmount;
  dynamic pendingAmount;
  dynamic overallTotalAmount;

  Data({
    this.orderId,
    this.store,
    this.order,
    this.totalOrders,
    this.totalAmount,
    this.pendingAmount,
    this.overallTotalAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderId: json['order_id'],
    store: json['store'] == null ? null : Store.fromJson(json['store']),
    order: json['order'] == null ? null : Order.fromJson(json['order']),
    totalOrders: json['total_orders'] == null ? [] : List<TotalOrder>.from(json['total_orders']!.map((x) => TotalOrder.fromJson(x))),
    totalAmount: json['total_amount'],
    pendingAmount: json['pending_amount'],
    overallTotalAmount: json['overall_total_amount'],
  );

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'store': store?.toJson(),
    'order': order?.toJson(),
    'total_orders': totalOrders == null ? [] : List<dynamic>.from(totalOrders!.map((x) => x.toJson())),
    'total_amount': totalAmount,
    'pending_amount': pendingAmount,
    'overall_total_amount': overallTotalAmount,
  };

  Data copyWith({
    int? orderId,
    Store? store,
    Order? order,
    List<TotalOrder>? totalOrders,
    dynamic totalAmount,
    dynamic pendingAmount,
    dynamic overallTotalAmount,
  }) {
    return Data(
      orderId: orderId ?? this.orderId,
      store: store ?? this.store,
      order: order ?? this.order,
      totalOrders: totalOrders ?? this.totalOrders,
      totalAmount: totalAmount ?? this.totalAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      overallTotalAmount: overallTotalAmount ?? this.overallTotalAmount,
    );
  }
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

  Order copyWith({
    String? orderNo,
    String? date,
  }) {
    return Order(
      orderNo: orderNo ?? this.orderNo,
      date: date ?? this.date,
    );
  }
}

class Store {
  String? storeName;
  String? storeAddress;

  Store({
    this.storeName,
    this.storeAddress,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    storeName: json['store_name'],
    storeAddress: json['store_address'],
  );

  Map<String, dynamic> toJson() => {
    'store_name': storeName,
    'store_address': storeAddress,
  };

  Store copyWith({
    String? storeName,
    String? storeAddress,
  }) {
    return Store(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
    );
  }
}

class TotalOrder {
  String? orderTime;
  List<OrderItem>? orderItem;

  TotalOrder({
    this.orderTime,
    this.orderItem,
  });

  factory TotalOrder.fromJson(Map<String, dynamic> json) => TotalOrder(
    orderTime: json['order_time'],
    orderItem: json['order_item'] == null ? [] : List<OrderItem>.from(json['order_item']!.map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'order_time': orderTime,
    'order_item': orderItem == null ? [] : List<dynamic>.from(orderItem!.map((x) => x.toJson())),
  };

  TotalOrder copyWith({
    String? orderTime,
    List<OrderItem>? orderItem,
  }) {
    return TotalOrder(
      orderTime: orderTime ?? this.orderTime,
      orderItem: orderItem ?? this.orderItem,
    );
  }
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

  OrderItem copyWith({
    int? orderItemId,
    String? name,
    String? quantity,
    String? productAmount,
    dynamic amount,
  }) {
    return OrderItem(
      orderItemId: orderItemId ?? this.orderItemId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      productAmount: productAmount ?? this.productAmount,
      amount: amount ?? this.amount,
    );
  }
}
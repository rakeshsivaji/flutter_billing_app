// To parse this JSON data, do
//
//     final orderstockListModel = orderstockListModelFromJson(jsonString);

import 'dart:convert';

OrderstockListModel orderstockListModelFromJson(String str) =>
    OrderstockListModel.fromJson(json.decode(str));

String orderstockListModelToJson(OrderstockListModel data) =>
    json.encode(data.toJson());

class OrderstockListModel {
  int status;
  Data data;

  OrderstockListModel({
    required this.status,
    required this.data,
  });

  factory OrderstockListModel.fromJson(Map<String, dynamic> json) =>
      OrderstockListModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  ListItem? orderListItem;
  ListItem? pendingListItem; // Make pendingListItem nullable

  Data({
    required this.orderListItem,
    this.pendingListItem, // Nullable pendingListItem
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderListItem:
            json['order_list_item'] is List && json['order_list_item'].isEmpty
                ? null
                : ListItem.fromJson(json['order_list_item']),
        pendingListItem: json['pending_list_item'] is List &&
                json['pending_list_item'].isEmpty
            ? null // If it's an empty list, return null
            : ListItem.fromJson(json['pending_list_item']),
      );

  Map<String, dynamic> toJson() => {
        'order_list_item': orderListItem?.toJson() ?? [],
        'pending_list_item': pendingListItem?.toJson() ?? [],
      };
}

class ListItem {
  List<OrderStockListModelFinalDatum> finalData;
  dynamic total;

  ListItem({
    required this.finalData,
    required this.total,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        finalData: List<OrderStockListModelFinalDatum>.from(json['finalData']
            .map((x) => OrderStockListModelFinalDatum.fromJson(x))),
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'finalData': List<dynamic>.from(finalData.map((x) => x.toJson())),
        'total': total,
      };
}

class OrderStockListModelFinalDatum {
  int orderListItemId;
  String productId;
  String name;
  String? pending;
  String price;
  String image;
  String quantity;
  dynamic totalPrice;

  OrderStockListModelFinalDatum({
    required this.orderListItemId,
    required this.productId,
    required this.name,
    required this.pending,
    required this.price,
    required this.image,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderStockListModelFinalDatum.fromJson(Map<String, dynamic> json) =>
      OrderStockListModelFinalDatum(
        orderListItemId: json['order_list_item_id'],
        productId: json['product_id'],
        name: json['name'],
        pending: json['pending'],
        price: json['price'],
        image: json['image'],
        quantity: json['quantity'],
        totalPrice: json['total_price'],
      );

  Map<String, dynamic> toJson() => {
        'order_list_item_id': orderListItemId,
        'product_id': productId,
        'name': name,
        'pending': pending,
        'price': price,
        'image': image,
        'quantity': quantity,
        'total_price': totalPrice,
      };
}

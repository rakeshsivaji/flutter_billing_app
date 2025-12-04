// To parse this JSON data, do
//
//     final individualBillShowModel = individualBillShowModelFromJson(jsonString);

import 'dart:convert';

IndividualBillShowModel individualBillShowModelFromJson(String str) =>
    IndividualBillShowModel.fromJson(json.decode(str));

String individualBillShowModelToJson(IndividualBillShowModel data) =>
    json.encode(data.toJson());

class IndividualBillShowModel {
  int status;
  Data data;

  IndividualBillShowModel({
    required this.status,
    required this.data,
  });

  factory IndividualBillShowModel.fromJson(Map<String, dynamic> json) =>
      IndividualBillShowModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  int storeId;
  String storeName;
  String pathName;
  String storeAddress;
  List<ListProduct> listProducts;
  dynamic totalAmount;
  dynamic pendingAmount;
  dynamic totalPaidAmount;
  String pdfDownloadUrl;

  Data({
    required this.storeId,
    required this.storeName,
    required this.pathName,
    required this.storeAddress,
    required this.listProducts,
    required this.pendingAmount,
    required this.totalAmount,
    required this.totalPaidAmount,
    required this.pdfDownloadUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeId: json['store_id'],
        storeName: json['store_name'],
        pathName: json['path_name'],
        storeAddress: json['store_address'],
        listProducts: List<ListProduct>.from(
            json['list_products'].map((x) => ListProduct.fromJson(x))),
        totalAmount: json['total_amount'],
        pendingAmount: json['pending_amount'],
        totalPaidAmount: json['total_amount_paid'],
        pdfDownloadUrl: json['pdf_download_url'],
      );

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'store_name': storeName,
        'path_name': pathName,
        'store_address': storeAddress,
        'list_products':
            List<dynamic>.from(listProducts.map((x) => x.toJson())),
        'total_amount_paid': totalPaidAmount,
        'pending_amount': pendingAmount,
        'total_amount': totalAmount,
        'pdf_download_url': pdfDownloadUrl,
      };
}

class ListProduct {
  dynamic totalAmount;
  dynamic pendingAmount;
  String? date;
  List<Product> product;
  int total;
  String? orderNumber;
  dynamic totalAmountPaid;

  ListProduct({
    required this.totalAmount,
    required this.pendingAmount,
    required this.product,
    required this.total,
    this.date,
    this.orderNumber,
    this.totalAmountPaid,
  });

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        totalAmount: json['total_amount'],
        pendingAmount: json['pending_amount'],
        orderNumber: json['order_no'],
        date: json['date'],
        product:
            List<Product>.from(json['product'].map((x) => Product.fromJson(x))),
        total: json['total'] ?? 0,
        totalAmountPaid: json['total_amount_paid'],
      );

  Map<String, dynamic> toJson() => {
        'total_amount': totalAmount,
        'pending_amount': pendingAmount,
        'order_no': orderNumber,
        'date': date,
        'product': List<dynamic>.from(product.map((x) => x.toJson())),
        'total': total,
        'total_amount_paid': totalAmountPaid,
      };
}

class Product {
  int orderListItemId;
  String productId;
  String name;
  dynamic price;
  String image;
  String quantity;
  dynamic totalPrice;

  Product({
    required this.orderListItemId,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.totalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        orderListItemId: json['order_list_item_id'],
        productId: json['product_id'],
        name: json['name'],
        price: json['price'],
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

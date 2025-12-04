import 'dart:convert';

UserIndividualBills userIndividualBillsFromJson(String str) =>
    UserIndividualBills.fromJson(json.decode(str));

String userIndividualBillsToJson(UserIndividualBills data) =>
    json.encode(data.toJson());

class UserIndividualBills {
  int? status;
  Data? data;

  UserIndividualBills({
    this.status,
    this.data,
  });

  factory UserIndividualBills.fromJson(Map<String, dynamic> json) =>
      UserIndividualBills(
        status: json['status'],
        data: json['data'] == null ? null : Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };
}

class Data {
  int? storeId;
  String? storeName;
  String? pathName;
  String? storeAddress;
  List<ListProduct>? listProducts;
  String? pdfDownloadUrl;

  Data({
    this.storeId,
    this.storeName,
    this.pathName,
    this.storeAddress,
    this.listProducts,
    this.pdfDownloadUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeId: json['store_id'],
        storeName: json['store_name'],
        pathName: json['path_name'],
        storeAddress: json['store_address'],
        listProducts: json['list_products'] == null
            ? []
            : List<ListProduct>.from(
                json['list_products']!.map((x) => ListProduct.fromJson(x))),
        pdfDownloadUrl: json['pdf_download_url'],
      );

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'store_name': storeName,
        'path_name': pathName,
        'store_address': storeAddress,
        'list_products': listProducts == null
            ? []
            : List<dynamic>.from(listProducts!.map((x) => x.toJson())),
        'pdf_download_url': pdfDownloadUrl,
      };
}

class ListProduct {
  dynamic totalAmount;
  dynamic pendingAmount;
  dynamic totalAmountPaid;
  String? date;
  List<Order>? orders;

  ListProduct({
    this.totalAmount,
    this.pendingAmount,
    this.totalAmountPaid,
    this.date,
    this.orders,
  });

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        totalAmount: json['total_amount'],
        pendingAmount: json['pending_amount'],
        totalAmountPaid: json['total_amount_paid'],
        date: json['date'],
        orders: json['orders'] == null
            ? []
            : List<Order>.from(json['orders']!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'total_amount': totalAmount,
        'pending_amount': pendingAmount,
        'total_amount_paid': totalAmountPaid,
        'date': date,
        'orders': orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  String? time;
  List<Product>? products;

  Order({
    this.time,
    this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        time: json['time'],
        products: json['products'] == null
            ? []
            : List<Product>.from(
                json['products']!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'products': products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  int? orderListItemId;
  String? productId;
  String? name;
  String? price;
  String? image;
  String? quantity;
  dynamic totalPrice;

  Product({
    this.orderListItemId,
    this.productId,
    this.name,
    this.price,
    this.image,
    this.quantity,
    this.totalPrice,
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

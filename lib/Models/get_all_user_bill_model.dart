import 'dart:convert';

GetAllUserBillModel getAllUserBillModelFromJson(String str) =>
    GetAllUserBillModel.fromJson(json.decode(str));

String getAllUserBillModelToJson(GetAllUserBillModel data) =>
    json.encode(data.toJson());

class GetAllUserBillModel {
  int? status;
  List<Datum>? data;

  GetAllUserBillModel({
    this.status,
    this.data,
  });

  factory GetAllUserBillModel.fromJson(Map<String, dynamic> json) =>
      GetAllUserBillModel(
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
  List<Order>? orders;

  Datum({
    this.date,
    this.storeName,
    this.storeAddress,
    this.pathName,
    this.orders,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json['date'],
        storeName: json['store_name'],
        storeAddress: json['store_address'],
        pathName: json['path_name'],
        orders: json['orders'] == null
            ? []
            : List<Order>.from(json['orders']!.map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'store_name': storeName,
        'store_address': storeAddress,
        'path_name': pathName,
        'orders': orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  int? billId;
  String? orderNo;
  String? time;
  String? path;

  Order({
    this.billId,
    this.orderNo,
    this.time,
    this.path,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        billId: json['bill_id'],
        orderNo: json['order_no'],
        time: json['time'],
        path: json['path'],
      );

  Map<String, dynamic> toJson() => {
        'bill_id': billId,
        'order_no': orderNo,
        'time': time,
        'path': path,
      };
}

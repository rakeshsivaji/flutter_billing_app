// To parse this JSON data, do
//
//     final getShopsBalanceAmountModel = getShopsBalanceAmountModelFromJson(jsonString);

import 'dart:convert';

GetShopsBalanceAmountModel getShopsBalanceAmountModelFromJson(String str) =>
    GetShopsBalanceAmountModel.fromJson(json.decode(str));

String getShopsBalanceAmountModelToJson(GetShopsBalanceAmountModel data) =>
    json.encode(data.toJson());

class GetShopsBalanceAmountModel {
  int? status;
  List<BalanceAmountData>? data;

  GetShopsBalanceAmountModel({
    this.status,
    this.data,
  });

  factory GetShopsBalanceAmountModel.fromJson(Map<String, dynamic> json) =>
      GetShopsBalanceAmountModel(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<BalanceAmountData>.from(json['data']!.map((x) => BalanceAmountData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BalanceAmountData {
  int? shopId;
  String? shopName;
  String? pathName;
  dynamic pendingAmount;

  BalanceAmountData({
    this.shopId,
    this.shopName,
    this.pathName,
    this.pendingAmount,
  });

  factory BalanceAmountData.fromJson(Map<String, dynamic> json) => BalanceAmountData(
        shopId: json['shop_id'],
        shopName: json['shop_name'],
        pathName: json['path_name'],
        pendingAmount: json['pending_amount'],
      );

  Map<String, dynamic> toJson() => {
        'shop_id': shopId,
        'shop_name': shopName,
        'path_name': pathName,
        'pending_amount': pendingAmount,
      };
}

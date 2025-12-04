// To parse this JSON data, do
//
//     final userCollectionReportModel = userCollectionReportModelFromJson(jsonString);

import 'dart:convert';

UserCollectionReportModel userCollectionReportModelFromJson(String str) =>
    UserCollectionReportModel.fromJson(json.decode(str));

String userCollectionReportModelToJson(UserCollectionReportModel data) =>
    json.encode(data.toJson());

class UserCollectionReportModel {
  int status;
  List<Datum> data;
  String downloadUrl;

  UserCollectionReportModel({
    required this.status,
    required this.data,
    required this.downloadUrl,
  });

  factory UserCollectionReportModel.fromJson(Map<String, dynamic> json) =>
      UserCollectionReportModel(
        status: json['status'],
        downloadUrl: json['download_url'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'download_url': downloadUrl,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String storeName;
  dynamic totalAmount;
  String date;
  List<AmountsByTime> amountsByTime;

  Datum({
    required this.storeName,
    required this.totalAmount,
    required this.date,
    required this.amountsByTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        storeName: json['store_name'],
        totalAmount: json['total_amount'],
        date: json['date'],
        amountsByTime: List<AmountsByTime>.from(
            json['amounts_by_time'].map((x) => AmountsByTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'store_name': storeName,
        'total_amount': totalAmount,
        'date': date,
        'amounts_by_time':
            List<dynamic>.from(amountsByTime.map((x) => x.toJson())),
      };
}

class AmountsByTime {
  String time;
  String amount;

  AmountsByTime({
    required this.time,
    required this.amount,
  });

  factory AmountsByTime.fromJson(Map<String, dynamic> json) => AmountsByTime(
        time: json['time'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'amount': amount,
      };
}

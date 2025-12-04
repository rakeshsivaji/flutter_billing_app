// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  int status;
  List<Datum> data;
  String downloadUrl;

  ReportModel({
    required this.status,
    required this.data,
    required this.downloadUrl,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
        downloadUrl: json['download_url'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
        'download_url': downloadUrl,
      };
}

class Datum {
  String date;
  String storeName;
  String amount;

  Datum({
    required this.date,
    required this.storeName,
    required this.amount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json['date'],
        storeName: json['store_name'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'store_name': storeName,
        'amount': amount,
      };
}

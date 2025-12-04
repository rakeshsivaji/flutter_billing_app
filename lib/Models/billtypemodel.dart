// To parse this JSON data, do
//
//     final billTypeModel = billTypeModelFromJson(jsonString);

import 'dart:convert';

BillTypeModel billTypeModelFromJson(String str) => BillTypeModel.fromJson(json.decode(str));

String billTypeModelToJson(BillTypeModel data) => json.encode(data.toJson());

class BillTypeModel {
    int status;
    List<Datum> data;

    BillTypeModel({
        required this.status,
        required this.data,
    });

    factory BillTypeModel.fromJson(Map<String, dynamic> json) => BillTypeModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String name;

    Datum({
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
    };
}

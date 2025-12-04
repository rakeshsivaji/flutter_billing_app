// To parse this JSON data, do
//
//     final allCollectionPathModel = allCollectionPathModelFromJson(jsonString);

import 'dart:convert';

AllCollectionPathModel allCollectionPathModelFromJson(String str) => AllCollectionPathModel.fromJson(json.decode(str));

String allCollectionPathModelToJson(AllCollectionPathModel data) => json.encode(data.toJson());

class AllCollectionPathModel {
    int status;
    List<Datum> data;

    AllCollectionPathModel({
        required this.status,
        required this.data,
    });

    factory AllCollectionPathModel.fromJson(Map<String, dynamic> json) => AllCollectionPathModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String? name;

    Datum({
        required this.id,
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['id'],
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
    };
}

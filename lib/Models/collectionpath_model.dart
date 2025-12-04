// To parse this JSON data, do
//
//     final collectionPathModel = collectionPathModelFromJson(jsonString);

import 'dart:convert';

CollectionPathModel collectionPathModelFromJson(String str) => CollectionPathModel.fromJson(json.decode(str));

String collectionPathModelToJson(CollectionPathModel data) => json.encode(data.toJson());

class CollectionPathModel {
    int status;
    List<Datum> data;

    CollectionPathModel({
        required this.status,
        required this.data,
    });

    factory CollectionPathModel.fromJson(Map<String, dynamic> json) => CollectionPathModel(
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
    int store;

    Datum({
        required this.id,
        required this.name,
        required this.store,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['id'],
        name: json['name'] ?? '',
        store: json['store'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name ?? '',
        'store': store,
    };
}

// To parse this JSON data, do
//
//     final collectionUserModel = collectionUserModelFromJson(jsonString);

import 'dart:convert';

CollectionUserModel collectionUserModelFromJson(String str) => CollectionUserModel.fromJson(json.decode(str));

String collectionUserModelToJson(CollectionUserModel data) => json.encode(data.toJson());

class CollectionUserModel {
    int status;
    List<Datum> data;

    CollectionUserModel({
        required this.status,
        required this.data,
    });

    factory CollectionUserModel.fromJson(Map<String, dynamic> json) => CollectionUserModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int userId;
    String name;

    Datum({
        required this.userId,
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json['user_id'],
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
    };
}

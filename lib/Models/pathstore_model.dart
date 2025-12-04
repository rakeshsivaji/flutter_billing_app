// To parse this JSON data, do
//
//     final pathStoreModel = pathStoreModelFromJson(jsonString);

import 'dart:convert';

PathStoreModel pathStoreModelFromJson(String str) => PathStoreModel.fromJson(json.decode(str));

String pathStoreModelToJson(PathStoreModel data) => json.encode(data.toJson());

class PathStoreModel {
    int status;
    List<Datum> data;

    PathStoreModel({
        required this.status,
        required this.data,
    });

    factory PathStoreModel.fromJson(Map<String, dynamic> json) => PathStoreModel(
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
    String name;
    String pathName;

    Datum({
        required this.id,
        required this.name,
        required this.pathName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['id'],
        name: json['name'],
        pathName: json['path_name'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'path_name': pathName,
    };
}

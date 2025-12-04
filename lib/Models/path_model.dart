// To parse this JSON data, do
//
//     final pathModel = pathModelFromJson(jsonString);

import 'dart:convert';

PathModel pathModelFromJson(String str) => PathModel.fromJson(json.decode(str));

String pathModelToJson(PathModel data) => json.encode(data.toJson());

class PathModel {
    int status;
    List<Datum> data;

    PathModel({
        required this.status,
        required this.data,
    });

    factory PathModel.fromJson(Map<String, dynamic> json) => PathModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int pathId;
    String name;
    int storeCount;

    Datum({
        required this.pathId,
        required this.name,
        required this.storeCount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        pathId: json['path_id'],
        name: json['name'],
        storeCount: json['store_count'],
    );

    Map<String, dynamic> toJson() => {
        'path_id': pathId,
        'name': name,
        'store_count': storeCount,
    };
}

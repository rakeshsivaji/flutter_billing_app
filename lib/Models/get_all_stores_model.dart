// To parse this JSON data, do
//
//     final getAllStoresModel = getAllStoresModelFromJson(jsonString);

import 'dart:convert';

GetAllStoresModel getAllStoresModelFromJson(String str) =>
    GetAllStoresModel.fromJson(json.decode(str));

String getAllStoresModelToJson(GetAllStoresModel data) =>
    json.encode(data.toJson());

class GetAllStoresModel {
  int? status;
  List<Datum>? data;

  GetAllStoresModel({
    this.status,
    this.data,
  });

  factory GetAllStoresModel.fromJson(Map<String, dynamic> json) =>
      GetAllStoresModel(
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
  int? id;
  String? name;
  String? pathName;

  Datum({
    this.id,
    this.name,
    this.pathName,
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

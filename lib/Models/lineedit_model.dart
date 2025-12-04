// To parse this JSON data, do
//
//     final lineeditModel = lineeditModelFromJson(jsonString);

import 'dart:convert';

LineeditModel lineeditModelFromJson(String str) =>
    LineeditModel.fromJson(json.decode(str));

String lineeditModelToJson(LineeditModel data) => json.encode(data.toJson());

class LineeditModel {
  int status;
  Data data;

  LineeditModel({
    required this.status,
    required this.data,
  });

  factory LineeditModel.fromJson(Map<String, dynamic> json) => LineeditModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  int lineId;
  String name;
  String status;

  Data({
    required this.lineId,
    required this.name,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lineId: json['line_id'],
        name: json['name'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'line_id': lineId,
        'name': name,
        'status': status,
      };
}

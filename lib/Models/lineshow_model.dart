// To parse this JSON data, do
//
//     final lineshowModel = lineshowModelFromJson(jsonString);

import 'dart:convert';

LineshowModel lineshowModelFromJson(String str) =>
    LineshowModel.fromJson(json.decode(str));

String lineshowModelToJson(LineshowModel data) => json.encode(data.toJson());

class LineshowModel {
  int status;
  List<Datum> data;

  LineshowModel({
    required this.status,
    required this.data,
  });

  factory LineshowModel.fromJson(Map<String, dynamic> json) => LineshowModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int lineId;
  String name;
  int employeeCount;
  String status;

  Datum({
    required this.lineId,
    required this.name,
    required this.employeeCount,
    required this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lineId: json['line_id'],
        name: json['name'],
        employeeCount: json['employee_count'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'line_id': lineId,
        'name': name,
        'employee_count': employeeCount,
        'status': status,
      };
}

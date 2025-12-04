// To parse this JSON data, do
//
//     final getNoAccessUsersLines = getNoAccessUsersLinesFromJson(jsonString);

import 'dart:convert';

GetNoAccessUsersLines getNoAccessUsersLinesFromJson(String str) =>
    GetNoAccessUsersLines.fromJson(json.decode(str));

String getNoAccessUsersLinesToJson(GetNoAccessUsersLines data) =>
    json.encode(data.toJson());

class GetNoAccessUsersLines {
  int? status;
  List<Datum>? data;

  GetNoAccessUsersLines({
    this.status,
    this.data,
  });

  factory GetNoAccessUsersLines.fromJson(Map<String, dynamic> json) =>
      GetNoAccessUsersLines(
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
  int? lineId;
  String? name;

  Datum({
    this.lineId,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lineId: json['line_id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'line_id': lineId,
        'name': name,
      };
}

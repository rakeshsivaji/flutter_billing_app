// To parse this JSON data, do
//
//     final getNoAccessUsersAndLine = getNoAccessUsersAndLineFromJson(jsonString);

import 'dart:convert';
GetNoAccessUsersAndLine getNoAccessUsersAndLineFromJson(String str) =>
    GetNoAccessUsersAndLine.fromJson(json.decode(str));

String getNoAccessUsersAndLineToJson(GetNoAccessUsersAndLine data) =>
    json.encode(data.toJson());

class GetNoAccessUsersAndLine {
  int? status;
  List<NoAccessUsersAndLines>? data;

  GetNoAccessUsersAndLine({
    this.status,
    this.data,
  });

  factory GetNoAccessUsersAndLine.fromJson(Map<String, dynamic> json) =>
      GetNoAccessUsersAndLine(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<NoAccessUsersAndLines>.from(json['data']!.map((x) => NoAccessUsersAndLines.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NoAccessUsersAndLines {
  int? userId;
  String? name;

  NoAccessUsersAndLines({
    this.userId,
    this.name,
  });

  factory NoAccessUsersAndLines.fromJson(Map<String, dynamic> json) => NoAccessUsersAndLines(
        userId: json['user_id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
      };
}

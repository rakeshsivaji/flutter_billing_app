// To parse this JSON data, do
//
//     final userLinesModel = userLinesModelFromJson(jsonString);

import 'dart:convert';

UserLinesModel userLinesModelFromJson(String str) => UserLinesModel.fromJson(json.decode(str));

String userLinesModelToJson(UserLinesModel data) => json.encode(data.toJson());

class UserLinesModel {
    int status;
    List<Datum> data;

    UserLinesModel({
        required this.status,
        required this.data,
    });

    factory UserLinesModel.fromJson(Map<String, dynamic> json) => UserLinesModel(
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

    Datum({
        required this.lineId,
        required this.name,
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

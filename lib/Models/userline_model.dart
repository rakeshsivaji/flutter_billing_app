// To parse this JSON data, do
//
//     final userlineModel = userlineModelFromJson(jsonString);

import 'dart:convert';

UserlineModel userlineModelFromJson(String str) => UserlineModel.fromJson(json.decode(str));

String userlineModelToJson(UserlineModel data) => json.encode(data.toJson());

class UserlineModel {
    int status;
    List<Datum> data;

    UserlineModel({
        required this.status,
        required this.data,
    });

    factory UserlineModel.fromJson(Map<String, dynamic> json) => UserlineModel(
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
    bool isStart;
    String lineStatus;
    String startedBy;
    bool start;
    bool completed;
    bool disable;

    Datum({
        required this.lineId,
        required this.name,
        required this.isStart,
        required this.lineStatus,
        required this.startedBy,
        required this.start,
        required this.completed,
        required this.disable,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        lineId: json['line_id'],
        name: json['name'],
        isStart: json['is_start'],
        lineStatus: json['line_status'],
        startedBy: json['started_by'],
        start: json['start'],
        completed: json['completed'],
        disable: json['disable'],
    );

    Map<String, dynamic> toJson() => {
        'line_id': lineId,
        'name': name,
        'is_start': isStart,
        'line_status': lineStatus,
        'started_by': startedBy,
        'start': start,
        'completed': completed,
        'disable': disable,
    };
}

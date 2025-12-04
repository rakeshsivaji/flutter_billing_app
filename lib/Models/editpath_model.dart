// To parse this JSON data, do
//
//     final editPathModel = editPathModelFromJson(jsonString);

import 'dart:convert';

EditPathModel editPathModelFromJson(String str) => EditPathModel.fromJson(json.decode(str));

String editPathModelToJson(EditPathModel data) => json.encode(data.toJson());

class EditPathModel {
    int status;
    Data data;

    EditPathModel({
        required this.status,
        required this.data,
    });

    factory EditPathModel.fromJson(Map<String, dynamic> json) => EditPathModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    int pathId;
    String name;

    Data({
        required this.pathId,
        required this.name,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        pathId: json['path_id'],
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'path_id': pathId,
        'name': name,
    };
}

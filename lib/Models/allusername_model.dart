// To parse this JSON data, do
//
//     final allUserNameModel = allUserNameModelFromJson(jsonString);

import 'dart:convert';

AllUserNameModel allUserNameModelFromJson(String str) => AllUserNameModel.fromJson(json.decode(str));

String allUserNameModelToJson(AllUserNameModel data) => json.encode(data.toJson());

class AllUserNameModel {
    int status;
    List<Datum> data;

    AllUserNameModel({
        required this.status,
        required this.data,
    });

    factory AllUserNameModel.fromJson(Map<String, dynamic> json) => AllUserNameModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int userId;
    String name;

    Datum({
        required this.userId,
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json['user_id'],
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
    };
}

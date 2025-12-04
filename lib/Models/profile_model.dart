// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    int status;
    Data data;

    ProfileModel({
        required this.status,
        required this.data,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    int userId;
    String name;
    String phone;
    String image;

    Data({
        required this.userId,
        required this.name,
        required this.phone,
        required this.image,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json['user_id'],
        name: json['name'],
        phone: json['phone'],
        image: json['image'],
    );

    Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'phone': phone,
        'image': image,
    };
}

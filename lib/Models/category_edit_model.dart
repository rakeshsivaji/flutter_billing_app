// To parse this JSON data, do
//
//     final editCategoryModel = editCategoryModelFromJson(jsonString);

import 'dart:convert';

EditCategoryModel editCategoryModelFromJson(String str) =>
    EditCategoryModel.fromJson(json.decode(str));

String editCategoryModelToJson(EditCategoryModel data) =>
    json.encode(data.toJson());

class EditCategoryModel {
  int status;
  Data data;

  EditCategoryModel({
    required this.status,
    required this.data,
  });

  factory EditCategoryModel.fromJson(Map<String, dynamic> json) =>
      EditCategoryModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
      };
}

class Data {
  int categoryId;
  String name;
  String image;
  String status;

  Data({
    required this.categoryId,
    required this.name,
    required this.image,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categoryId: json['category_id'],
        name: json['name'],
        image: json['image'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
        'image': image,
        'status': status,
      };
}

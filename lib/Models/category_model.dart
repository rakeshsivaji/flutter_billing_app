// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  int status;
  List<Datum>? data;

  CategoryModel({
    required this.status,
    this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        status: json['status'],
        data: (json['data'] != null)
            ? List<Datum>.from(json['data'].map((x) => Datum.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': (data != null)
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : null,
      };
}

class Datum {
  int categoryId;
  String name;
  String image;

  Datum({
    required this.categoryId,
    required this.name,
    required this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json['category_id'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
        'image': image,
      };
}

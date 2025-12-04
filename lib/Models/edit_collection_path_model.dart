// To parse this JSON data, do
//
//     final editCollectionPathModel = editCollectionPathModelFromJson(jsonString);

import 'dart:convert';

EditCollectionPathModel editCollectionPathModelFromJson(String str) => EditCollectionPathModel.fromJson(json.decode(str));

String editCollectionPathModelToJson(EditCollectionPathModel data) => json.encode(data.toJson());

class EditCollectionPathModel {
    int status;
    Data data;

    EditCollectionPathModel({
        required this.status,
        required this.data,
    });

    factory EditCollectionPathModel.fromJson(Map<String, dynamic> json) => EditCollectionPathModel(
        status: json['status'],
        data: Data.fromJson(json['data']),
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.toJson(),
    };
}

class Data {
    String? pathName;
    List<Store> store;

    Data({
        required this.pathName,
        required this.store,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        pathName: json['path_name'],
        store: List<Store>.from(json['store'].map((x) => Store.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'path_name': pathName,
        'store': List<dynamic>.from(store.map((x) => x.toJson())),
    };
}

class Store {
    int id;
    String name;
    bool status;

    Store({
        required this.id,
        required this.name,
        required this.status,
    });

    factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['id'],
        name: json['name'],
        status: json['status'],
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
    };
}

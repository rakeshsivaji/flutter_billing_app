// To parse this JSON data, do
//
//     final individualBillModel = individualBillModelFromJson(jsonString);

import 'dart:convert';

IndividualBillModel individualBillModelFromJson(String str) => IndividualBillModel.fromJson(json.decode(str));

String individualBillModelToJson(IndividualBillModel data) => json.encode(data.toJson());

class IndividualBillModel {
    int status;
    List<Datum> data;
    String downloadUrl;

    IndividualBillModel({
        required this.status,
        required this.data,
        required this.downloadUrl,
    });

    factory IndividualBillModel.fromJson(Map<String, dynamic> json) => IndividualBillModel(
        status: json['status'],
        data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
        downloadUrl: json['download_url'],
    );

    Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
        'download_url': downloadUrl,
    };
}

class Datum {
    int storeId;
    String pathName;
    String name;
    String ownerName;
    String address;
    String phone;

    Datum({
        required this.storeId,
        required this.pathName,
        required this.name,
        required this.ownerName,
        required this.address,
        required this.phone,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        storeId: json['store_id'],
        pathName: json['path_name'],
        name: json['name'],
        ownerName: json['owner_name'],
        address: json['address'],
        phone: json['phone'],
    );

    Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'path_name': pathName,
        'name': name,
        'owner_name': ownerName,
        'address': address,
        'phone': phone,
    };
}

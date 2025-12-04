// To parse this JSON data, do
//
//     final pathClosedModel = pathClosedModelFromJson(jsonString);

import 'dart:convert';

PathClosedModel pathClosedModelFromJson(String str) =>
    PathClosedModel.fromJson(json.decode(str));

String pathClosedModelToJson(PathClosedModel data) =>
    json.encode(data.toJson());

class PathClosedModel {
  int status;
  List<PathDatum> pathData;

  PathClosedModel({
    required this.status,
    required this.pathData,
  });

  factory PathClosedModel.fromJson(Map<String, dynamic> json) =>
      PathClosedModel(
        status: json['status'],
        pathData: List<PathDatum>.from(
            json['PathData'].map((x) => PathDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'PathData': List<dynamic>.from(pathData.map((x) => x.toJson())),
      };
}

class PathDatum {
  String pathId;
  String pathName;

  PathDatum({
    required this.pathId,
    required this.pathName,
  });

  factory PathDatum.fromJson(Map<String, dynamic> json) => PathDatum(
        pathId: json['path_id'],
        pathName: json['path_name'],
      );

  Map<String, dynamic> toJson() => {
        'path_id': pathId,
        'path_name': pathName,
      };
}

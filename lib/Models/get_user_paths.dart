class GetUserPaths {
  int? status;
  List<PathData>? data;

  GetUserPaths({this.status, this.data});

  factory GetUserPaths.fromJson(Map<String, dynamic> json) {
    return GetUserPaths(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => PathData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class PathData {
  int? id;
  String? name;

  PathData({this.id, this.name});

  factory PathData.fromJson(Map<String, dynamic> json) {
    return PathData(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

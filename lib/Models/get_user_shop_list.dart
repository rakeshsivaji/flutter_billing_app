class GetUserShopList {
  int? status;
  List<ShopData>? data;

  GetUserShopList({this.status, this.data});

  factory GetUserShopList.fromJson(Map<String, dynamic> json) {
    return GetUserShopList(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ShopData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class ShopData {
  int? id;
  String? name;
  String? pathName;

  ShopData({this.id, this.name, this.pathName});

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      id: json['id'],
      name: json['name'],
      pathName: json['path_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path_name': pathName,
    };
  }
}

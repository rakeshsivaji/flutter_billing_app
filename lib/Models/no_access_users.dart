// To parse this JSON data, do
//
//     final getNoAccessUsers = getNoAccessUsersFromJson(jsonString);

import 'dart:convert';

List<GetNoAccessUsers> getNoAccessUsersFromJson(String str) =>
    List<GetNoAccessUsers>.from(
        json.decode(str).map((x) => GetNoAccessUsers.fromJson(x)));

String getNoAccessUsersToJson(List<GetNoAccessUsers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetNoAccessUsers {
  int? userId;
  String? name;

  GetNoAccessUsers({
    this.userId,
    this.name,
  });

  factory GetNoAccessUsers.fromJson(Map<String, dynamic> json) =>
      GetNoAccessUsers(
        userId: json['user_id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
      };
}

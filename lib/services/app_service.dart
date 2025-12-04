import 'package:billing_app/Models/get_user_paths.dart';
import 'package:billing_app/Models/get_user_shop_list.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppServiceUtils {
  Future<GetUserShopList?> getUserShopList(
      {Function(GetUserShopList response)? callBack, String? pathId});

  Future<GetUserPaths?> getUserPaths({
    Function(GetUserPaths response)? callBack,
  });
}

class AppServiceUtilsImpl extends AppServiceUtils {
  Dio dio = Dio();

  @override
  Future<GetUserShopList?> getUserShopList(
      {Function(GetUserShopList response)? callBack, String? pathId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .get('${CommonService().baseUrl}/collection-store?path_id=$pathId');
      GetUserShopList getUserShopList = GetUserShopList.fromJson(response.data);
      callBack?.call(getUserShopList);
      return getUserShopList;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<GetUserPaths?> getUserPaths(
      {Function(GetUserPaths response)? callBack}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await dio.get('${CommonService().baseUrl}/user-collection-path');
      GetUserPaths getUserPaths = GetUserPaths.fromJson(response.data);
      callBack?.call(getUserPaths);
      return getUserPaths;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

// ignore_for_file: avoid_print, depend_on_referenced_packages, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:billing_app/admin/createproducts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, String> defaultHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  ///Release URL
  String baseUrl = 'https://garudaagencies.in/api/V1';
  
  /// Use Flutter's built-in debug mode for conditional logging
  bool get debug => kDebugMode;

  Future<dynamic> signin(Map map) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', false);
    var response = await openPost('signin', map);
    dynamic responseJson = getResponse(response);
    bool status = (responseJson['status'] == 1) ? true : false;
    if (status) {
      prefs.setBool('isLoggedIn', status);
      prefs.setString('userType', responseJson['type']);
      prefs.setString('userId', responseJson['customer_id'].toString());
      prefs.setString('token', responseJson['token']);
    }
    return responseJson;
  }

  Future<dynamic> isSignedIn() async {
    final SharedPreferences prefs = await _prefs;
    dynamic response;
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      response = await getproductsdetails(isLoggedIn);
      if (response['status'] == 1) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
        prefs.setBool('isLoggedIn', false);
        prefs.setString('userId', '');
        prefs.setString('token', '');
      }
    }
    return isLoggedIn;
  }

  Future<dynamic> isSignedIn2() async {
    final SharedPreferences prefs = await _prefs;
    dynamic response;
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      response = await getallPath(isLoggedIn);
      if (response['status'] == 1) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
        prefs.setBool('isLoggedIn', false);
        prefs.setString('userId', '');
        prefs.setString('token', '');
      }
    }
    return isLoggedIn;
  }

  Future<dynamic> getproductsdetails(isLoggedIn) async {
    dynamic response;
    if (isLoggedIn) {
      response = await get('product');
    }
    return getResponse(response);
  }

  Future<dynamic> getallPath(isLoggedIn) async {
    dynamic response;
    if (isLoggedIn) {
      response = await get('all-path');
    }
    return getResponse(response);
  }

  Future<dynamic> isSignedInLite() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  Future<dynamic> getPrefData() async {
    final SharedPreferences prefs = await _prefs;
    Map map = {
      'user_name': prefs.getString('userName'),
      'token': prefs.getString('token'),
      'id': prefs.getString('userId'),
      'is_logged_in': prefs.getBool('isLoggedIn'),
    };
    return map;
  }

  Future<dynamic> signout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', false);
    prefs.setString('userId', '');
    prefs.setString('token', '');
    return true;
  }

  Future<dynamic> signup(Map map) async {
    var response = await openPost('signup', map);
    return getResponse(response);
  }

  Future<dynamic> addWishlist(String id) async {
    dynamic response = await post(url: 'wishlist?job_id=' + id);
    return getResponse(response);
  }

  Future<bool> checkOnboarding() async {
    final SharedPreferences prefs = await _prefs;
    String label = 'isOnboarded';
    final bool status = prefs.getBool(label) ?? false;
    if (!status) {
      prefs.setBool(label, true);
    }
    return status;
  }

  Future<bool> checkIsLoggedIn() async {
    var response = await get('auth-check');
    dynamic responseJson = getResponse(response);
    if (responseJson['status'] != 2) {
      return true;
    }
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', false);
    prefs.setString('token', '');
    return false;
  }

  Future<bool> logout() async {
    final SharedPreferences prefs = await _prefs;
    var response = await post(url: 'logout');
    getResponse(response);
    prefs.setBool('isLoggedIn', false);
    prefs.setString('token', '');
    return true;
  }

  Future<Map> getUserDetails() async {
    Map<String, dynamic> data = {};
    final SharedPreferences prefs = await _prefs;
    data['userId'] = prefs.getString('userId');
    data['type'] = prefs.getString('type');
    data['photo'] = prefs.getString('photo');
    data['phone'] = prefs.getString('phone');
    data['email'] = prefs.getString('email');
    return data;
  }

  Future<dynamic> forgotPassword(Map map) async {
    var response = await openPost('forgot-password', map);
    return getResponse(response);
  }

  Future<dynamic> updateProfile({required Map updatedData, Map? file}) async {
    final SharedPreferences prefs = await _prefs;
    var response =
        await postWithFiles(url: 'profile', map: updatedData, files: file);
    print(response);
    return getResponse(response);
  }

  Future<dynamic> getAccountDetails() async {
    dynamic response;
    response = await get('profile');
    return getResponse(response);
  }

  Future<dynamic> changePassword(Map map) async {
    var response = await post(url: 'change-password', map: map);
    dynamic responseJson = getResponse(response);
    bool status = (responseJson['status'] == 1) ? true : false;
    if (status) {
      // prefs.setString('token', responseJson['new_token']);
    }
    return responseJson;
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    final bool status = prefs.getBool('isLoggedIn') ?? false;
    final String token = prefs.getString('token') ?? '';
    if (status && token.isNotEmpty) {
      return token;
    }
    return '';
  }

  Future<dynamic> sendOtp(Map map) async {
    var response = await openPost('forgot-password', map);
    return getResponse(response);
  }

  Future<dynamic> resetpassword(Map map) async {
    var response = await openPost('password', map);
    return getResponse(response);
  }

  Future<dynamic> getCategory({String? search}) async {
    dynamic response;
    search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;
    response = await get('category' + url);
    return getResponse(response);
  }

  Future<dynamic> getallCategory() async {
    dynamic response;

    response = await get('all-category');
    return getResponse(response);
  }

  Future<dynamic> getCategoryEdit(String id) async {
    dynamic response;
    response = await get('category/' + id);
    return getResponse(response);
  }

  Future<dynamic> createCategory(Map newData, Map? file) async {
    var response =
        await postWithFiles(url: 'category', map: newData, files: file);
    return getResponse(response);
  }

  Future<dynamic> updateCategory(Map newData, Map? file, String id) async {
    var response =
        await postWithFiles(url: 'category/' + id, map: newData, files: file);
    return getResponse(response);
  }

  Future<dynamic> deleteCategory(String id) async {
    var response = await post(url: 'category/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> allProduct({String? search}) async {
    dynamic response;
    search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;
    response = await get('product' + url);
    return getResponse(response);
  }

  Future<dynamic> deleteProduct(String id) async {
    var response = await post(url: 'product/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> CreateProduct(Map details, Map? file) async {
    var response =
        await postWithFiles(url: 'product', map: details, files: file);
    return getResponse(response);
  }

  // Future<dynamic> updateProduct(Map details, String id) async {
  //   var response = await post(url: 'product/' + id, map: details);
  //   return getResponse(response);
  // }

  Future<dynamic> updateProduct(String id, Map newData, Map? file) async {
    var response =
        await postWithFiles(url: 'product/' + id, map: newData, files: file);
    print(response);
    return getResponse(response);
  }

  Future<dynamic> getProductEdit(String id) async {
    dynamic response;
    response = await get('product/' + id);
    return getResponse(response);
  }

  Future<dynamic> profileEdit(String id) async {
    dynamic response;
    response = await get('profile/' + id);
    return getResponse(response);
  }

  Future<dynamic> allProductEdit(String id) async {
    dynamic response;
    response = await get('product/' + id);
    return getResponse(response);
  }

  Future<dynamic> getPathStore(String id) async {
    debugPrint('the id is  *****0 $id');
    dynamic response;
    response = await get('path-store/' + id);
    return getResponse(response);
  }

  Future<dynamic> getallbills({
    String? shopName,
    String? startDate,
    String? endDate,
    String? pathId,
    String? storeId,
  }) async {
    Map<String, String> queryParams = {};

    if (shopName != null && shopName.isNotEmpty) {
      queryParams['search'] = shopName;
    }
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['end_date'] = endDate;
    }
    if (pathId != null && pathId.isNotEmpty) {
      queryParams['path_id'] = pathId;
    }
    if (storeId != null && storeId.isNotEmpty) {
      queryParams['store_id'] = storeId;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint =
        'total-bill${queryString.isNotEmpty ? '?$queryString' : ''}';

    dynamic response = await get(endpoint);
    return getResponse(response);
  }

  Future<dynamic> getbillHistory(
    String? startDate,
    String? endDate, {
    String? shopName,
    String? storeId,
    String? pathId,
  }) async {
    Map<String, String> queryParams = {};

    if (startDate != null && startDate.isNotEmpty) {
      queryParams['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['end_date'] = endDate;
    }
    if (shopName != null && shopName.isNotEmpty) {
      queryParams['filter'] = shopName;
    }
    if (pathId != null && pathId.isNotEmpty) {
      queryParams['path_id'] = pathId;
    }
    if (storeId != null && storeId.isNotEmpty) {
      queryParams['store_id'] = storeId;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint =
        'bill-entry${queryString.isNotEmpty ? '?$queryString' : ''}';

    dynamic response = await get(endpoint);
    return getResponse(response);
  }

  Future<dynamic> downloadReport(
      String type, String startDate, String endDate) async {
    dynamic response;
    response = await get(
        'report-download?report=$type&start_date=$startDate&end_date=$endDate');
    return getResponse(response);
  }

  Future<dynamic> getShop({
    String? search,
    String? pathId,
    String? shopId,
  }) async {
    Map<String, String> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (pathId != null && pathId.isNotEmpty) {
      queryParams['store_id'] = pathId;
    }
    if (shopId != null && shopId.isNotEmpty) {
      queryParams['path_id'] = shopId;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint = 'store${queryString.isNotEmpty ? '?$queryString' : ''}';

    dynamic response = await get(endpoint);
    return getResponse(response);
  }

  Future<dynamic> createShop(Map details) async {
    var response = await post(url: 'store', map: details);
    return getResponse(response);
  }

  Future<dynamic> editproductAmount(Map details) async {
    var response = await post(url: 'store-product', map: details);
    return getResponse(response);
  }

  Future<dynamic> editproductAmount2(
      String id, String Amount, String storeid) async {
    var response = await post(
        url:
            'store-product-update?product_id=${id}&amount=${Amount}&store_id=${storeid}');
    return getResponse(response);
  }

  Future<dynamic> getEditShop(String id) async {
    dynamic response;
    response = await get('store/' + id);
    return getResponse(response);
  }

  Future<dynamic> getcreateshop() async {
    dynamic response;
    response = await get('store-create-product');
    return getResponse(response);
  }

  Future<dynamic> updateShop(Map details, String id) async {
    var response = await post(url: 'store/' + id, map: details);
    return getResponse(response);
  }

  Future<dynamic> deleteShop(String id) async {
    var response = await post(url: 'store/' + id + '/delete');
    return getResponse(response);
  }

//getallbills
  Future<dynamic> getPath({String? search}) async {
    dynamic response;
    search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;
    response = await get('path' + url);
    return getResponse(response);
  }

  Future<dynamic> getAdminPayBill({String? pathId, String? shopId}) async {
    Map<String, String> queryParams = {};

    if (shopId != null && shopId.isNotEmpty) {
      queryParams['store_id'] = shopId;
    }
    if (pathId != null && pathId.isNotEmpty) {
      queryParams['path_id'] = pathId;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint =
        'bill-pay${queryString.isNotEmpty ? '?$queryString' : ''}';

    dynamic response = await get(endpoint);
    return getResponse(response);
  }

  Future<dynamic> getPathEdit(String id) async {
    dynamic response;
    response = await get('path/' + id);
    return getResponse(response);
  }

  Future<dynamic> getstockbillHistory() async {
    dynamic response;
    response = await get('stock-history');
    return getResponse(response);
  }

  Future<dynamic> createPath(Map details) async {
    var response = await post(url: 'path', map: details);
    return getResponse(response);
  }

  Future<dynamic> updatePath(Map details, String id) async {
    var response = await post(url: 'path/' + id, map: details);
    return getResponse(response);
  }

  Future<dynamic> deletePath(String id) async {
    var response = await post(url: 'path/' + id + '/delete');
    return getResponse(response);
  }

  // Future<dynamic> getreportDownload(String startdate,String enddate,String type) async {
  //   dynamic response;
  //   response = await get('report-download?report=$type&start_date=$startdate&end_date=$enddate');
  //   return getResponse(response);
  // }

  // Future<File?> getreportDownload(
  //     String startDate, String endDate, String type) async {
  //   String url =
  //       'report-download?report=$type&start_date=$startDate&end_date=$endDate';

  //   try {
  //     http.Response response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       Directory? directory = await getExternalStorageDirectory();

  //       String fileName =
  //           'report_$type${DateTime.now().millisecondsSinceEpoch}.pdf';

  //       File file = File('${directory?.path}/$fileName');

  //       await file.writeAsBytes(response.bodyBytes);

  //       return file;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error downloading report: $e');
  //     return null;
  //   }
  // }

  Future<dynamic> getAllCollectionPath({String? id}) async {
    dynamic response;
    String url = 'all-collection-path';
    if (id != null || id?.isNotEmpty == true) {
      url += '?id=$id';
    }
    response = await get(url);
    return getResponse(response);
  }

  Future<dynamic> createsavedpath(Map map) async {
    dynamic response;
    response = await post(url: 'collection-path', map: map);
    return getResponse(response);
  }

  Future<dynamic> updateSavedPath(String pathId, String storeIds,
      {String? orderStoreIds, String? pathName}) async {
    dynamic response;
    response = await post(
        url: 'collection-path/' +
            pathId +
            '?stores_id=' +
            storeIds +
            '&order_store_id=' +
            (orderStoreIds ?? '') +
            '&path_name=' +
            (pathName ?? ''));
    return getResponse(response);
  }

  Future<dynamic> deleteCollectionPath(String id) async {
    var response = await post(url: 'collection-path/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> createIndBill(Map map) async {
    dynamic response;
    response = await post(url: 'individual-bill', map: map);
    return getResponse(response);
  }

  Future<dynamic> getIndBill(
      {String? search, String? pathId, String? shopId}) async {
    Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (pathId != null && pathId.isNotEmpty) {
      queryParams['store_id'] = pathId;
    }
    if (shopId != null && shopId.isNotEmpty) {
      queryParams['path_id'] = shopId;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint =
        'individual-bill${queryString.isNotEmpty ? '?$queryString' : ''}';
    dynamic response = await get(endpoint);
    return getResponse(response);
  }

  Future<dynamic> getBillType() async {
    dynamic response;
    response = await get('bill-type');
    return getResponse(response);
  }

  Future<dynamic> getReport(
      {String? type, String? startDate, String? endDate}) async {
    dynamic response;
    // type = (type == null) ? 'all' : type;
    // search = (search == null) ? '' : search;
    dynamic url = 'report=' + type.toString();
    url += startDate == ''
        ? ''
        : '&start_date=' +
            startDate.toString() +
            '&end_date=' +
            endDate.toString();
    response = await get('report?' + url);
    return getResponse(response);
  }

  Future<dynamic> getallbuildentry({
    String? type,
    String? startDate,
    String? endDate,
    String? storeName,
  }) async {
    String? shopName;
    if (storeName == 'All') {
      shopName = '';
    } else {
      shopName = storeName;
    }
    dynamic response;
    String url = 'bill-entry?';
    if (type != null && type.isNotEmpty) {
      url += 'report=' + type.toString();
    }
    if (endDate != null && endDate.isNotEmpty) {
      url += (url.endsWith('?') ? '' : '&') + 'end_date=' + endDate.toString();
    }
    if (startDate != null && startDate.isNotEmpty) {
      url +=
          (url.endsWith('?') ? '' : '&') + 'start_date=' + startDate.toString();
    }
    if (shopName != null && shopName.isNotEmpty) {
      url += (url.endsWith('?') ? '' : '&') + 'filter=' + shopName.toString();
    }
    response = await get(url);
    return getResponse(response);
  }

  Future<dynamic> getAdminProfile() async {
    dynamic response;
    response = await get('profile');
    return getResponse(response);
  }

  Future<dynamic> getUserProfile() async {
    dynamic response;
    response = await get('profile');
    return getResponse(response);
  }

  Future<dynamic> getEmploye({String? search}) async {
    dynamic response;
    search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;
    response = await get('user' + url);
    return getResponse(response);
  }

  Future<dynamic> createEmployee(Map newData, Map? file) async {
    var response = await postWithFiles(url: 'user', map: newData, files: file);
    print(response);
    return getResponse(response);
  }

  Future<dynamic> getEmployeeDetails(String id) async {
    dynamic response;
    response = await get('user/' + id);
    return getResponse(response);
  }

  Future<dynamic> getAllEmployee() async {
    dynamic response;
    response = await get('line-user-name');
    return getResponse(response);
  }

  Future<dynamic> updateEmployee(Map newData, Map? file, String id) async {
    var response =
        await postWithFiles(url: 'user/' + id, map: newData, files: file);
    return getResponse(response);
  }

  Future<dynamic> deleteEmployee(String id) async {
    var response = await post(url: 'user/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> getLineshow() async {
    dynamic response;
    response = await get('line');
    return getResponse(response);
  }

  Future<dynamic> getEditline(String id) async {
    dynamic response;
    response = await get('line/' + id);
    return getResponse(response);
  }

  Future<dynamic> createline(Map newdata) async {
    var response = await post(url: 'line', map: newdata);
    return getResponse(response);
  }

  Future<dynamic> updateline(String id, Map newdata) async {
    var response = await post(url: 'line/' + id, map: newdata);
    return getResponse(response);
  }

  Future<dynamic> linecompleted(String id) async {
    var response = await post(url: 'user-line-complete/' + id);
    return getResponse(response);
  }

  Future<dynamic> lineStart(String id) async {
    var response = await post(url: 'user-line-start/' + id);
    return getResponse(response);
  }

  Future<dynamic> userlineshow() async {
    dynamic response;
    response = await get('user-line');
    return getResponse(response);
  }

  Future<dynamic> userlinestock(String id) async {
    dynamic response;
    response = await get('user-line-stock/' + id);
    return getResponse(response);
  }

  Future<dynamic> getlinePendingReport() async {
    dynamic response;
    response = await get('all-line-pending');
    return getResponse(response);
  }

  Future<dynamic> getShopPendingReport(String id,
      {String? search, String? pathId, String? storeId}) async {
    dynamic response;

    List<String> queryParams = [];
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (pathId != null && pathId.isNotEmpty) queryParams.add('path_id=$pathId');
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';

    response = await get('shop-pending-product/' + id + url);
    return getResponse(response);
  }

  Future<dynamic> linestockreport(String id,
      {String? startDate, String? userId}) async {
    dynamic response;
    dynamic url = startDate == '' ? '' : '?start_date=' + startDate.toString();
    dynamic url1 = userId == null ? '' : '&user_id=' + userId.toString();
    response = await get('user-line-stock-report/' + id + url + url1);
    return getResponse(response);
  }

  Future<dynamic> userCollectionReport(
      {String? startDate,
      String? userId,
      String? startTime,
      String? endTime}) async {
    /*dynamic response;
    dynamic url = startDate == '' ? '' : '?start_date=' + startDate.toString();
    dynamic url1 = userId == null ? '' : '&user_id=' + userId.toString();
    response = await get('collection-amount-report-user' + url + url1);*/

    Map<String, String> queryParams = {};
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['start_date'] = startDate;
    }
    if (userId != null && userId.isNotEmpty) {
      queryParams['user_id'] = userId;
    }
    if (startTime != null && startTime.isNotEmpty) {
      queryParams['start_time'] = startTime;
    }
    if (endTime != null && endTime.isNotEmpty) {
      queryParams['end_time'] = endTime;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    String endpoint =
        'collection-amount-report-user${queryString.isNotEmpty ? '?$queryString' : ''}';
    dynamic response = await get(endpoint);

    return getResponse(response);
  }

  Future<dynamic> getUserLines({String? date, String? userId}) async {
    dynamic response;
    dynamic url = date == '' ? '' : '?date=' + date.toString();
    dynamic url1 = userId == null ? '' : '&user_id=' + userId.toString();
    response = await get('user-line-data' + url + url1);
    return getResponse(response);
  }

  // Future<dynamic> getReport(
  //     {String? type, String? startDate, String? endDate}) async {
  //   dynamic response;
  //   // type = (type == null) ? 'all' : type;
  //   // search = (search == null) ? '' : search;
  //   dynamic url = 'report=' + type.toString();
  //   url += startDate == ''
  //       ? ''
  //       : '&start_date=' +
  //           startDate.toString() +
  //           '&end_date=' +
  //           endDate.toString();
  //   response = await get('report?' + url);
  //   return getResponse(response);
  // }

  Future<dynamic> getCollectionPath({String? search}) async {
    dynamic response;
    search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;
    response = await get('collection-path' + url);
    return getResponse(response);
  }

  Future<dynamic> getEditCollectionPath(String id) async {
    dynamic response;
    response = await get('collection-path/' + id);
    return getResponse(response);
  }

  Future<dynamic> getCollectionUser() async {
    dynamic response;
    response = await get('collection-user');
    return getResponse(response);
  }

  Future<dynamic> getNoAccessUsers() async {
    dynamic response;
    response = await get('line-start-user');
    return getResponse(response);
  }

  Future<dynamic> getNoAccessUsersLines({String? userId}) async {
    dynamic response;
    response = await get('user-start-line?user_id=$userId');
    return getResponse(response);
  }

  Future<dynamic> getShopsBalanceAmount(
      {String? sortOrder, String? search, String? filter}) async {
    dynamic response;
    List<String> queryParams = [];
    if (sortOrder != null && sortOrder.isNotEmpty)
      queryParams.add('sort_order=$sortOrder');
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (filter != null && filter.isNotEmpty) queryParams.add('filter=$filter');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('pending-amount-shop$url');
    return getResponse(response);
  }

  Future<dynamic> getOrderdelivery(
      {String? search, String? storeid, String? filter}) async {
    dynamic response;
    List<String> queryParams = [];
    if (filter != null && filter.isNotEmpty) queryParams.add('search=$filter');
    if (search == '0') {
      queryParams.add('');
    } else if (search != null && search.isNotEmpty) {
      queryParams.add('filter=$search');
    }
    if (storeid != null && storeid.isNotEmpty)
      queryParams.add('store_id=$storeid');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('order-delivery' + url);
    return getResponse(response);
  }

  Future<dynamic> getUserIndividualBills(String id) async {
    dynamic response;
    response = await get('user-individual-bill/1' /* + id*/);
    return getResponse(response);
  }

  Future<dynamic> getOrderList(String id) async {
    dynamic response;
    response = await get('order-list/' + id);
    return getResponse(response);
  }

  Future<dynamic> getTomorrowOrderList(String id) async {
    dynamic response;
    response = await get('tomorrow-order-list/' + id);
    return getResponse(response);
  }

  Future<dynamic> getPendingOrderList(String id) async {
    dynamic response;
    response = await get('pending-order/' + id);
    return getResponse(response);
  }

  Future<dynamic> getPendingLineStocks(String id) async {
    dynamic response;
    response = await get('pending-order/' + id);
    return getResponse(response);
  }

  Future<dynamic> createOrderList(Map details) async {
    var response = await post(url: 'order-list', map: details);
    return getResponse(response);
  }

  Future<dynamic> orderstockList(Map? map) async {
    var response = await post(url: 'order-stock-list', map: map);
    return getResponse(response);
  }

  Future<dynamic> pendingorderstockList(Map? map) async {
    var response = await post(url: 'order-stock-pending-list', map: map);
    return getResponse(response);
  }

  Future<dynamic> orderstockConfirm(String storeId, String lineId) async {
    var response = await post(
        url: 'order-stock-list-confirm/' + storeId + '?line_id=' + lineId);
    return getResponse(response);
  }

  Future<dynamic> deleteOrderList(String id) async {
    var response = await post(url: 'order-list/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> deletestockOrderList(String id) async {
    var response = await post(url: 'order-stock-list/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> deleteAllOrderList(String id, {String? selectedDay}) async {
    if (selectedDay == 'இன்று') {
      selectedDay = 'today';
    } else if (selectedDay == 'நாளை') {
      selectedDay = 'tomorrow';
    }
    var response =
        await post(url: 'all-order-list-delete/$id?day=${selectedDay ?? ''}');
    return getResponse(response);
  }

  Future<dynamic> deleteAllOrderListForAdminAndUser(String id,
      {String? selectedDay}) async {
    if (selectedDay == 'இன்று') {
      selectedDay = 'today';
    } else if (selectedDay == 'நாளை') {
      selectedDay = 'tomorrow';
    }
    var response =
        await post(url: 'total-order-list-delete/$id?day=${selectedDay ?? ''}');
    return getResponse(response);
  }

  Future<dynamic> orderConfirm(String Id, String storeId) async {
    var response =
        await post(url: 'order-confirm/' + storeId + '?list_id=' + Id);
    return getResponse(response);
  }

  Future<dynamic> pendingOrderConfirm(String storeId, String productId) async {
    var response =
        await post(url: 'pending-confirm/' + storeId + '?list_id=' + productId);
    return getResponse(response);
  }

  Future<dynamic> getOrderDetails(String id) async {
    dynamic response;
    response = await get('bill-entry/' + id);
    return getResponse(response);
  }

  Future<dynamic> orderPayment(String id, String amount) async {
    var response = await post(url: 'bill-payment/' + id + '?amount=' + amount);
    return getResponse(response);
  }

  Future<dynamic> getStockList() async {
    dynamic response;
    response = await get('admin-stock');
    return getResponse(response);
  }

  Future<dynamic> getStockListline(String id) async {
    dynamic response;
    response = await get('user-stock/' + id);
    return getResponse(response);
  }

  Future<dynamic> getAdminStockList() async {
    dynamic response;
    response = await get('admin-stock');
    return getResponse(response);
  }

  Future<dynamic> getIndividualbillShow(String id,
      {String? startDate, String? endDate}) async {
    dynamic response;
    dynamic url = startDate == null
        ? ''
        : '?start_date=' +
            startDate.toString() +
            '&end_date=' +
            endDate.toString();
    response = await get('individual-bill/' + id + url);
    return getResponse(response);
  }

  Future<dynamic> getStock() async {
    dynamic response;
    response = await get('stock');
    return getResponse(response);
  }

  Future<dynamic> getIndividualBillsReceipt() async {
    dynamic response;
    response = await get('shop-today-individual-bill');
    return getResponse(response);
  }

  Future<dynamic> getStockHistory({String? startDate, String? endDate}) async {
    dynamic response;
    dynamic url = startDate == null
        ? ''
        : '?start_date=' +
            startDate.toString() +
            '&end_date=' +
            endDate.toString();
    response = await get('stock-history' + url);
    return getResponse(response);
  }

  Future<dynamic> deleteStock(String id) async {
    var response = await post(url: 'stock/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> userstockconfirm(String id) async {
    var response = await post(url: 'user-stock-confirm?line_id=' + id);
    return getResponse(response);
  }

  Future<dynamic> confirmStock(Map map) async {
    var response = await post(url: 'stock-confirm', map: map);
    return getResponse(response);
  }

  Future<dynamic> createStockOrderList(Map details) async {
    var response = await post(url: 'stock-order-list', map: details);
    return getResponse(response);
  }

  Future<dynamic> createStockList(Map details) async {
    dynamic response = await post(url: 'stock', map: details);
    return getResponse(response);
  }

  Future<dynamic> getAdminStockListShow(
      {String? search, String? storeId}) async {
    dynamic response;
    // search = (search == null) ? '' : search;
    // storeId = (storeId == null) ? '' : storeId;
    // dynamic url = (search == '') ? '?category_id=' : '?category_id=' + search;
    // dynamic url1 = (search == '') ? '' : '&store_id=' + storeId;
    List<String> queryParams = [];
    if (search == '0') {
      queryParams.add('');
    } else if (search != null && search.isNotEmpty) {
      queryParams.add('category_id=$search');
    }
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('order-stock-list-admin-product' + url);
    return getResponse(response);
  }

  Future<dynamic> getStockOrderList(String id) async {
    dynamic response;
    response = await get('stock-order-list/' + id);
    return getResponse(response);
  }

  Future<dynamic> getStockPendingOrderList(String id) async {
    dynamic response;
    response = await get('stock-list-pending-order/' + id);
    return getResponse(response);
  }

  Future<dynamic> confirmStockOrderList(String ids, String id) async {
    var response =
        await post(url: 'stock-list-order-confirm/' + id + '?list_id=' + ids);
    return getResponse(response);
  }

  Future<dynamic> deleteStockOrderList(String id) async {
    var response = await post(url: 'stock-order-list/' + id + '/delete');
    return getResponse(response);
  }

  Future<dynamic> confirmPendingStockOrderList(String id, String ids) async {
    var response = await post(
      url: 'stock-pending-confirm/' + id + '?list_id=' + ids,
    );
    return getResponse(response);
  }

  Future<dynamic> deleteAllStockOrderList(String id) async {
    var response = await post(url: 'all-stock-order-list-delete/' + id);
    return getResponse(response);
  }

  Future<dynamic> deleteProductById(String id, String pId) async {
    var response = await post(url: 'user-stock-product-delete/$id/$pId');
    return getResponse(response);
  }

  Future<dynamic> GetAllBillEntry() async {
    dynamic response;
    response = await get('bill-entry');
    return getResponse(response);
  }

  Future<dynamic> getAllUserBillEntries(
      {String? startDate,
      String? endDate,
      String? shopName,
      String? pathId,
      String? storeId}) async {
    dynamic response;
    List<String> queryParams = [];
    if (shopName == 'All') {
      queryParams.add('');
    } else if (shopName != null && shopName.isNotEmpty) {
      queryParams.add('filter=$shopName');
    }
    if (startDate != null && startDate.isNotEmpty)
      queryParams.add('start_date=$startDate');
    if (endDate != null && endDate.isNotEmpty)
      queryParams.add('end_date=$endDate');
    if (pathId != null && pathId.isNotEmpty) queryParams.add('path_id=$pathId');
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('user-bill-entry' + url);
    return getResponse(response);
  }

  Future<dynamic> getAllStores() async {
    dynamic response;
    response = await get('all-store');
    return getResponse(response);
  }

  Future<dynamic> GetPathBillEntry(String id) async {
    dynamic response;
    response = await get('bill-path-entry/' + id);
    return getResponse(response);
  }

  Future<dynamic> GetBillDetails(String id) async {
    dynamic response;
    response = await get('bill-details/' + id);
    return getResponse(response);
  }

  Future<dynamic> getUserBillDetails({String? ids}) async {
    dynamic response;
    List<String> queryParams = [];
    if (ids != null && ids.isNotEmpty) queryParams.add('bill_ids=$ids');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('user-bill-details' + url);
    return getResponse(response);
  }

  Future<dynamic> GetPathClosed() async {
    dynamic response;
    response = await get('path-close');
    return getResponse(response);
  }

  Future<dynamic> PostPathClosed(String id) async {
    var response = await post(url: 'path-close?path_id=' + id);
    return getResponse(response);
  }

  Future<dynamic> userStockProductAdd(
      String productId, String stockId, String quantity) async {
    var response = await post(
        url:
            'user-stock-product-add/${stockId}?product_id=${productId}&quantity=${quantity}');
    return getResponse(response);
  }

  Future<dynamic> userEnableOrDisable({String? userId, String? status}) async {
    var response = await post(
        url: 'employee-disable/$userId', map: {'disable_status': status});
    return getResponse(response);
  }

  Future<dynamic> getorderreceived(
      {String? search, String? date, String? pathId, String? storeId}) async {
    dynamic response;
    // search = (search == null) ? '' : search;
    // dynamic url = (search == '') ? '' : '?search=' + search;
    // dynamic url1 = date == '' ? '' : '&date=' + date.toString();
    List<String> queryParams = [];
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (date != null && date.isNotEmpty) queryParams.add('date=$date');
    if (pathId != null && pathId.isNotEmpty) queryParams.add('path_id=$pathId');
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('order-received' + url);
    return getResponse(response);
  }

  Future<dynamic> getTomorrowOrderReceived(
      {String? search, String? storeId, String? pathId}) async {
    dynamic response;
    /*search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;*/

    List<String> queryParams = [];
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (pathId != null && pathId.isNotEmpty) queryParams.add('path_id=$pathId');
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';

    response = await get('tomorrow-order-received' + url);
    return getResponse(response);
  }

  Future<dynamic> getPendingOrderReceived(
      {String? search, String? pathId, String? storeId}) async {
    dynamic response;
    /* search = (search == null) ? '' : search;
    dynamic url = (search == '') ? '' : '?search=' + search;*/

    List<String> queryParams = [];
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (pathId != null && pathId.isNotEmpty) queryParams.add('path_id=$pathId');
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';

    response = await get('pending-order-received' + url);
    return getResponse(response);
  }

  Future<dynamic> getNotification() async {
    dynamic response;
    response = await get('notification');
    return getResponse(response);
  }

  Future<dynamic> getshoworderstocklistproduct(
      {String? search, String? storeId}) async {
    dynamic response;
    // search = (search == null) ? '' : search;
    // dynamic url = (search == '') ? '' : '?category_id=' + search;
    List<String> queryParams = [];
    if (search == '0') {
      queryParams.add('');
    } else if (search != null && search.isNotEmpty) {
      queryParams.add('category_id=$search');
    }
    if (storeId != null && storeId.isNotEmpty)
      queryParams.add('store_id=$storeId');
    String queryString =
        queryParams.isNotEmpty ? '?' + queryParams.join('&') : '';
    dynamic url = '$queryString';
    response = await get('order-stock-list-product' + url);
    return getResponse(response);
  }

  Future<dynamic> getorderstocklist(String id, {String? lineId}) async {
    dynamic response;
    String lineIdUrl = '';
    if (lineId?.isNotEmpty == true) {
      lineIdUrl = '/$lineId';
    } else {
      lineIdUrl = '';
    }
    response = await get('order-stock-list/' + id + lineIdUrl);
    return getResponse(response);
  }

  // ----------------------------- Base Routes
  Future<dynamic> delete(String url) async {
    dynamic response;
    var token = await getToken();
    if (debug) {
      print('=========== GET hit =============');
      print('token --> $token');
    }
    if (token.toString().isNotEmpty) {
      defaultHeader['Authorization'] = 'Bearer $token';
      response =
          await http.delete(Uri.parse('$baseUrl/$url'), headers: defaultHeader);
      if (debug) {
        print('is token present ? --> YES !');
        print('header --> $defaultHeader');
        print("url --> ${Uri.parse('$baseUrl/$url')}");
        print('response body --> ${response.body}');
      }
    }
    if (debug) {
      // print("response --> $response");
      print('=========== end GET hit =============');
    }
    return response;
  }

  Future<dynamic> get(String url) async {
    dynamic response;
    var token = await getToken();
    if (debug) {
      print('=========== GET hit =============');
      print('token --> $token');
    }
    if (token.toString().isNotEmpty) {
      defaultHeader['Authorization'] = 'Bearer $token';
      response =
          await http.get(Uri.parse('$baseUrl/$url'), headers: defaultHeader);
      if (debug) {
        print('is token present ? --> YES !');
        print('header --> $defaultHeader');
        print("url --> ${Uri.parse('$baseUrl/$url')}");
        print('response body --> ${response.body}');
      }
    }
    if (debug) {
      // print("response --> $response");
      print('=========== end GET hit =============');
    }
    return response;
  }

  Future<dynamic> post({required String url, Map? map}) async {
    dynamic response;
    var token = await getToken();
    var body = (map != null) ? json.encode(map) : null;
    if (debug) {
      print('=========== POST hit =============');
      print('body --> $body');
    }
    if (token.toString().isNotEmpty) {
      defaultHeader['Authorization'] = 'Bearer $token';
      response = await http.post(Uri.parse('$baseUrl/$url'),
          headers: defaultHeader, body: body);
      if (debug) {
        print('is token present ? --> YES !');
        print('header --> $defaultHeader');
        print("url --> ${Uri.parse('$baseUrl/$url')}");
        print('response --> $response');
        print('response body --> ${response.body}');
      }
    }
    if (debug) {
      print('=========== end POST hit =============');
    }
    return response;
  }

  Future<dynamic> postWithFiles(
      {required String url, Map? map, Map? files}) async {
    var token = await getToken();
    var body = (map != null) ? json.encode(map) : null;
    // var file = (files != null) ? json.encode(files) : null;
    if (debug) {
      print('=========== POST hit =============');
      print('body --> $body');
      // print("files --> $file");
    }
    if (token.toString().isNotEmpty) {
      defaultHeader['Authorization'] = 'Bearer $token';
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/$url'));
      map!.forEach((key, value) {
        request.fields['$key'] = value;
      });
      defaultHeader.forEach((key, value) {
        request.headers[key] = value;
      });
      if (files != null) {
        files.forEach((key, value) async {
          if (value != null) {
            print('is token present ? --> YES ! ${value!.path}');
            request.files.add(await http.MultipartFile.fromPath(
                '$key', '${value!.path}',
                filename: '${value!.name}',
                contentType: MediaType('image', 'jpeg')));
          }
        });
      }
      // request.files.add(await http.MultipartFile.fromPath(
      //     '$key', "${value!.path}",
      //     filename: "${value!.name}", contentType: MediaType('image', 'jpeg')));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (debug) {
        print('is token present ? --> YES !');
        print('header --> $defaultHeader');
        print("url --> ${Uri.parse('$baseUrl/$url')}");
        print('response --> ${response.body}');
        print('response body1 --> ${response.statusCode.toString()}');
      }
      if (debug) {
        print('=========== end POST hit =============');
      }
      return response;
    }
  }

  Future<dynamic> openPost(String url, Map map) async {
    dynamic response;
    var body = json.encode(map);
    if (debug) {
      print('===========OPEN POST hit =============');
      print('body --> $body');
    }
    response = await http.post(Uri.parse('$baseUrl/$url'),
        headers: defaultHeader, body: body);
    if (debug) {
      print('header --> $defaultHeader');
      print("url --> ${Uri.parse('$baseUrl/$url')}");
      print('response --> $response');
      print('response body --> ${response.body}');
      print('=========== end OPEN POST hit =============');
    }
    return response;
  }

  Future<dynamic> openGet(String url) async {
    dynamic response;

    if (debug) {
      print('===========OPEN GET hit =============');
    }
    response =
        await http.get(Uri.parse('$baseUrl/$url'), headers: defaultHeader);
    if (debug) {
      print('header --> $defaultHeader');
      print("url --> ${Uri.parse('$baseUrl/$url')}");
      print('response --> $response');
      print('response body --> ${response.body}');
      print('=========== end OPEN GET hit =============');
    }
    return response;
  }

  dynamic getResponse(dynamic response) {
    dynamic responseJson;
    bool unauthenticated = false;
    if (debug) {
      print('=========== response =============');
    }
    if (response != null) {
      if (response.statusCode == 200) {
        responseJson = json.decode(response.body);
      } else if (response.statusCode == 422) {
        var responseDecoded = json.decode(response.body);
        if (responseDecoded.containsKey('errors')) {
          List keyList = responseDecoded['errors'].keys.toList();
          String message = '';
          keyList.asMap().forEach((i, value) {
            message += "${responseDecoded['errors']["$value"][0]}\n";
          });
          responseJson = {
            'status': 0,
            'message': message.trim(),
          };
        }
      } else if (response.statusCode == 401) {
        unauthenticated = true;
      } else {
        unauthenticated = true;
      }
      if (debug) {
        print('Response ? --> YES !');
        print('code --> ${response.statusCode}');
        print('body --> ${response.body}');
      }
    } else {
      if (debug) {
        print('Response ? --> No Null given');
      }
      unauthenticated = true;
    }
    if (unauthenticated) {
      responseJson = {
        'status': 2,
        'message': 'Unauthenticated',
      };
    }
    if (debug) {
      print('responseJson --> $responseJson');
      print('=========== end response =============');
    }
    return responseJson;
  }
}

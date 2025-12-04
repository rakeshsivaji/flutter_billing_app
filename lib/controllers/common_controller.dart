import 'package:billing_app/Models/Neworderstocklist_model.dart';
import 'package:billing_app/Models/Newstocklist_model.dart';
import 'package:billing_app/Models/admin_pay_bill_model.dart';
import 'package:billing_app/Models/admin_profile_model.dart';
import 'package:billing_app/Models/all_billentry.dart';
import 'package:billing_app/Models/allcollectionpath_model.dart';
import 'package:billing_app/Models/allusername_model.dart';
import 'package:billing_app/Models/billdetails_model.dart';
import 'package:billing_app/Models/billtypemodel.dart';
import 'package:billing_app/Models/category_edit_model.dart';
import 'package:billing_app/Models/category_model.dart';
import 'package:billing_app/Models/collection_user_model.dart';
import 'package:billing_app/Models/collectionpath_model.dart';
import 'package:billing_app/Models/createshop_Model.dart';
import 'package:billing_app/Models/edit_collection_path_model.dart';
import 'package:billing_app/Models/editpath_model.dart';
import 'package:billing_app/Models/editshop_model.dart';
import 'package:billing_app/Models/employee_model.dart';
import 'package:billing_app/Models/employeedetails_model.dart';
import 'package:billing_app/Models/get_access_user_lines.dart';
import 'package:billing_app/Models/get_all_stores_model.dart';
import 'package:billing_app/Models/get_all_user_bill_model.dart';
import 'package:billing_app/Models/get_no_access_users_and_lines.dart';
import 'package:billing_app/Models/get_shops_balance_amount_model.dart';
import 'package:billing_app/Models/get_user_bill_details_model.dart';
import 'package:billing_app/Models/individual_bills_model.dart';
import 'package:billing_app/Models/individualbill_model.dart';
import 'package:billing_app/Models/individualbill_show_model.dart';
import 'package:billing_app/Models/lineedit_model.dart';
import 'package:billing_app/Models/lineshow_model.dart';
import 'package:billing_app/Models/linestockreport_model.dart';
import 'package:billing_app/Models/notification_model.dart';
import 'package:billing_app/Models/orderdelivery_model.dart';
import 'package:billing_app/Models/orderdetails_model.dart';
import 'package:billing_app/Models/orderlist_model.dart';
import 'package:billing_app/Models/path_billentry_model.dart';
import 'package:billing_app/Models/path_closed_model.dart';
import 'package:billing_app/Models/path_model.dart';
import 'package:billing_app/Models/pathstore_model.dart';
import 'package:billing_app/Models/pending_lines_model.dart';
import 'package:billing_app/Models/pending_recieved_order_model.dart';
import 'package:billing_app/Models/pendingorder_model.dart';
import 'package:billing_app/Models/product_edit_model.dart'; // import 'package:billing_app/Models/product_model';
import 'package:billing_app/Models/product_model.dart';
import 'package:billing_app/Models/received_order_model.dart';
import 'package:billing_app/Models/report_model.dart';
import 'package:billing_app/Models/shop_model.dart';
import 'package:billing_app/Models/shop_pending_model.dart';
import 'package:billing_app/Models/stock_history_model.dart';
import 'package:billing_app/Models/stock_model.dart';
import 'package:billing_app/Models/stocklist_model.dart';
import 'package:billing_app/Models/stockorderlist.dart';
import 'package:billing_app/Models/stockpendingorderlist_model.dart';
import 'package:billing_app/Models/tomorrow_received_order_model.dart';
import 'package:billing_app/Models/tomorroworderlist_model.dart';
import 'package:billing_app/Models/totalbills_model.dart';
import 'package:billing_app/Models/user_individual_bill.dart';
import 'package:billing_app/Models/usercollectionreport_model.dart';
import 'package:billing_app/Models/userline_model.dart';
import 'package:billing_app/Models/userlinereport_model.dart';
import 'package:billing_app/Models/userlines_model.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class CommonController extends GetxController {
  var filteredProducts;

  @override
  void onInit() {
    super.onInit();
    getLoginStatus();
  }

  Rx<OrderDeliveryModel?> orderdeliverymodel =
      (null as OrderDeliveryModel?).obs;
  Rx<OrderListModel?> orderListModel = (null as OrderListModel?).obs;
  Rx<UserIndividualBills?> userIndividualBillModel =
      (null as UserIndividualBills?).obs;
  Rx<EditPathModel?> editPathModel = (null as EditPathModel?).obs;
  Rx<EmployeeDetailsModel?> employeeDetailsModel =
      (null as EmployeeDetailsModel?).obs;
  Rx<EditShopModel?> editShopModel = (null as EditShopModel?).obs;
  Rx<CreateshopModel?> createShopModel = (null as CreateshopModel?).obs;
  Rx<IndividualBillModel?> individualBillModel =
      (null as IndividualBillModel?).obs;
  Rx<AllCollectionPathModel?> allCollectionPathModel =
      (null as AllCollectionPathModel?).obs;

  Rx<BillTypeModel?> billTypeModel = (null as BillTypeModel?).obs;
  Rx<NewStockListModel?> newstocklistmodel = (null as NewStockListModel?).obs;
  Rx<OrderstockListModel?> orderstocklistmodel =
      (null as OrderstockListModel?).obs;
  Rx<ReportModel?> reportModel = (null as ReportModel?).obs;
  Rx<PathStoreModel?> pathStoreModel = (null as PathStoreModel?).obs;
  RxList billType = <String>[].obs;
  Rx<PendingOrderModel?> pendingOrderModel = (null as PendingOrderModel?).obs;

  // Rx<OrderReceivedModel?> orderreceivedModel = (null as OrderReceivedModel?).obs;
  Rx<TomorrowOrderListModel?> tomorrowOrderListModel =
      (null as TomorrowOrderListModel?).obs;
  Rx<OrderDetailsModel?> orderDetailsModel = (null as OrderDetailsModel?).obs;

  Rx<OrderReceivedModel?> receivedorderModel =
      (null as OrderReceivedModel?).obs;

  Rx<PendingRecievedOrderModel?> pendingRecievedOrderModel =
      (null as PendingRecievedOrderModel?).obs;
  Rx<TomorrowRecievedOrderModel?> tomorrowRecievedOrderModel =
      (null as TomorrowRecievedOrderModel?).obs;
  Rx<NotificationModel?> notificationModel = (null as NotificationModel?).obs;

  Rx<StockListModel?> stockListModel = (null as StockListModel?).obs;
  Rx<AllBillEntryModel?> allbillentry = (null as AllBillEntryModel?).obs;

  Rx<StockOrderListModel?> stockOrderListModel =
      (null as StockOrderListModel?).obs;
  Rx<IndividualBillsModel?> individualBillsModel =
      (null as IndividualBillsModel?).obs;
  Rx<StockModel?> stockModel = (null as StockModel?).obs;
  Rx<StockHistoryModel?> stockHistoryModel = (null as StockHistoryModel?).obs;
  Rx<IndividualBillShowModel?> individualShow =
      (null as IndividualBillShowModel?).obs;
  Rx<StockPendingOrderListModel?> stockPendingOrderListModel =
      (null as StockPendingOrderListModel?).obs;
  Rx<EditCollectionPathModel?> editCollectionPathModel =
      (null as EditCollectionPathModel?).obs;

  Rx<GetNoAccessUsersAndLine?> getNoAccessUsersAndLine =
      (null as GetNoAccessUsersAndLine?).obs;

  Rx<GetNoAccessUsersLines?> getNoAccessUsersLinesModel =
      (null as GetNoAccessUsersLines?).obs;

  Rx<GetShopsBalanceAmountModel?> getShopsBalanceAmountModel =
      (null as GetShopsBalanceAmountModel?).obs;

  Rx<LineshowModel?> lineshowmodel = (null as LineshowModel?).obs;
  Rx<LineeditModel?> lineeditmodel = (null as LineeditModel?).obs;
  Rx<UserlineModel?> userlinemodel = (null as UserlineModel?).obs;
  Rx<AllUserNameModel?> allUserNameModel = (null as AllUserNameModel?).obs;
  Rx<UserlinereportModel?> userlinereportmodel =
      (null as UserlinereportModel?).obs;
  Rx<LinestockreportModel?> linestockreportmodel =
      (null as LinestockreportModel?).obs;
  Rx<UserCollectionReportModel?> userCollectionReportModel =
      (null as UserCollectionReportModel?).obs;
  Rx<CollectionUserModel?> collectionUserModel =
      (null as CollectionUserModel?).obs;

  // RxMap? postData = {}.obs;
  // Rx<CategoryModel?> categorymodel = (null as CategoryModel?).obs;
  // Rx<PlanModel?> planmodel = (null as PlanModel?).obs;
  // Rx<PlanDetailsModel?> plandetailsmodel = (null as PlanDetailsModel?).obs;
  // Rx<PaymentDetailsModel?> paymentdetailsmodel =
  //     (null as PaymentDetailsModel?).obs;

  RxMap? allPathId = {}.obs;
  RxMap? allPath = {}.obs;
  RxMap? categoryId = {}.obs;
  RxMap? categoryName = {}.obs;
  RxMap? pathId = {}.obs;
  RxMap? pathName = {}.obs;
  RxMap? billId = {}.obs;
  RxMap? billName = {}.obs;
  RxMap? storeId = {}.obs;
  RxMap? lineId = {}.obs;
  RxMap? linename = {}.obs;
  RxMap? storeName = {}.obs;
  RxMap? allStoreId = {}.obs;
  RxMap? allStoreName = {}.obs;
  RxMap? employeeId = {}.obs;
  RxMap? employeeName = {}.obs;
  RxMap? collectionUserId = {}.obs;
  RxMap? collectionUserName = {}.obs;
  Rx<CategoryModel?> categorymodel = (null as CategoryModel?).obs;
  Rx<EditCategoryModel?> categoryeditmodel = (null as EditCategoryModel?).obs;
  Rx<ProductModel?> productmodel = (null as ProductModel?).obs;
  Rx<ProductEditModel?> producteditmodel = (null as ProductEditModel?).obs;
  Rx<ShopModel?> shopsmodel = (null as ShopModel?).obs;
  Rx<PathModel?> pathmodel = (null as PathModel?).obs;
  Rx<AdminPayBillModel?> adminPayBillModel = (null as AdminPayBillModel?).obs;
  Rx<AdminProfileModel?> adminprofilemodel = (null as AdminProfileModel?).obs;
  Rx<EmployeeModel?> employeemodel = (null as EmployeeModel?).obs;
  Rx<CollectionPathModel?> collectionpathmodel =
      (null as CollectionPathModel?).obs;
  Rx<PathBillEntryModel?> pathbillentrymodel =
      (null as PathBillEntryModel?).obs;
  Rx<AllBillEntryModel?> allbillentrymodel = (null as AllBillEntryModel?).obs;
  Rx<GetAllUserBillModel?> getAllUserBillModel =
      (null as GetAllUserBillModel?).obs;
  Rx<GetAllStoresModel?> getAllStoresModel = (null as GetAllStoresModel?).obs;
  Rx<GetUserBillDetailsModel?> getUserBillDetailsModel =
      (null as GetUserBillDetailsModel?).obs;
  Rx<BillDetailsModel?> billdetailsmodel = (null as BillDetailsModel?).obs;
  Rx<PathClosedModel?> pathclosedmodel = (null as PathClosedModel?).obs;
  Rx<StockHistoryModel?> stockhistorymodel = (null as StockHistoryModel?).obs;
  Rx<TotalBillsModel?> totalbillsModel = (null as TotalBillsModel?).obs;
  Rx<ShopPendingModel?> shopPendingModel = (null as ShopPendingModel?).obs;
  Rx<PendingLinesModel?> pendingLinesModel = (null as PendingLinesModel?).obs;
  Rx<UserLinesModel?> userLinesModel = (null as UserLinesModel?).obs;
  RxBool stockHistory = false.obs;
  RxBool getExistingBills = false.obs;
  RxBool stock = false.obs;
  RxBool stockOrderList = false.obs;
  RxBool pendingStockOrder = false.obs;
  RxBool orderList = false.obs;
  RxBool tomorrowList = false.obs;
  RxBool pendingList = false.obs;
  RxBool stockList = false.obs;
  RxBool notification = false.obs;
  RxBool orderRecieved = false.obs;
  RxBool tomorrowOrderRecieved = false.obs;
  RxBool pendingOrderRecieved = false.obs;
  RxBool individualBill = false.obs;
  RxBool collectionPath = false.obs;
  RxBool orderdelivery = false.obs;
  RxBool newstockorderlist = false.obs;
  RxBool userline = false.obs;
  RxBool linereport = false.obs;
  RxBool userlinereport = false.obs;
  RxBool stockproductview = false.obs;
  double? scrollPosition;

  //TotalBillsModel

  RxBool isLoading = false.obs;

  void getLoginStatus() async {
    bool loggedIn = await CommonService().isSignedIn();
    getAdminProfile();
    getUserProfile();
    print('getLoginStatus');
    print(loggedIn.toString());

    // getHomeDetails(loggedIn);
  }

  void homeUpdater() {
    getLoginStatus();
    update();
  }

  Future<bool> getCategories({required bool withLoader, String? search}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    categoryName?.clear();
    categoryId?.clear();
    dynamic response = await CommonService().getCategory(search: search);
    if (response['status'] == 1) {
      categorymodel.value = CategoryModel.fromJson(response);
      for (dynamic item in categorymodel.value!.data!) {
        categoryName?.addEntries({item.categoryId: item.name}.entries);
        categoryId?.addEntries({item.name: item.categoryId}.entries);
      }
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getallCategories(
      {required bool withLoader, String? search}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getallCategory();
    if (response['status'] == 1) {
      categorymodel.value = CategoryModel.fromJson(response);
      for (dynamic item in categorymodel.value!.data!) {
        categoryName?.addEntries({item.categoryId: item.name}.entries);
        categoryId?.addEntries({item.name: item.categoryId}.entries);
      }
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  void getCategoriesUpdater() async {
    await getCategories(withLoader: false);
  }

  Future<bool> getCategoriesEdit(String id) async {
    bool status = false;
    dynamic response = await CommonService().getCategoryEdit(id);
    if (response['status'] == 1) {
      categoryeditmodel.value = EditCategoryModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getallProduct({required bool withLoader, String? search}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().allProduct(search: search);
    if (response['status'] == 1) {
      productmodel.value = ProductModel.fromJson(response);
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  void getProductUpdater() async {
    await getallProduct(withLoader: false);
  }

  Future<bool> getallProductEdit(String id) async {
    bool status = false;
    dynamic response = await CommonService().allProductEdit(id);
    if (response['status'] == 1) {
      producteditmodel.value = ProductEditModel.fromJson(response);
      status = true;
    }
    return status;
  }

//TotalBillsModel

  Future<bool> getTotalbills({required bool withLoader,
    String? search,
    String? startDate,
    String? endDate,
    String? pathId,
    String? storeId}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getallbills(
        shopName: search,
        startDate: startDate,
        endDate: endDate,
        pathId: pathId,
        storeId: storeId);
    if (response['status'] == 1) {
      totalbillsModel.value = TotalBillsModel.fromJson(response);
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getallShops() async {
    bool status = false;
    dynamic response = await CommonService().getShop();
    if (response['status'] == 1) {
      shopsmodel.value = ShopModel.fromJson(response);
      status = true;
    }
    return status;
  }

  //AllBillEntryModel
  Future<bool> getallorder() async {
    bool status = false;
    dynamic response = await CommonService().getShop();
    if (response['status'] == 1) {
      allbillentry.value = AllBillEntryModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getShops({required bool withLoader,
    String? search,
    String? pathId,
    String? shopId}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    allStoreName?.clear();
    allStoreId?.clear();
    dynamic response = await CommonService()
        .getShop(search: search, pathId: pathId, shopId: shopId);
    if (response['status'] == 1) {
      shopsmodel.value = ShopModel.fromJson(response);
      for (dynamic item in shopsmodel.value!.data) {
        allStoreName?.addEntries({item.storeId: item.name}.entries);
        allStoreId?.addEntries({item.name: item.storeId}.entries);
      }
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  void getShopUpdater() async {
    await getShops(withLoader: false);
  }

  Future<bool> getPathStore(String id) async {
    bool status = false;
    storeName?.clear();
    storeId?.clear();
    dynamic response = await CommonService().getPathStore(id);
    if (response['status'] == 1) {
      pathStoreModel.value = PathStoreModel.fromJson(response);
      for (dynamic item in pathStoreModel.value!.data) {
        storeName?.addEntries({item.id: item.name}.entries);
        storeId?.addEntries({item.name: item.id}.entries);
      }
      status = true;
    } else {
      storeName?.clear();
      storeId?.clear();
    }
    return status;
  }

  Future<bool> getEditShop(String id) async {
    bool status = false;
    dynamic response = await CommonService().getEditShop(id);
    if (response['status'] == 1) {
      editShopModel.value = EditShopModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getcreateshop() async {
    bool status = false;
    dynamic response = await CommonService().getcreateshop();
    if (response['status'] == 1) {
      createShopModel.value = CreateshopModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getPath({required bool withLoader, String? search}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    pathName?.clear();
    pathId?.clear();
    dynamic response = await CommonService().getPath(search: search);
    if (response['status'] == 1) {
      pathmodel.value = PathModel.fromJson(response);
      for (dynamic item in pathmodel.value!.data) {
        pathName?.addEntries({item.pathId: item.name}.entries);
        pathId?.addEntries({item.name: item.pathId}.entries);
      }
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getAdminPayBillList({String? pathId, String? shopId,
  Function(int statusCode)? onSuccessCallBack}) async {
    bool status = false;
    dynamic response = await CommonService().getAdminPayBill(pathId: pathId,
        shopId: shopId);
    if (response['status'] == 1) {
      adminPayBillModel.value = AdminPayBillModel.fromJson(response);
      onSuccessCallBack?.call(response['status']);
      status = true;
    }else if(response['status'] == 0){
      onSuccessCallBack?.call(response['status']);
    }else{
      onSuccessCallBack?.call(5);
    }
    return status;
  }

  void getPathUpdater() async {
    await getPath(withLoader: false);
  }

  Future<bool> getAllPath() async {
    bool status = false;
    dynamic response = await CommonService().getPath();
    if (response['status'] == 1) {
      pathmodel.value = PathModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getPathEdit(String id) async {
    bool status = false;
    dynamic response = await CommonService().getPathEdit(id);
    if (response['status'] == 1) {
      editPathModel.value = EditPathModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getstockkhistory(String id) async {
    bool status = false;
    dynamic response = await CommonService().getstockbillHistory();
    if (response['status'] == 1) {
      editPathModel.value = EditPathModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getAllColectionPath({String? id}) async {
    bool status = false;
    allPath?.clear();
    allPathId?.clear();
    dynamic response = await CommonService().getAllCollectionPath(id: id);
    if (response['status'] == 1) {
      allCollectionPathModel.value = AllCollectionPathModel.fromJson(response);
      for (dynamic item in allCollectionPathModel.value!.data) {
        allPath?.addEntries({item.id: item.name}.entries);
        allPathId?.addEntries({item.name: item.id}.entries);
      }
      status = true;
    }
    return status;
  }

  Future<bool> getReport({String? type,
    String? startDate,
    String? endDate,
    Function(int status)? onCallBackFunction}) async {
    bool status = false;
    dynamic response = await CommonService()
        .getReport(type: type, startDate: startDate, endDate: endDate);
    if (response['status'] == 1) {
      reportModel.value = ReportModel.fromJson(response);
      status = true;
      onCallBackFunction?.call(response['status']);
    } else {
      onCallBackFunction?.call(response['status']);
    }

    return status;
  }

  Future<bool> getbillhistory({String? startDate,
    String? endDate,
    Function(int statusCode)? functionCallBack,
    String? shopName,
    String? pathId,
    String? storeId}) async {
    bool status = false;
    dynamic response = await CommonService().getbillHistory(startDate, endDate,
        shopName: shopName, storeId: storeId, pathId: pathId);
    if (response['status'] == 1) {
      totalbillsModel.value = TotalBillsModel.fromJson(response);
      functionCallBack?.call(response['status']);
      status = true;
    } else if (response['status'] == 0) {
      totalbillsModel.value = null;
      functionCallBack?.call(response['status']);
      status = true;
    }
    functionCallBack?.call(response['status']);
    // if (withLoader) {
    //   isLoading(false);
    // }
    return status;
  }

  Future<bool> getallbuildentry({String? type,
    String? startDate,
    String? endDate,
    String? filter}) async {
    bool status = false;
    dynamic response = await CommonService().getallbuildentry(
        type: type, startDate: startDate, endDate: endDate, storeName: filter);
    if (response['status'] == 1) {
      allbillentrymodel.value = AllBillEntryModel.fromJson(response);
      status = true;
      getExistingBills(true);
    } else {
      getExistingBills(false);
    }
    return status;
  }

  Future<bool> getAdminProfile() async {
    bool status = false;
    dynamic response = await CommonService().getAdminProfile();
    if (response['status'] == 1) {
      print('1111');
      adminprofilemodel.value = AdminProfileModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getUserProfile() async {
    bool status = false;
    dynamic response = await CommonService().getUserProfile();
    if (response['status'] == 1) {
      adminprofilemodel.value = AdminProfileModel.fromJson(response);
      status = true;
    } else {
      adminprofilemodel.value = AdminProfileModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getEmployee({required bool withLoader, String? search}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getEmploye(search: search);
    if (response['status'] == 1) {
      employeemodel.value = EmployeeModel.fromJson(response);
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getEmployeeDetails(String id) async {
    bool status = false;
    dynamic response = await CommonService().getEmployeeDetails(id);
    if (response['status'] == 1) {
      employeeDetailsModel.value = EmployeeDetailsModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getAllEmployee() async {
    bool status = false;
    employeeName?.clear();
    employeeId?.clear();
    dynamic response = await CommonService().getAllEmployee();
    if (response['status'] == 1) {
      allUserNameModel.value = AllUserNameModel.fromJson(response);
      for (dynamic item in allUserNameModel.value!.data) {
        employeeName?.addEntries({item.userId: item.name}.entries);
        employeeId?.addEntries({item.name: item.userId}.entries);
      }
      status = true;
    }
    return status;
  }

  Future<bool> getCollectionPath({String? search}) async {
    bool status = false;
    dynamic response = await CommonService().getCollectionPath(search: search);
    if (response['status'] == 1) {
      collectionpathmodel.value = CollectionPathModel.fromJson(response);
      collectionPath(true);
      status = true;
    } else {
      collectionPath(false);
    }
    return status;
  }

  Future<bool> getEditCollectionPath(String id,
      {Function(int statusCode)? callBackFunction}) async {
    bool status = false;
    dynamic response = await CommonService().getEditCollectionPath(id);
    if (response['status'] == 1) {
      editCollectionPathModel.value =
          EditCollectionPathModel.fromJson(response);
      status = true;
      callBackFunction?.call(response['status']);
    } else if (response['status'] == 0) {
      callBackFunction?.call(response['status']);
    }
    return status;
  }

  Future<bool> getNoAccessUsers(
      {Function(int statusCode)? callBackFunction}) async {
    bool status = false;
    dynamic response = await CommonService().getNoAccessUsers();
    if (response['status'] == 1) {
      getNoAccessUsersAndLine.value =
          GetNoAccessUsersAndLine.fromJson(response);
      status = true;
      callBackFunction?.call(response['status']);
    } else if (response['status'] == 0) {
      callBackFunction?.call(response['status']);
    }
    return status;
  }

  Future<bool> getNoAccessUsersLines(
      {String? userId, Function(int statusCode)? callBackFunction}) async {
    bool status = false;
    dynamic response =
    await CommonService().getNoAccessUsersLines(userId: userId);
    if (response['status'] == 1) {
      getNoAccessUsersLinesModel.value =
          GetNoAccessUsersLines.fromJson(response);
      status = true;
      callBackFunction?.call(response['status']);
    } else if (response['status'] == 0) {
      callBackFunction?.call(response['status']);
    }
    return status;
  }

  Future<bool> getShopsBalanceAmount({required bool withLoader,
    String? search,
    String? sortOrder,
    String? filter,
    Function(int statusCode)? callBackFunction}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getShopsBalanceAmount(
        search: search, sortOrder: sortOrder, filter: filter);
    if (response['status'] == 1) {
      getShopsBalanceAmountModel.value =
          GetShopsBalanceAmountModel.fromJson(response);
      status = true;
      callBackFunction?.call(response['status']);
    } else if (response['status'] == 0) {
      callBackFunction?.call(response['status']);
    }
    return status;
  }

  Future<bool> getOrderDelivery({required bool withLoader,
    String? search,
    String? storeid,
    String? filter}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService()
        .getOrderdelivery(search: search, storeid: storeid, filter: filter);
    if (response['status'] == 1) {
      orderdeliverymodel.value = OrderDeliveryModel.fromJson(response);
      orderdelivery(true);
      status = true;
    } else {
      orderdelivery(false);
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getshoworderstocklist(
      {required bool withLoader, String? search, String? storeId}) async {
    bool status = false;
    if (withLoader) {
      isLoading(true);
    }
    dynamic response = await CommonService()
        .getshoworderstocklistproduct(search: search, storeId: storeId);
    if (response['status'] == 1) {
      newstocklistmodel.value = NewStockListModel.fromJson(response);
      stockproductview(true);
      status = true;
    } else {
      stockproductview(false);
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> Getorderstocklist(String id,
      {Function(int statusCode)? callBackFunction, String? userLineId}) async {
    bool status = false;
    dynamic response =
    await CommonService().getorderstocklist(id, lineId: userLineId);
    if (response['status'] == 1) {
      orderstocklistmodel.value = OrderstockListModel.fromJson(response);
      callBackFunction?.call(response['status']);
      newstockorderlist(true);
      status = true;
    } else {
      callBackFunction?.call(response['status']);
      newstockorderlist(false);
    }

    return status;
  }

  // Future<bool> Getorderstocklist({
  //   required bool withLoader,
  //   String? search,
  //  required String storeid,
  // }) async {
  //   if (withLoader) {
  //     isLoading(true);
  //   }
  //   bool status = false;
  //   dynamic response = await CommonService()
  //       .getorderstocklist(search: search, storeid: storeid);
  //   if (response['status'] == 1) {
  //     orderstocklistmodel.value = OrderstockListModel.fromJson(response);
  //     status = true;
  //   }
  //   if (withLoader) {
  //     isLoading(false);
  //   }
  //   return status;
  // }

  Future<bool> getOrderList(String id,
      {Function(int statusCode)? callBackFunction}) async {
    bool status = false;
    dynamic response = await CommonService().getOrderList(id);
    if (response['status'] == 1) {
      orderListModel.value = OrderListModel.fromJson(response);
      callBackFunction?.call(response['status']);
      orderList(true);
      // orderList = true.obs;
      status = true;
    } else {
      orderList(false);
      callBackFunction?.call(response['status']);
    }

    return status;
  }

  Future<bool> getUserIndividualBills({String? id}) async {
    bool status = false;
    dynamic response = await CommonService().getUserIndividualBills(id ?? '');
    if (response['status'] == 1) {
      userIndividualBillModel.value = UserIndividualBills.fromJson(response);
      // orderList(true);
      // orderList = true.obs;
      status = true;
    } else {
      // orderList(false);
    }

    return status;
  }

  Future<bool> getTomorrowOrderList(String id,
      {Function(int statusCode)? callBackFunction}) async {
    bool status = false;
    dynamic response = await CommonService().getTomorrowOrderList(id);
    if (response['status'] == 1) {
      tomorrowOrderListModel.value = TomorrowOrderListModel.fromJson(response);
      tomorrowList(true);
      callBackFunction?.call(response['status']);
      status = true;
    } else {
      tomorrowList(false);
      callBackFunction?.call(response['status']);
    }
    return status;
  }

  Future<bool> getPendingOrderList(String id) async {
    bool status = false;
    dynamic response = await CommonService().getPendingOrderList(id);
    if (response['status'] == 1) {
      pendingOrderModel.value = PendingOrderModel.fromJson(response);
      pendingList(true);
      status = true;
    } else {
      pendingList(false);
    }
    return status;
  }

  Future<bool> getOrderDetails(String id) async {
    bool status = false;
    dynamic response = await CommonService().getOrderDetails(id);
    if (response['status'] == 1) {
      orderDetailsModel.value = OrderDetailsModel.fromJson(response);
      status = true;
    }else{
      orderDetailsModel.value = null;
    }
    return status;
  }

  Future<bool> getStock({Function(int statusCode)? callBackFunction}) async {
    print('${callBackFunction == null} --- ${callBackFunction != null}');
    bool status = false;
    dynamic response = await CommonService().getStock();
    if (response['status'] == 1) {
      callBackFunction?.call(response['status']);
      stockModel.value = StockModel.fromJson(response);
      stock(true);
      status = true;
    } else if (response['status'] == 0) {
      stock(false);
      callBackFunction?.call(response['status']);
    } else {
      stock(false);
    }
    return status;
  }

  Future<bool> getStockHistory(
      {required bool withLoader, String? startDate, String? endDate}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService()
        .getStockHistory(startDate: startDate, endDate: endDate);
    if (response['status'] == 1) {
      stockHistoryModel.value = StockHistoryModel.fromJson(response);
      status = true;
      stockHistory(true);
    } else {
      stockHistory(false);
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getStockList() async {
    bool status = false;
    dynamic response = await CommonService().getStockList();
    if (response['status'] == 1) {
      stockListModel.value = StockListModel.fromJson(response);
      stockList(true);
      status = true;
    } else {
      stockList(false);
    }
    return status;
  }

  Future<bool> getStockListline(String id) async {
    bool status = false;
    dynamic response = await CommonService().getStockListline(id);
    if (response['status'] == 1) {
      stockListModel.value = StockListModel.fromJson(response);
      stockList(true);
      status = true;
    } else {
      stockList(false);
    }
    return status;
  }

  Future<bool> getAdminStockList() async {
    bool status = false;
    dynamic response = await CommonService().getAdminStockList();
    if (response['status'] == 1) {
      stockListModel.value = StockListModel.fromJson(response);
      stockList(true);
      status = true;
    } else {
      stockList(false);
    }
    return status;
  }

  Future<bool> getAdminStockListShow(
      {required bool withLoader, String? search, String? storeId}) async {
    bool status = false;
    if (withLoader) {
      isLoading(true);
    }
    dynamic response = await CommonService()
        .getAdminStockListShow(search: search, storeId: storeId);
    if (response['status'] == 1) {
      newstocklistmodel.value = NewStockListModel.fromJson(response);
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getStockOrderList(String id,
      {Function(int statusCode)? callBackFunction}) async {
    bool status = false;
    dynamic response = await CommonService().getStockOrderList(id);
    if (response['status'] == 1) {
      stockOrderListModel.value = StockOrderListModel.fromJson(response);
      callBackFunction?.call(response['status']);
      stockOrderList(true);
      status = true;
    } else {
      callBackFunction?.call(response['status']);
      stockOrderList(false);
    }
    return status;
  }

  Future<bool> getIndividualBillsReceipt(
      {Function(int statusCode)? functionCallBack}) async {
    bool status = false;
    dynamic response = await CommonService().getIndividualBillsReceipt();
    if (response['status'] == 1) {
      individualBillsModel.value = IndividualBillsModel.fromJson(response);
      functionCallBack?.call(response['status']);
      status = true;
    } else {
      functionCallBack?.call(response['status']);
    }
    return status;
  }

  Future<bool> getStockPendingOrderList(String id) async {
    bool status = false;
    dynamic response = await CommonService().getStockPendingOrderList(id);
    if (response['status'] == 1) {
      stockPendingOrderListModel.value =
          StockPendingOrderListModel.fromJson(response);
      pendingStockOrder(true);
      status = true;
    } else {
      pendingStockOrder(false);
    }
    return status;
  }

  //individualShow
  Future<bool> getIndividualbillShow(String id,
      {required bool withLoader, String? startDate, String? endDate}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService()
        .getIndividualbillShow(id, startDate: startDate, endDate: endDate);
    if (response['status'] == 1) {
      individualShow.value = IndividualBillShowModel.fromJson(response);
      individualBill(true);
      status = true;
    } else {
      individualBill(false);
    }
    if (withLoader) {
      isLoading(true);
    }
    return status;
  }

  Future<bool> getIndBill({required bool withLoader,
    String? search,
    String? pathId,
    String? shopId}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService()
        .getIndBill(search: search, pathId: pathId, shopId: shopId);
    if (response['status'] == 1) {
      individualBillModel.value = IndividualBillModel.fromJson(response);
      status = true;
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getBillType() async {
    bool status = false;
    dynamic response = await CommonService().getCategory();
    if (response['status'] == 1) {
      billTypeModel.value = BillTypeModel.fromJson(response);
      for (dynamic item in billTypeModel.value!.data) {
        billType.add(item);
      }
      status = true;
    }
    return status;
  }

  Future<bool> getAllBillEntries() async {
    bool status = false;
    dynamic response = await CommonService().GetAllBillEntry();
    if (response['status'] == 1) {
      allbillentrymodel.value = AllBillEntryModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getAllUserBillEntries({String? startDate,
    String? endDate,
    String? shopName,
    String? pathId,
    String? storeId}) async {
    bool status = false;
    dynamic response = await CommonService().getAllUserBillEntries(
        shopName: shopName,
        endDate: endDate,
        startDate: startDate,
        pathId: pathId,
        storeId: storeId);
    if (response['status'] == 1) {
      getAllUserBillModel.value = GetAllUserBillModel.fromJson(response);
      getExistingBills(true);
      status = true;
    } else {
      getExistingBills(false);
    }
    return status;
  }

  Future<bool> getAllBillStores() async {
    bool status = false;
    dynamic response = await CommonService().getAllStores();
    if (response['status'] == 1) {
      getAllStoresModel.value = GetAllStoresModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getPathBillEntries(String id,{String? storeId, String? pathId}) async {
    bool status = false;
    dynamic response = await CommonService().GetPathBillEntry(id);
    if (response['status'] == 1) {
      pathbillentrymodel.value = PathBillEntryModel.fromJson(response);
      status = true;
    } else {
      pathbillentrymodel.value = null;
    }
    return status;
  }

  Future<bool> getBillDetails(String id) async {
    bool status = false;
    dynamic response = await CommonService().GetBillDetails(id);
    if (response['status'] == 1) {
      billdetailsmodel.value = BillDetailsModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getUserBillDetails({String? ids}) async {
    bool status = false;
    dynamic response = await CommonService().getUserBillDetails(ids: ids);
    if (response['status'] == 1) {
      getUserBillDetailsModel.value =
          GetUserBillDetailsModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getPathClosed() async {
    bool status = false;
    dynamic response = await CommonService().GetPathClosed();
    if (response['status'] == 1) {
      pathclosedmodel.value = PathClosedModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getReceivedorder({required bool withLoader,
    String? search,
    String? date,
    String? pathId,
    String? storeId}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getorderreceived(
        search: search, date: date, pathId: pathId, storeId: storeId);
    if (response['status'] == 1) {
      receivedorderModel.value = OrderReceivedModel.fromJson(response);
      orderRecieved(true);
      status = true;
    } else {
      orderRecieved(false);
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getTomorrowReceivedorder({required bool withLoader,
    String? search,
    String? storeId,
    String? pathId}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getTomorrowOrderReceived(
        search: search, storeId: storeId, pathId: pathId);
    if (response['status'] == 1) {
      tomorrowRecievedOrderModel.value =
          TomorrowRecievedOrderModel.fromJson(response);
      tomorrowOrderRecieved(true);
      status = true;
    } else {
      tomorrowOrderRecieved(false);
    }
    if (withLoader) {
      isLoading(false);
    }
    debugPrint('the 2mrw order recived ***** $tomorrowOrderRecieved');
    return status;
  }

  Future<bool> getPendingReceivedorder({required bool withLoader,
    String? search,
    String? pathId,
    String? storeId}) async {
    if (withLoader) {
      isLoading(true);
    }
    bool status = false;
    dynamic response = await CommonService().getPendingOrderReceived(
        search: search, storeId: storeId, pathId: pathId);
    if (response['status'] == 1) {
      pendingRecievedOrderModel.value =
          PendingRecievedOrderModel.fromJson(response);
      pendingOrderRecieved(true);
      status = true;
    } else {
      pendingOrderRecieved(false);
    }
    if (withLoader) {
      isLoading(false);
    }
    return status;
  }

  Future<bool> getNotification() async {
    bool status = false;
    dynamic response = await CommonService().getNotification();
    if (response['status'] == 1) {
      notificationModel.value = NotificationModel.fromJson(response);
      notification(true);
      status = true;
    } else {
      notification(false);
    }
    return status;
  }

  Future<bool> getlineshow() async {
    bool status = false;
    dynamic response = await CommonService().getLineshow();
    if (response['status'] == 1) {
      lineshowmodel.value = LineshowModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getlineedit(String id) async {
    bool status = false;
    dynamic response = await CommonService().getEditline(id);
    if (response['status'] == 1) {
      lineeditmodel.value = LineeditModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getuserline() async {
    bool status = false;
    dynamic response = await CommonService().userlineshow();
    if (response['status'] == 1) {
      userlinemodel.value = UserlineModel.fromJson(response);
      userline(true);
      status = true;
    } else {
      userline(false);
    }
    return status;
  }

  Future<bool> getUserlines({String? date, String? userId}) async {
    bool status = false;
    linename?.clear();
    lineId?.clear();
    dynamic response =
    await CommonService().getUserLines(date: date, userId: userId);
    if (response['status'] == 1) {
      userLinesModel.value = UserLinesModel.fromJson(response);
      for (dynamic item in userLinesModel.value!.data) {
        linename?.addEntries({item.lineId: item.name}.entries);
        lineId?.addEntries({item.name: item.lineId}.entries);
      }
      status = true;
    } else {
      linename?.clear();
      lineId?.clear();
    }
    return status;
  }

  Future<bool> linestockreport(String id,
      {String? startDate, String? userId}) async {
    bool status = false;
    dynamic response = await CommonService()
        .linestockreport(id, startDate: startDate, userId: userId);
    if (response['status'] == 1) {
      linestockreportmodel.value = LinestockreportModel.fromJson(response);
      linereport(true);
      status = true;
    } else {
      linereport(false);
    }
    return status;
  }

  Future<bool> getuserlinereport(String id) async {
    bool status = false;
    dynamic response = await CommonService().userlinestock(id);
    if (response['status'] == 1) {
      userlinereportmodel.value = UserlinereportModel.fromJson(response);
      userlinereport(true);
      status = true;
    } else {
      userlinereport(false);
    }
    return status;
  }

  Future<bool> getlinePendingreport() async {
    bool status = false;
    dynamic response = await CommonService().getlinePendingReport();
    if (response['status'] == 1) {
      pendingLinesModel.value = PendingLinesModel.fromJson(response);
      status = true;
    }
    return status;
  }

  Future<bool> getshopPendingreport(String lineId,
      {String? search,
        Function(int statusCode)? callBackFunction,
        String? pathId,
        String? shopId}) async {
    bool status = false;
    dynamic response = await CommonService().getShopPendingReport(lineId,
        search: search, storeId: shopId, pathId: pathId);
    if (response['status'] == 1) {
      shopPendingModel.value = ShopPendingModel.fromJson(response);
      callBackFunction?.call(response['status']);
      status = true;
    } else {
      status = false;
      callBackFunction?.call(response['status']);
    }
    return status;
  }

  Future<bool> getCollectionUserReport({String? startDate,
    String? userId,
    String? startTime,
    String? endTime,
    Function(int status)? onSuccessCallBack}) async {
    bool status = false;
    dynamic response = await CommonService().userCollectionReport(
        startDate: startDate,
        userId: userId,
        startTime: startTime,
        endTime: endTime);
    if (response['status'] == 1) {
      userCollectionReportModel.value =
          UserCollectionReportModel.fromJson(response);
      status = true;
      onSuccessCallBack?.call(response['status']);
    } else if (response['status'] == 0) {
      onSuccessCallBack?.call(response['status']);
    }
    return status;
  }

  Future<bool> getCollectionUser() async {
    bool status = false;
    dynamic response = await CommonService().getCollectionUser();
    if (response['status'] == 1) {
      collectionUserModel.value = CollectionUserModel.fromJson(response);
      for (dynamic item in collectionUserModel.value!.data) {
        collectionUserName?.addEntries({item.userId: item.name}.entries);
        collectionUserId?.addEntries({item.name: item.userId}.entries);
      }
      status = true;
    }
    return status;
  }

  Future<void> userEnableOrDisable({String? userId,
    String? userStatus,
    Function(int statusCode)? onSuccessCallBack}) async {
    bool status = false;
    dynamic response = await CommonService()
        .userEnableOrDisable(userId: userId, status: userStatus);
    if (response['status'] == 1) {
      onSuccessCallBack?.call(response['status']);
    } else {
      onSuccessCallBack?.call(response['status']);
    }
    status = true;
  }
//  Future<bool> getReport(
//     {String? type, String? startDate, String? endDate}) async {
//   bool status = false;
//   dynamic response = await CommonService()
//       .getReport(type: type, startDate: startDate, endDate: endDate);
//   if (response['status'] == 1) {
//     reportModel.value = ReportModel.fromJson(response);
//     status = true;
//   }

//   return status;
// }

// Future<bool> getAllColectionPath() async {
//   bool status = false;
//   dynamic response = await CommonService().getAllCollectionPath();
//   if (response['status'] == 1) {
//     allCollectionPathModel.value = AllCollectionPathModel.fromJson(response);
//     for (dynamic item in allCollectionPathModel.value!.data) {
//       allPath?.addEntries({item.id: item.name}.entries);
//       allPathId?.addEntries({item.name: item.id}.entries);
//     }
//     status = true;
//   }
//   return status;
// }
}

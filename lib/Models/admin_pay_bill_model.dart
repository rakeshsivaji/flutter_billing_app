import 'dart:convert';

AdminPayBillModel adminPayBillModelFromJson(String str) =>
    AdminPayBillModel.fromJson(json.decode(str));

String adminPayBillModelToJson(AdminPayBillModel data) =>
    json.encode(data.toJson());

class AdminPayBillModel {
  int? status;
  List<AdminPayBillData>? data;
  String? message;

  AdminPayBillModel({
    this.status,
    this.data,
    this.message,
  });

  factory AdminPayBillModel.fromJson(Map<String, dynamic> json) =>
      AdminPayBillModel(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<AdminPayBillData>.from(json['data']!.map((x) => AdminPayBillData.fromJson(x))),
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        'message': message,
      };
}

class AdminPayBillData {
  int? orderId;
  String? storeId;
  String? storeName;
  String? pathName;
  String? storeAddress;
  String? ownerName;
  String? ownerPhone;
  String? orderStatus;
  double? pendingAmount;
  double? completedPending;
  int? newPending;
  String? billEntryStatus;
  int? billEntryCount;
  String? statusMessage;

  AdminPayBillData({
    this.orderId,
    this.storeId,
    this.storeName,
    this.pathName,
    this.storeAddress,
    this.ownerName,
    this.ownerPhone,
    this.orderStatus,
    this.pendingAmount,
    this.completedPending,
    this.newPending,
    this.billEntryStatus,
    this.billEntryCount,
    this.statusMessage,
  });

  factory AdminPayBillData.fromJson(Map<String, dynamic> json) => AdminPayBillData(
        orderId: json['order_id'],
        storeId: json['store_id'],
        storeName: json['store_name'],
        pathName: json['path_name'],
        storeAddress: json['store_address'],
        ownerName: json['owner_name'],
        ownerPhone: json['owner_phone'],
        orderStatus: json['order_status'],
        pendingAmount: json['pending_amount']?.toDouble(),
        completedPending: json['completed_pending']?.toDouble(),
        newPending: json['new_pending'],
        billEntryStatus: json['bill_entry_status'],
        billEntryCount: json['bill_entry_count'],
        statusMessage: json['status_message'],
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'store_id': storeId,
        'store_name': storeName,
        'path_name': pathName,
        'store_address': storeAddress,
        'owner_name': ownerName,
        'owner_phone': ownerPhone,
        'order_status': orderStatus,
        'pending_amount': pendingAmount,
        'completed_pending': completedPending,
        'new_pending': newPending,
        'bill_entry_status': billEntryStatus,
        'bill_entry_count': billEntryCount,
        'status_message': statusMessage,
      };
}

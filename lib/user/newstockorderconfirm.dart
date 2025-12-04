import 'package:billing_app/Models/Neworderstocklist_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/user/user_controller/user_order_page_controller.dart';
import 'package:billing_app/widgets/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ConfirmStockOrder extends StatefulWidget {
  const ConfirmStockOrder({super.key});

  @override
  State<ConfirmStockOrder> createState() => _ConfirmStockOrderState();
}

class _ConfirmStockOrderState extends State<ConfirmStockOrder>
    with SingleTickerProviderStateMixin {
  bool? isChecked = true;
  List<bool> ischecked = [];
  List<bool> isCheck = [];

  // late TabController _tabController;
  bool showContainer = false;
  String selectedId = '';
  String storeId = '';
  String orderId = '';
  String lineid = '';
  String newOrderTotalAmount = '';
  List<String> selectedProduct = [];
  var commonController = Get.put(CommonController());
  late UserOrderPagerControllerImpl _newOrderPageController =
      UserOrderPagerControllerImpl();

  @override
  void initState() {
    super.initState();
    lineid = Get.arguments['lineid'];
    storeId = Get.arguments['id'].toString();
    _newOrderPageController = Get.arguments['newOrderPageController'];
    newOrderTotalAmount = Get.arguments['totalAmount'];
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.deepPurple,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.toNamed('/neworderscreen', arguments: {'id': lineid});
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  ClipPath(
                    clipper: CurvedEdges(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(120, 89, 207, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 40.0, top: 15.0, left: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            const Expanded(
                              child: Text(
                                'ஆர்டர்கள்',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            if (commonController.newstockorderlist == false ||
                                commonController.orderstocklistmodel.value!.data
                                        .orderListItem ==
                                    null) ...[
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Text('வேறு தகவல்கள் இல்லை'),
                                ],
                              ),
                            ] else ...[
                              ListView.builder(
                                itemCount: commonController
                                        .orderstocklistmodel
                                        .value!
                                        .data
                                        .orderListItem
                                        ?.finalData
                                        .length ??
                                    0,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  ischecked.add(false);
                                  return buildItem(
                                      index,
                                      commonController
                                          .orderstocklistmodel
                                          .value!
                                          .data
                                          .orderListItem
                                          ?.finalData[index]);
                                }),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 35.0),
                                      child: Text(
                                        'மொத்தம்',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      '₹ ' +
                                          (commonController
                                                  .orderstocklistmodel
                                                  .value!
                                                  .data
                                                  .orderListItem
                                                  ?.total
                                                  .toString() ??
                                              ''),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 100.0,
                              ),
                            ],
                            if (commonController.orderstocklistmodel.value?.data
                                        .pendingListItem?.finalData.isEmpty ==
                                    true ||
                                commonController.orderstocklistmodel.value?.data
                                        .pendingListItem?.finalData.isEmpty ==
                                    null) ...[
                              const Text(
                                'நிலுவையில் உள்ள பொருட்கள் இல்லை',
                                style: TextStyle(color: Colors.red),
                              )
                            ] else ...[
                              const Text(
                                'நிலுவையில் உள்ள பொருட்கள்',
                                style: TextStyle(color: Colors.red),
                              ),
                              ListView.builder(
                                itemCount: commonController
                                    .orderstocklistmodel
                                    .value!
                                    .data
                                    .pendingListItem
                                    ?.finalData
                                    .length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  ischecked.add(false);
                                  return _buildPendingProducts(
                                      index,
                                      commonController
                                          .orderstocklistmodel
                                          .value!
                                          .data
                                          .pendingListItem
                                          ?.finalData[index]);
                                }),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 50,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(120, 89, 207, 1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          allDelete();
                        },
                        child: const Text(
                          'அனைத்தையும் அழி',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: VerticalDivider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          commonController.newstockorderlist == false
                              ? showToast('பட்டியல் காலியாக உள்ளது')
                              : orderConfirm1();
                        },
                        child: const Text(
                          'ஆர்டர் உறுதி',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Column buildItem(int index, OrderStockListModelFinalDatum? data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  delete(data?.orderListItemId.toString() ?? '');
                  print(data?.orderListItemId);
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: Text(
                data?.name ?? '',
                style: const TextStyle(fontSize: 15),
              )),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                (data?.quantity ?? '') + ' x ' + (data?.price ?? ''),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                width: 20.0,
              ),
              // Container(
              //   width: 40,
              //   child: Text(
              //     'x ' + data.quantity,
              //     textAlign: TextAlign.right,
              //     style: TextStyle(fontSize: 15, color: Colors.red),
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Checkbox(
              //       activeColor: Color.fromRGBO(120, 89, 207, 1),
              //       value: ischecked[index],
              //       onChanged: (value) {
              //         setState(() {
              //           ischecked[index] = value!;
              //           ischecked[index]
              //               ? selectedProduct.add(data.productId)
              //               : selectedProduct.remove(data.productId);
              //           print(selectedProduct);
              //         });
              //       },
              //     ),
              //   ],
              // ),
              Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '₹ ' + (data?.totalPrice.toString() ?? ''),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 15,
        )
      ],
    );
  }

  Column _buildPendingProducts(int index, OrderStockListModelFinalDatum? data) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                data?.name ?? '',
                style: const TextStyle(fontSize: 15, color: Colors.red),
              )),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                data?.quantity ?? '',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15, color: Colors.red),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 15,
        )
      ],
    );
  }

  void delete(String id) async {
    try {
      dynamic response = await CommonService().deletestockOrderList(id);
      if (response['status'] == 1) {
        showToast(response['message']);
        // await commonController.getOrderList(Get.arguments['id'].toString());
        await commonController.Getorderstocklist(
            Get.arguments['id'].toString());
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void allDelete() async {
    dynamic response = await CommonService().deleteAllOrderList(storeId);
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        await commonController.Getorderstocklist(
          Get.arguments['id'].toString(),
          callBackFunction: (statusCode) {
            if (statusCode == 1) {
              newOrderTotalAmount = commonController
                      .orderstocklistmodel.value?.data.orderListItem?.total
                      .toString() ??
                  '';
              _newOrderPageController.totalAmountStream(true);
            } else {
              newOrderTotalAmount = '0';
              _newOrderPageController.totalAmountStream(true);
            }
          },
        );
        // Get.toNamed('/neworderscreen', arguments: {'id': lineid});
        Get.back();
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void orderConfirm1() async {
    dynamic response = await CommonService().orderstockConfirm(storeId, lineid);
    try {
      if (response['status'] == 1) {
        showToast(response['data']);
        _PopupMenu(response['order_id'].toString());
      } else {
        showToast(response['message'] ?? 'பட்டியல் காலியாக உள்ளது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பட்டியல் காலியாக உள்ளது');
    }
    //}
  }

  void _PopupMenu(String orderId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'நீங்கள் தொகையை செலுத்த வேண்டுமா?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // await commonController.getOrderDelivery(
                          //     withLoader: true);
                          // await commonController.getshoworderstocklist();
                          // await commonController.getPath(withLoader: true);
                          await commonController.getuserlinereport(lineid);
                          Get.toNamed('/neworderscreen',
                              arguments: {'id': lineid});
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'பின்னர் செலுத்தவும்',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await commonController.getOrderDetails(orderId);
                          Get.toNamed('/shopbills',
                              arguments: {'orderId': orderId, 'id': lineid});
                          await commonController.getOrderDelivery(
                              withLoader: true);
                          await commonController.getPath(withLoader: true);
                          commonController.Getorderstocklist(storeId);
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'இப்போது செலுத்த',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              height: 30,
              width: 30,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/closeicon.png')),
            ),
          ],
        ),
      ),
    );
  }
}

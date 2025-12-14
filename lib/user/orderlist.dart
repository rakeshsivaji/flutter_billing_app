import 'package:billing_app/Models/orderlist_model.dart';
import 'package:billing_app/Models/tomorroworderlist_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Orderlist extends StatefulWidget {
  const Orderlist({super.key});

  @override
  State<Orderlist> createState() => _OrderlistState();
}

class _OrderlistState extends State<Orderlist>
    with SingleTickerProviderStateMixin {
  bool? isChecked = true;
  List<bool> ischecked = [];
  List<bool> isCheck = [];
  late TabController _tabController;
  bool showContainer = false;
  String selectedId = '';
  String storeId = '';
  String dayDropDownValue = '';
  List<String> selectedProduct = [];
  var commonController = Get.put(CommonController());
  bool isClicked = true;

  @override
  void initState() {
    super.initState();
    storeId = Get.arguments['id'].toString();
    dayDropDownValue = Get.arguments['day'].toString();
    print('selected day si *********** $dayDropDownValue');
    _tabController = TabController(length: 2, vsync: this);
    if (_tabController.index == 0) {
      setState(() {
        showContainer = true;
      });
    } else {
      setState(() {
        showContainer = false;
      });
    }
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
        // Get.toNamed('/orderscreen');
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Obx(() {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(120, 89, 207, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
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
                          'ஆர்டர் பட்டியல்',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await commonController.getPendingOrderList(storeId);
                          Get.toNamed('/pendingorder',
                              arguments: {'id': storeId});
                          print(storeId);
                        },
                        child: showContainer
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/pending.png',
                                      width: 15,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    const Text(
                                      'நிலுவை ஆர்டர்கள்',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 10),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        TabBar(
                          dividerHeight: 0.0,
                          indicatorColor: const Color.fromRGBO(120, 89, 207, 1),
                          indicator: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          controller: _tabController,
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          unselectedLabelColor: Colors.black,
                          tabs: <Widget>[
                            const Tab(
                              text: '      இன்றைய ஆர்டர்கள்      ',
                            ),
                            const Tab(
                              text: '      நாளைய ஆர்டர்கள்       ',
                            ),
                            // Tab(
                            //   child: Container(
                            //     height: 50,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(15),
                            //       //color: Color.fromRGBO(120, 89, 207, 1),
                            //     ),
                            //     child: Center(
                            //         child: Text(
                            //       'இன்றைய ஆர்டர்கள்',
                            //       style: TextStyle(
                            //           color: Colors.white, fontSize: 10),
                            //     )),
                            //   ),
                            // ),

                            // Tab(
                            //   child: Container(
                            //     height: 50,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(15),
                            //       //color: Colors.grey[300],
                            //     ),
                            //     child: Center(
                            //       child: Text(
                            //         'நாளைய ஆர்டர்கள்',
                            //         style: TextStyle(
                            //             fontSize: 10, color: Colors.black),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        TabBar(
                          dividerHeight: 0.0,
                          indicatorColor: const Color.fromRGBO(120, 89, 207, 1),
                          indicatorPadding:
                              const EdgeInsets.only(bottom: 30, top: 15),
                          indicator: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          automaticIndicatorColorAdjustment: true,
                          controller: _tabController,
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          unselectedLabelColor: Colors.black,
                          tabs: <Widget>[
                            Tab(
                              child: Container(
                                height: 2,
                                width: 150,
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 2,
                                width: 150,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Stack(
                                  children: [
                                    if (commonController.orderList == false) ...[
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 50.0),
                                          child: Text('வேறு தகவல்கள் இல்லை'),
                                        ),
                                      ),
                                    ] else ...[
                                      CustomScrollView(
                                        slivers: [
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                                final dataLength = commonController
                                                    .orderListModel
                                                    .value!
                                                    .data
                                                    .orderListItem
                                                    .finalData
                                                    .length;
                                                
                                                // Initialize checkbox array if needed
                                                if (ischecked.length < dataLength) {
                                                  ischecked.addAll(List.filled(dataLength - ischecked.length, false));
                                                }
                                                
                                                if (index < dataLength) {
                                                  return buildItem(
                                                      index,
                                                      commonController
                                                          .orderListModel
                                                          .value!
                                                          .data
                                                          .orderListItem
                                                          .finalData[index]);
                                                } else if (index == dataLength) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 15.0,
                                                            vertical: 18.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 35.0),
                                                          child: SelectableText(
                                                            'மொத்தம்',
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        SelectableText(
                                                          '₹ ' +
                                                              commonController
                                                                  .orderListModel
                                                                  .value!
                                                                  .data
                                                                  .orderListItem
                                                                  .total
                                                                  .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return null;
                                              },
                                              childCount: commonController
                                                      .orderListModel
                                                      .value!
                                                      .data
                                                      .orderListItem
                                                      .finalData
                                                      .length +
                                                  1,
                                            ),
                                          ),
                                          const SliverPadding(
                                            padding: EdgeInsets.only(bottom: 100.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              120, 89, 207, 1),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                allDelete();
                                              },
                                              child: const Text(
                                                'அனைத்தையும் அழி',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
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
                                              onTap: isClicked
                                                  ? () {
                                                      (commonController
                                                                      .orderList ==
                                                                  false ||
                                                              selectedProduct
                                                                  .isEmpty)
                                                          ? showToast(
                                                              'பட்டியலை சரிபார்க்கவும்')
                                                          : orderConfirm();
                                                    }
                                                  : null,
                                              child: const Text(
                                                'ஆர்டர் உறுதி',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Stack(
                                  children: [
                                    if (commonController.tomorrowList == false) ...[
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 50.0),
                                          child: Text('வேறு தகவல்கள் இல்லை'),
                                        ),
                                      ),
                                    ] else ...[
                                      CustomScrollView(
                                        slivers: [
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                                final dataLength = commonController
                                                        .tomorrowOrderListModel
                                                        .value
                                                        ?.data
                                                        .orderListItem
                                                        .tomorrowFinalData
                                                        .length ??
                                                    0;
                                                
                                                // Initialize checkbox array if needed
                                                if (isCheck.length < dataLength) {
                                                  isCheck.addAll(List.filled(dataLength - isCheck.length, false));
                                                }
                                                
                                                if (index < dataLength) {
                                                  return buildItem1(
                                                      index,
                                                      commonController
                                                          .tomorrowOrderListModel
                                                          .value!
                                                          .data
                                                          .orderListItem
                                                          .tomorrowFinalData[index]);
                                                } else if (index == dataLength) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 15.0,
                                                            vertical: 18.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 35.0),
                                                          child: SelectableText(
                                                            'மொத்தம்',
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                        SelectableText(
                                                          '₹ ' +
                                                              commonController
                                                                  .tomorrowOrderListModel
                                                                  .value!
                                                                  .data
                                                                  .orderListItem
                                                                  .total
                                                                  .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return null;
                                              },
                                              childCount: (commonController
                                                      .tomorrowOrderListModel
                                                      .value
                                                      ?.data
                                                      .orderListItem
                                                      .tomorrowFinalData
                                                      .length ??
                                                  0) +
                                                  1,
                                            ),
                                          ),
                                          const SliverPadding(
                                            padding: EdgeInsets.only(bottom: 100.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 60,
                                        width: 200,
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              120, 89, 207, 1),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            // _PopupMenu();
                                            showToast(
                                                'முன்கூட்டிய ஆர்டர் உறுதி செய்யப்பட்டது');
                                            Get.toNamed('/orderscreen');
                                          },
                                          child: const Center(
                                            child: Text(
                                              'முன்கூட்டிய உறுதி',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Column buildItem(int index, FinalDatum data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  delete(data.orderListItemId.toString());
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
                data.name,
                style: const TextStyle(fontSize: 15),
              )),
              const SizedBox(
                width: 12.0,
              ),
              Text(
                data.quantity + ' x ' + data.price,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: const Color.fromRGBO(120, 89, 207, 1),
                    value: ischecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        ischecked[index] = value!;
                        ischecked[index]
                            ? selectedProduct.add(data.productId)
                            : selectedProduct.remove(data.productId);
                        // print(data.productId);
                        // selectedId += data.productId + ',';
                        // print(selectedId);
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      data.totalPrice.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1.0,
        ),
      ],
    );
  }

  Column buildItem1(int index, TomorrowFinalDatum data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 10, top: 15),
          child: Row(
            children: [
              // Checkbox(
              //   activeColor: Color.fromRGBO(120, 89, 207, 1),
              //   value: isCheck[index],
              //   onChanged: (bool? value) {
              //     setState(() {
              //       isCheck[index] = value!;
              //     });
              //   },
              // ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: SelectableText(
                data.name,
                style: const TextStyle(fontSize: 15),
              )),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                data.quantity + ' x ' + data.price,
                style: const TextStyle(fontSize: 15),
              ),
              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [

              //     ],
              //   ),
              // ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '₹ ' + data.totalPrice.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1.0,
        ),
      ],
    );
  }

  void _PopupMenu(String orderId) {
    showDialog(
      barrierDismissible: false,
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
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/orderscreen');
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
                              arguments: {'orderId': orderId});
                          await commonController.getOrderList(storeId);
                          await commonController.getTomorrowOrderList(storeId);
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

  void delete(String id) async {
    dynamic response = await CommonService().deleteOrderList(id);
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        await commonController.getOrderList(Get.arguments['id'].toString());
        // Get.toNamed('/orderlist');
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void allDelete() async {
    dynamic response = await CommonService().deleteAllOrderListForAdminAndUser(
        storeId,
        selectedDay: dayDropDownValue);
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        await commonController.getOrderList(dayDropDownValue);
        await commonController.Getorderstocklist(storeId);
        // Get.toNamed('/orderscreen');
        Get.back();
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void orderConfirm() async {
    setState(() {
      isClicked = !isClicked;
    });
    String finalIds = '';
    finalIds = selectedProduct.map((item) => item.toString()).join(',');
    print(finalIds);
    if (finalIds.isNotEmpty) {
      dynamic response = await CommonService().orderConfirm(finalIds, storeId);
      print('Final ids' + finalIds);
      try {
        if (response['status'] == 1) {
          showToast('ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது');
          print(response['order_id']);
          // await commonController.getOrderDelivery();
          // Get.toNamed('/orderscreen');
          _PopupMenu(response['order_id'].toString());
        } else {
          showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
        }
      } catch (error) {
        print('Error: $error');
        showToast('பிழை ஏற்பட்டது');
      }
    }
  }
}

import 'package:billing_app/Models/Newstocklist_model.dart';
import 'package:billing_app/Models/orderdelivery_model.dart';
import 'package:billing_app/Models/stockorderlist.dart';
import 'package:billing_app/Models/stockpendingorderlist_model.dart';
import 'package:billing_app/admin/controller/stock_list_2_controller.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Stocklist2_Screen extends StatefulWidget {
  const Stocklist2_Screen({super.key});

  @override
  State<Stocklist2_Screen> createState() => _Stocklist2_ScreenState();
}

class _Stocklist2_ScreenState extends State<Stocklist2_Screen>
    with SingleTickerProviderStateMixin {
  bool? isChecked = true;
  List<String> list = <String>[];
  String storeDropdownValue = '';
  final _stockList2Controller = StockList2ControllerImpl();

  // int _quantity = 0;
  int? _selectedValueIndex;
  int price = 0;
  List<bool> ischecked = [];
  List<bool> isCheck = [];
  List<String> selectedProduct = [];
  List<String> pendingSelectedProduct = [];
  dynamic response;
  String totalAmount = '0';
  String stringamount = '0';
  double productAmount = 0;
  double doubleamount = 0.0;
  double finalAmount = 0;
  int totalQuantity = 0;
  int quantity = 0;
  String? categoryId;
  String? storeId;
  List<String> buttonText = ['All', 'Milk', 'Cool Drinks', 'Chips', 'Others'];
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();

  // final TextEditingController quantity = TextEditingController();
  final TextEditingController Amount = TextEditingController();

  //PersistentBottomSheetController _controller; // <------ Instance variable
  //final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        Get.toNamed('/stocklist');
        await commonController.getAdminStockList();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Obx(() {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () {
                  return refreshValue();
                },
                child: Column(
                  children: [
                    CustomAppBar(
                        text: 'ஸ்டாக் பட்டியல் - ரசிது உள்ளீடுகள்',
                        path: 'stocklist'),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (commonController.orderdelivery == true) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 10.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 18.0,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        child: ListView.builder(
                                          itemCount: commonController
                                                  .orderdeliverymodel
                                                  .value!
                                                  .data
                                                  .category
                                                  .length +
                                              1,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            if (index == 0) {
                                              return button(
                                                  index,
                                                  Category(
                                                      name: 'All',
                                                      categoryId: 0));
                                            } else {
                                              List<Category> category =
                                                  commonController
                                                      .orderdeliverymodel
                                                      .value!
                                                      .data
                                                      .category;
                                              return button(
                                                  index, category[index - 1]);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 45,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: storeDropdownValue.isEmpty
                                      ? null
                                      : storeDropdownValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      storeDropdownValue = newValue!;
                                      storeId = commonController
                                          .allStoreId![storeDropdownValue]
                                          .toString();
                                      print(commonController
                                          .allStoreId![storeDropdownValue]);
                                      commonController.getAdminStockListShow(
                                          withLoader: false,
                                          search: categoryId,
                                          storeId: commonController
                                              .allStoreId![storeDropdownValue]
                                              .toString());
                                      commonController.getStockOrderList(
                                        commonController
                                            .allStoreId![storeDropdownValue]
                                            .toString(),
                                        callBackFunction: (statusCode) {
                                          if (statusCode == 1) {
                                            totalAmount = commonController
                                                    .stockOrderListModel
                                                    .value
                                                    ?.data
                                                    .orderListItem
                                                    .total
                                                    .toString() ??
                                                '';
                                            _stockList2Controller
                                                .totalStream(true);
                                          } else {
                                            totalAmount = '0';
                                            _stockList2Controller
                                                .totalStream(true);
                                          }
                                        },
                                      );
                                      commonController.getStockPendingOrderList(
                                          commonController
                                              .allStoreId![storeDropdownValue]
                                              .toString());

                                      if (commonController.stockOrderList ==
                                          false) {
                                        setState(() {
                                          totalAmount = '0';
                                        });
                                      }
                                      //   setState(() {
                                      //     totalAmount = commonController
                                      //         .stockOrderListModel
                                      //         .value!
                                      //         .data
                                      //         .orderListItem
                                      //         .total
                                      //         .toString();
                                      //   });
                                      // }
                                    });
                                  },
                                  hint: const Text(
                                    'கடையைத் தேர்ந்தெடுக்கவும்',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  icon: Image.asset(
                                    'assets/images/arrowdown.png',
                                    width: 13,
                                  ),
                                  items: commonController.allStoreName!
                                      .map((id, name) {
                                        return MapEntry(
                                            id,
                                            DropdownMenuItem<String>(
                                              value: name,
                                              child: Text(name),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                  underline: Container(),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(120, 89, 207, 0.05),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        if (storeDropdownValue.isNotEmpty) ...[
                                          if (commonController.newstocklistmodel
                                                      .value?.data ==
                                                  null ||
                                              commonController.newstocklistmodel
                                                  .value!.data.isEmpty) ...[
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            const Text(
                                              'பொருட்கள் எதுவும் இல்லை',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                          Container(
                                            child: GridView.builder(
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              primary: false,
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 16 / 21,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 15,
                                              ),
                                              itemCount: commonController
                                                      .newstocklistmodel
                                                      .value
                                                      ?.data
                                                      .length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                return buildProduct(
                                                    commonController
                                                        .newstocklistmodel
                                                        .value!
                                                        .data[index]);
                                              },
                                            ),
                                          ),
                                        ] else ...[
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          const Center(
                                              child: Text(
                                            'கடையைத் தேர்தெடுக்கவும்',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          )),
                                        ],
                                        const SizedBox(
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 30,
                              ),
                              const Center(
                                  child: Text(
                                'பொருட்கள் எதுவும் இல்லை',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              )),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: _stockList2Controller.totalStreamController,
                  builder: (context, snapshot) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(120, 89, 207, 1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SelectableText(
                              'மொத்தம் ₹ ' + totalAmount.toString(),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 3.0,
                            ),
                            InkWell(
                              onTap: () {
                                if (storeDropdownValue.isEmpty) {
                                  showToast('கடையைத் தேர்ந்தெடுக்கவும்');
                                } else {
                                  showBottomSheet(context);
                                }
                              },
                              child: const Text(
                                'ஸ்டாக் - ஆர்டர் பட்டியல்',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 450,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
              child: Stack(
                children: [
                  Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 3.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SelectableText(
                              'ஸ்டாக் - ஆர்டர் உறுதி',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (commonController.stockOrderList == false) ...[
                                const Text('வேறு தகவல்கள் இல்லை'),
                              ] else ...[
                                Container(
                                  child: ListView.builder(
                                    itemCount: commonController
                                        .stockOrderListModel
                                        .value!
                                        .data
                                        .orderListItem
                                        .finalData
                                        .length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: ((context, index) {
                                      ischecked.add(false);
                                      return buildItem(
                                          index,
                                          commonController
                                              .stockOrderListModel
                                              .value!
                                              .data
                                              .orderListItem
                                              .finalData[index]);
                                    }),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 53.0, right: 15.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SelectableText('மொத்தம்',
                                  style: TextStyle(fontSize: 15)),
                              if (commonController.stockOrderList == false) ...[
                                const SelectableText('₹ 0',
                                    style: TextStyle(fontSize: 15)),
                              ] else ...[
                                Text(
                                    '₹ ' +
                                        commonController.stockOrderListModel
                                            .value!.data.orderListItem.total
                                            .toString(),
                                    style: const TextStyle(fontSize: 15))
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    );
                  }),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        pendingBottomSheet(context);
                        setState(() {
                          ischecked.clear();
                          isCheck.clear();
                          selectedProduct.clear();
                        });
                      },
                      child: Image.asset(
                          height: 25, width: 25, 'assets/images/pending.png'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .07,
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
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'அனைத்தையும் அழி',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: VerticalDivider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              orderConfirm();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'ஸ்டாக் - ஆர்டர் உறுதி',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Future<void> showBottomSheet1(BuildContext context) {
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         height: 600,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 20),
  //           child: SingleChildScrollView(
  //             child: Center(
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 10),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     GestureDetector(
  //                       onTap: () {},
  //                       child: Container(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   'ஸ்டாக் - நிலுவையில் உள்ள பட்டியல்',
  //                                 ),
  //                                 SizedBox(
  //                                   width: 35,
  //                                 ),
  //                                 InkWell(
  //                                     onTap: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     child: Image.asset(
  //                                         height: 25,
  //                                         width: 25,
  //                                         'assets/images/reminder.png')),
  //                               ],
  //                             ),
  //                             SizedBox(
  //                               height: 20,
  //                             ),
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceAround,
  //                               children: [Text('Total'), Text('₹ 399')],
  //                             ),
  //                             SizedBox(
  //                               height: 35,
  //                             ),
  //                             Container(
  //                               height:
  //                                   MediaQuery.of(context).size.height * .07,
  //                               width: MediaQuery.of(context).size.width - 50,
  //                               decoration: BoxDecoration(
  //                                 color: Color.fromRGBO(120, 89, 207, 1),
  //                                 borderRadius: BorderRadius.circular(25),
  //                               ),
  //                               child: InkWell(
  //                                 onTap: () {
  //                                   Navigator.pop(context);
  //                                 },
  //                                 child: Center(
  //                                   child: Text(
  //                                     "ஸ்டாக் - நிலுவை உறுதி",
  //                                     style: TextStyle(color: Colors.white),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> orderlistBottomsheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SelectableText('ஸ்டாக் - ஆர்டர் உறுதி'),
                          const SizedBox(
                            width: 50,
                          ),
                          InkWell(
                            onTap: () {
                              pendingBottomSheet(context);
                            },
                            child: Image.asset(
                                height: 25,
                                width: 25,
                                'assets/images/pending.png'),
                          ),
                        ],
                      ),
                      if (commonController.stockOrderList == true) ...[
                        ListView.builder(
                          itemCount: commonController.stockOrderListModel.value!
                              .data.orderListItem.finalData.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            ischecked.add(false);
                            return buildItem(
                                index,
                                commonController.stockOrderListModel.value!.data
                                    .orderListItem.finalData[index]);
                          }),
                        )
                      ] else ...[
                        const Text('வேறு தகவல்கள் இல்லை'),
                      ],
                      const SizedBox(
                        height: 0,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Text('மொத்தம்'), Text('₹ 399')],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Positioned(
                        bottom: 5,
                        left: 25,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .07,
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SelectableText(
                                'அனைத்தையும் அழி',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: VerticalDivider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // _PopupMenu();
                                },
                                child: const Text(
                                  'ஸ்டாக் - ஆர்டர் உறுதி',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> pendingBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            height: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Stack(
                children: [
                  Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 3.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ஸ்டாக் - நிலுவையில் உள்ள பட்டியல்',
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (commonController.pendingStockOrder ==
                                  true) ...[
                                ListView.builder(
                                  itemCount: commonController
                                      .stockPendingOrderListModel
                                      .value!
                                      .data
                                      .pendingItem
                                      .pendingFinalData
                                      .length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                    isCheck.add(false);
                                    return buildItem1(
                                      index,
                                      commonController
                                          .stockPendingOrderListModel
                                          .value!
                                          .data
                                          .pendingItem
                                          .pendingFinalData[index],
                                    );
                                  }),
                                )
                              ] else ...[
                                const Text('வேறு தகவல்கள் இல்லை'),
                              ],
                            ],
                          ),
                        )),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 53.0, right: 15.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SelectableText('மொத்தம்',
                                  style: TextStyle(fontSize: 15)),
                              if (commonController.pendingStockOrder ==
                                  false) ...[
                                const SelectableText('₹ 0',
                                    style: TextStyle(fontSize: 15)),
                              ] else ...[
                                SelectableText(
                                    '₹ ' +
                                        commonController
                                            .stockPendingOrderListModel
                                            .value!
                                            .data
                                            .pendingItem
                                            .total
                                            .toString(),
                                    style: const TextStyle(fontSize: 15))
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    );
                  }),
                  Positioned(
                    right: 10,
                    top: 20,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            isCheck.clear();
                            pendingSelectedProduct.clear();
                          });
                        },
                        child: Image.asset(
                            height: 25,
                            width: 25,
                            'assets/images/reminder.png')),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .07,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(120, 89, 207, 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              pendingOrderConfirm();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'ஸ்டாக் - நிலுவை உறுதி',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget button(int index, Category data) {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        setState(() {
          _selectedValueIndex = index;
          categoryId = data.categoryId.toString();
          commonController.getAdminStockListShow(
              withLoader: false,
              search: data.categoryId.toString(),
              storeId: storeId);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: index == _selectedValueIndex
              ? const Color.fromRGBO(120, 89, 207, 1)
              : const Color.fromRGBO(243, 243, 243, 1),
        ),
        child: Text(
          data.name,
          style: TextStyle(
            color: index == _selectedValueIndex ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  InkWell buildProduct(Datum product) {
    return InkWell(
      onTap: () async {
        setState(() {
          stringamount = product.price.toString();
          print('the string amount is ********* $stringamount');
          productAmount = double.parse(stringamount);
          totalQuantity = product.quantity; //int.parse(product.quantity);
          debugPrint('the total Quantity **** $totalQuantity');
        });
        if (totalQuantity > 0) {
          await _getProductDetails(product);
          _PopupMenu(product.name, productAmount, product.productId.toString(),
              totalQuantity);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(2, 0),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(-2, 0),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          children: [
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                color: Color.fromRGBO(120, 89, 207, 0.2),
              ),
              child: Center(
                child: SelectableText(
                  product.name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Expanded(
              child: Container(
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Image.network(product.image),
              ),
            ),
            // Center(
            //   child: Image.network(
            //     data.image,
            //     height: 65,
            //     width: 65,
            //   ),
            // ),
            const SizedBox(
              height: 6.0,
            ),
            Container(
              //height: 25,
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(19, 19, 19, 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: SelectableText(
                  '₹' + product.price.toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
                color: Color.fromRGBO(120, 89, 207, 0.2),
              ),
              child: Center(
                child: Text(
                  'Qty ' + product.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatefulBuilder buildItem(int index, FinalDatum data) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    delete(data.orderListItemId.toString());
                    // Navigator.pop(context);
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
                    child: SelectableText(
                  //'Milk',
                  data.name,
                  style: const TextStyle(fontSize: 15),
                )),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  data.quantity + ' x ' + data.price,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  width: 30.0,
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
                          print(selectedProduct);
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SelectableText(
                        //"222",
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
    });
  }

  StatefulBuilder buildItem1(int index, PendingFinalDatum data) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              children: [
                Checkbox(
                  activeColor: const Color.fromRGBO(120, 89, 207, 1),
                  value: isCheck[index],
                  onChanged: (bool? value) {
                    setState(() {
                      isCheck[index] = value!;
                      isCheck[index]
                          ? pendingSelectedProduct.add(data.productId)
                          : pendingSelectedProduct.remove(data.productId);
                      print(pendingSelectedProduct);
                    });
                  },
                ),
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SelectableText(
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
    });
  }

  Container buildformfield() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: SelectableText(
              ' ₹  |',
              style:
                  TextStyle(fontSize: 22, color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _PopupMenu(
      String name, double amount, String pruductId, int totalQuantity) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return StreamBuilder(
                stream: _stockList2Controller.productDialogStreamController,
                builder: (context, snapshot) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        Container(
                          height: 420,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(120, 89, 207, 1),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                child: Center(
                                    child: SelectableText(
                                  name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SelectableText(
                                                'விலை',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: const Color.fromRGBO(
                                                      250, 250, 250, 1),
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: SelectableText(
                                                        ' ₹  |',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6)),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: SelectableText(
                                                        amount.toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SelectableText(
                                                'மொத்த விலை',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: const Color.fromRGBO(
                                                      250, 250, 250, 1),
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      child: SelectableText(
                                                        ' ₹  |',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6)),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        finalAmount.toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color.fromRGBO(250, 250, 250, 1),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Form(
                                        key: _formKey1,
                                        child: TextFormField(
                                          controller: Amount,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(8),
                                          ],
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              doubleamount =
                                                  double.parse(value);
                                              if (doubleamount <=
                                                  totalQuantity) {
                                                finalAmount = doubleamount *
                                                    productAmount;
                                                quantity =
                                                    int.tryParse(value) ?? 0;
                                                finalAmount =
                                                    quantity * productAmount;
                                                print('double $doubleamount');
                                                print('final $finalAmount');
                                              }
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'அளவை உள்ளிடவும்',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text('அல்லது'),
                              const SizedBox(
                                height: 20.0,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text('அளவு'),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (quantity > 0) {
                                        setState(() {
                                          quantity--;
                                          finalAmount = quantity * amount;
                                          Amount.text = quantity.toString();
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              const Color.fromRGBO(250, 250, 250, 1),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                          )),
                                      child: const Center(
                                        child: Icon(
                                          Icons.remove_rounded,
                                          size: 25,
                                          color: Color.fromRGBO(71, 52, 125, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    height: 40,
                                    constraints: const BoxConstraints(minWidth: 60),
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color.fromRGBO(120, 89, 207, 1),
                                    ),
                                    child: Center(
                                      child: SelectableText(
                                        '$quantity',
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (quantity < totalQuantity) {
                                          quantity++;
                                          finalAmount = quantity * amount;
                                          Amount.text = quantity.toString();
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              const Color.fromRGBO(250, 250, 250, 1),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                          )),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 25,
                                          color: Color.fromRGBO(71, 52, 125, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity = 0;
                                          Amount.text = '0';
                                          finalAmount = 0;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey[300],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'ரத்து',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (quantity <= totalQuantity &&
                                            quantity > 0 &&
                                            doubleamount <= totalQuantity) {
                                          submit(pruductId);
                                          Navigator.pop(context);
                                        } else {
                                          showToast(
                                              'மொத்த அளவை விட அதிகமாக உள்ளது');
                                        }
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color:
                                              const Color.fromRGBO(120, 89, 207, 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'சரி',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          height: 30,
                          width: 30,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  quantity = 0;
                                  Amount.text = '0';
                                  finalAmount = 0;
                                });
                                Navigator.pop(context);
                              },
                              child:
                                  Image.asset('assets/images/closeicon2.png')),
                        ),
                      ],
                    ),
                  );
                });
          });
        });
  }

  void _PopupMenu1(String orderId) {
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
                        onTap: () {
                          Navigator.pop(context);
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
    dynamic response = await CommonService().deleteStockOrderList(id);
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        // await commonController.getOrderList(Get.arguments['id'].toString());
        // Get.toNamed('/orderlist');
        commonController.getAdminStockListShow(
            withLoader: false, search: categoryId, storeId: storeId);
        await commonController.getStockOrderList(
          commonController.allStoreId![storeDropdownValue].toString(),
          callBackFunction: (statusCode) {
            if (statusCode == 1) {
              totalAmount = commonController
                  .stockOrderListModel.value!.data.orderListItem.total
                  .toString();
            }else{
              totalAmount = '0';
            }
          },
        );
        await commonController.getStockPendingOrderList(
            commonController.allStoreId![storeDropdownValue].toString());
        setState(() {});
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void allDelete() async {
    dynamic response = await CommonService().deleteAllStockOrderList(
        commonController.allStoreId![storeDropdownValue].toString());
    try {
      if (response['status'] == 1) {
        showToast(response['message']);
        setState(() {
          totalAmount = '0';
        });
        await commonController.getStockOrderList(
            commonController.allStoreId![storeDropdownValue].toString());
        await commonController.getStockPendingOrderList(
            commonController.allStoreId![storeDropdownValue].toString());
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void submit(String productId) async {
    if (storeDropdownValue.isEmpty) {
      showToast('கடையைத் தேர்ந்தெடுக்கவும்');
    } else {
      if (_formKey1.currentState!.validate()) {
        try {
          Map<String, dynamic> newData = {
            'store_id':
                commonController.allStoreId![storeDropdownValue].toString(),
            'product_id': productId,
            'quantity': quantity.toString(),
          };

          dynamic response =
              await CommonService().createStockOrderList(newData);

          if (response['status'] == 1) {
            showToast(response['message']);
            setState(() {
              quantity = 0;
              Amount.text = '0';
              finalAmount = 0;
              // totalAmount = response["total_amount"].toString();
            });
            commonController.getAdminStockListShow(
                withLoader: false, search: categoryId, storeId: storeId);
            // await commonController.getOrderDelivery(withLoader: true);
            // Get.toNamed('/stocklist2');
            await commonController.getStockOrderList(
              commonController.allStoreId![storeDropdownValue].toString(),
              callBackFunction: (statusCode) {
                if (statusCode == 1) {
                  totalAmount = commonController
                          .stockOrderListModel.value?.data.orderListItem.total
                          .toString() ??
                      '';
                } else {
                  totalAmount = '0';
                }
              },
            );
            await commonController.getStockPendingOrderList(
                commonController.allStoreId![storeDropdownValue].toString());
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

  void orderConfirm() async {
    String finalIds = '';
    finalIds = selectedProduct.map((item) => item.toString()).join(',');
    if (finalIds != '' && finalIds.isNotEmpty) {
      try {
        dynamic response = await CommonService().confirmStockOrderList(finalIds,
            commonController.allStoreId![storeDropdownValue].toString());
        if (response['status'] == 1) {
          showToast('ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது');
          print(response['order_id']);
          _PopupMenu1(response['order_id'].toString());
          setState(() {
            totalAmount = '0';
            selectedProduct.clear();
          });
          await commonController.getAdminStockListShow(
              withLoader: false, search: categoryId, storeId: storeId);
          await commonController.getStockOrderList(
              commonController.allStoreId![storeDropdownValue].toString());
          await commonController.getStockPendingOrderList(
              commonController.allStoreId![storeDropdownValue].toString());
        } else {
          showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
        }
      } catch (error) {
        print('Error: $error');
        showToast('பிழை ஏற்பட்டது');
      }
    } else {
      showToast('பொருட்களை தேர்ந்தெடுக்கவும்');
    }
  }

  void pendingOrderConfirm() async {
    String finalIds = '';
    finalIds = pendingSelectedProduct.map((item) => item.toString()).join(',');
    dynamic response = await CommonService().confirmPendingStockOrderList(
        commonController.allStoreId![storeDropdownValue].toString(), finalIds);
    try {
      if (response['status'] == 1) {
        showToast('ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது');
        setState(() {
          pendingSelectedProduct.clear();
        });
        print(response['order_id']);
        await commonController.getAdminStockListShow(
            withLoader: false, search: categoryId, storeId: storeId);
        await commonController.getStockOrderList(
            commonController.allStoreId![storeDropdownValue].toString());
        await commonController.getStockPendingOrderList(
            commonController.allStoreId![storeDropdownValue].toString());
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  Future<void> refreshValue() async {
    await commonController.getStockOrderList(
      commonController.allStoreId![storeDropdownValue].toString(),
      callBackFunction: (statusCode) {
        if (statusCode == 1) {
          totalAmount = commonController
                  .stockOrderListModel.value?.data.orderListItem.total
                  .toString() ??
              '';
          _stockList2Controller.totalStream(true);
        } else {
          totalAmount = '0';
          _stockList2Controller.totalStream(true);
        }
      },
    );
  }

  Future<void> _getProductDetails(Datum product) async {
    await commonController.getStockOrderList(
        commonController.allStoreId![storeDropdownValue].toString(),
        callBackFunction: (statusCode) {
      if (statusCode == 1) {
        for (FinalDatum i in commonController
                .stockOrderListModel.value?.data.orderListItem.finalData ??
            []) {
          if (int.tryParse(i.productId) == product.productId) {
            quantity = int.tryParse(i.quantity) ?? 0;
            Amount.text = i.quantity ?? '';
            doubleamount = double.parse(Amount.text);
            finalAmount = doubleamount * productAmount;
            quantity = int.tryParse(Amount.text) ?? 0;
            finalAmount = quantity * productAmount;
            _stockList2Controller.productDialogStream(true);
            break;
          } else {
            quantity = 0;
            finalAmount = 0;
            Amount.text = '';
            _stockList2Controller.productDialogStream(true);
          }
        }
      } else {
        quantity = 0;
        finalAmount = 0;
        Amount.text = '';
        _stockList2Controller.productDialogStream(true);
      }
    });
  }
}

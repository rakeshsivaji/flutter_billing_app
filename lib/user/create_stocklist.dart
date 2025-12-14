import 'dart:async';

import 'package:billing_app/Models/orderdelivery_model.dart';
import 'package:billing_app/Models/stock_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/user/user_controller/create_stocklist_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Create_Stocklist_Screen extends StatefulWidget {
  const Create_Stocklist_Screen({super.key});

  @override
  State<Create_Stocklist_Screen> createState() =>
      _Create_Stocklist_ScreenState();
}

class _Create_Stocklist_ScreenState extends State<Create_Stocklist_Screen>
    with SingleTickerProviderStateMixin {
  bool? isChecked = true;
  List<String> list = <String>[];
  String dropdownValue = '';
  String totalAmount = '0';
  String stringamount = '0';
  double productAmount = 0;
  double doubleamount = 0.0;
  double finalAmount = 0;
  int quantity = 0;
  String? prdtID;
  String lineid = '';
  bool? isEdit;
  String stockId = '';
  final _csListController = CreateStockListControllerImpl();

  int? _selectedValueIndex;
  final TextEditingController Amount = TextEditingController();
  var commonController = Get.put(CommonController());
  bool add = false;
  List<String> buttonText = ['All', 'Milk', 'Cool Drinks', 'Chips', 'Others'];
  final _totalAmountStream = StreamController.broadcast();

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
  void initState() {
    super.initState();
    setState(() {
      if (commonController.stock == false) {
        totalAmount = '0';
      } else {
        totalAmount =
            commonController.stockModel.value!.data.stockItem.total.toString();
      }
      lineid = Get.arguments['id'];
      isEdit = Get.arguments['isEdit'];
      stockId = Get.arguments['stockId'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await commonController.getStockListline(lineid);
        Get.toNamed('/cstlist', arguments: {'id': lineid});
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: RefreshIndicator(
          onRefresh: () {
            return _refreshValues();
          },
          child: Obx(() {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, bottom: 20, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                await commonController.getStockListline(lineid);
                                Get.toNamed('/cstlist',
                                    arguments: {'id': lineid});
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'புதிய ஸ்டாக் பட்டியலை உருவாக்கவும்',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 13,
                              backgroundColor: Color.fromRGBO(120, 89, 207, 1),
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(120, 89, 207, 0.05),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
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
                                                .orderdeliverymodel
                                                .value!
                                                .data
                                                .product
                                                .length,
                                            itemBuilder: (context, index) {
                                              return gridMethod(commonController
                                                  .orderdeliverymodel
                                                  .value!
                                                  .data
                                                  .product[index]);
                                            },
                                          ),
                                        ),
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
                isEdit == true
                    ? const SizedBox()
                    : StreamBuilder(
                        stream: _totalAmountStream.stream,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'மொத்தம் ₹ ' + totalAmount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    const VerticalDivider(
                                      color: Colors.white,
                                      thickness: 3.0,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          commonController.stock == false
                                              ? showToast(
                                                  'ஸ்டாக் பட்டியல் இல்லை')
                                              : showBottomSheet(context);
                                        },
                                        child: const Text(
                                          'ஸ்டாக் பட்டியல்',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        )),
                                  ],
                                ),
                              ));
                        })
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<Null> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Stack(
              children: [
                Column(
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
                    const Text('ஸ்டாக் பட்டியல்'),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Obx(() {
                          return Column(
                            children: [
                              if (commonController.stock == false) ...[
                                const Text('வேறு தகவல்கள் இல்லை'),
                              ] else ...[
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: commonController.stockModel
                                        .value!.data.stockItem.finalData.length,
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: ((context, index) {
                                      return buildItem(commonController
                                          .stockModel
                                          .value!
                                          .data
                                          .stockItem
                                          .finalData[index]);
                                    }),
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: 15.0,
                              ),
                              StreamBuilder(
                                  stream: _totalAmountStream.stream,
                                  builder: (context, snapshot) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 53.0, right: 15.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('மொத்தம்',
                                                style: TextStyle(fontSize: 15)),
                                            Text('₹ ' + totalAmount,
                                                style: const TextStyle(
                                                    fontSize: 15))
                                          ]),
                                    );
                                  }),
                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: _totalAmountStream.stream,
                    builder: (context, snapshot) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 50,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'மொத்தம்',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text('₹ ' + totalAmount,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                              const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: VerticalDivider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  confirmStock();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'ஸ்டாக் உறுதி',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      },
    ).then(
      (value) {
        _refreshValues();
      },
    );
  }

  void _PopupMenu(String name, double amount, String productId) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          child: Center(
                              child: Text(
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
                                        const Text(
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Text(
                                                  ' ₹  |',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  amount.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
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
                                  StreamBuilder(
                                      stream: _csListController
                                          .quantityStreamController,
                                      builder: (context, snapshot) {
                                        return Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
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
                                                      child: Text(
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
                                        );
                                      }),
                                ],
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              StreamBuilder(
                                  stream: _csListController
                                      .quantityStreamController,
                                  builder: (context, snapshot) {
                                    return Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color.fromRGBO(
                                            250, 250, 250, 1),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: Amount,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(8),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            doubleamount = double.parse(value);
                                            finalAmount =
                                                doubleamount * productAmount;
                                            quantity = int.tryParse(value) ?? 0;
                                            finalAmount =
                                                quantity * productAmount;
                                            print('double $doubleamount');
                                            print('final $finalAmount');
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'அளவை உள்ளிடவும்',
                                          hintStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          fillColor: const Color.fromRGBO(
                                              71, 52, 125, 1),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0),
                                        ),
                                      ),
                                    );
                                  }),
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
                                setState(() {
                                  if (quantity > 0) {
                                    quantity--;
                                    finalAmount = quantity * amount;
                                    Amount.text = quantity.toString();
                                  }
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
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
                            StreamBuilder(
                                stream:
                                    _csListController.quantityStreamController,
                                builder: (context, snapshot) {
                                  return Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          const Color.fromRGBO(120, 89, 207, 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$quantity',
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                  finalAmount = quantity * amount;
                                  Amount.text = quantity.toString();
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
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
                        isEdit == true
                            ? GestureDetector(
                                onTap: () {
                                  submitUpdate(productId);
                                  setState(() {
                                    quantity = 0;
                                    Amount.text = '0';
                                    finalAmount = 0;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(120, 89, 207, 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Center(
                                    child: Text(
                                      'சேர்க்க',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
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
                                    InkWell(
                                      onTap: quantity > 0
                                          ? () {
                                              setState(() {
                                                prdtID = productId;
                                              });
                                              createStocklist(productId);
                                              Navigator.pop(context);
                                            }
                                          : () => Navigator.pop(context),
                                      child: Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color.fromRGBO(
                                              120, 89, 207, 1),
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
                        child: Image.asset('assets/images/closeicon2.png')),
                  ),
                ],
              ),
            );
          });
        });
  }

  Container rowMethod(label) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10), right: Radius.circular(10)),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  StatefulBuilder buildItem(FinalDatum data) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    deleteStock(data.orderListItemId.toString());
                    //Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    data.name,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Container(
                  width: 100,
                  child: Text(
                    data.quantity + ' x ' + data.price,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 4,
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
          const SizedBox(
            height: 3,
          ),
          const Divider(
            height: 1.0,
          ),
        ],
      );
    });
  }

  Widget button(int index, Category data) {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        setState(() {
          _selectedValueIndex = index;
          commonController.getOrderDelivery(
              withLoader: false, search: data.categoryId.toString());
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

  Widget gridMethod(Product product) {
    return InkWell(
      onTap: () async {
        setState(() {
          stringamount = product.amount;
          productAmount = double.parse(stringamount);
          print(productAmount);
        });
        await commonController.getStock(
          callBackFunction: (statusCode) {
            if (statusCode == 1) {
              for (FinalDatum i in commonController
                      .stockModel.value?.data.stockItem.finalData ??
                  []) {
                if (int.tryParse(i.productId) == product.productId) {
                  quantity = int.tryParse(i.quantity) ?? 0;
                  Amount.text = i.quantity ?? '';
                  doubleamount = double.parse(Amount.text);
                  finalAmount = doubleamount * productAmount;
                  quantity = int.tryParse(Amount.text) ?? 0;
                  finalAmount = quantity * productAmount;
                  _csListController.quantityStream(true);
                  break;
                } else {
                  quantity = 0;
                  Amount.text = '';
                  finalAmount = 0;
                  _csListController.quantityStream(true);
                }
              }
            } else {
              quantity = 0;
              Amount.text = '';
              finalAmount = 0;
              _csListController.quantityStream(true);
            }
          },
        );
        _PopupMenu(product.name, productAmount, product.productId.toString());
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
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                color: Color.fromRGBO(120, 89, 207, 0.2),
              ),
              child: Center(
                child: SelectableText(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Image.network(
                  product.image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Container(
              //height: 25,
              width: 60,
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(19, 19, 19, 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  '₹' + product.amount,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget dropdownbuild() {
    return Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 2.4,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue.isEmpty ? null : dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        hint: const Text('பாதையைத் தேர்ந்தெடுக்கவும்'),
        style: const TextStyle(fontSize: 10, color: Colors.black),
        icon: const Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.black,
        ),
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  void createStocklist(String id) async {
    Map? map = {'product_id': id, 'quantity': quantity};
    dynamic response = await CommonService().createStockList(map);
    if (response['status'] == 1) {
      showToast(response['message']);
      setState(() {
        totalAmount = response['total_amount'].toString();
        quantity = 0;
        Amount.text = '0';
        finalAmount = 0;
      });
      commonController.getStock();
    } else {
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void confirmStock() async {
    dynamic response = await CommonService().userstockconfirm(lineid);
    if (response['status'] == 1) {
      showToast(response['data']);
      commonController.getStock();
      setState(() {
        totalAmount = '0';
      });
    } else {
      showToast(response['data']);
    }
  }

  void deleteStock(String id) async {
    dynamic response = await CommonService().deleteStock(id);
    if (response['status'] == 1) {
      showToast(response['message']);
      commonController.getStock();
      _refreshValues();
    } else {
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void submitUpdate(String productId) async {
    print('the product Id is ********** $productId');
    dynamic response = CommonService()
        .userStockProductAdd(productId, stockId, quantity.toString());
    Navigator.pop(context);
    if (response['status'] == 1) {
      showToast(response['data'] ?? 'வெற்றிகரமாக உருவாக்கப்பட்டது!');
      // await commonController.getlineshow();
      await commonController.getStock();
      await commonController.getStockListline(lineid);
    } else {
      showToast(response?['data'] ?? 'பிழை ஏற்பட்டது');
    }
  }

  Future<void> _refreshValues() async {
    await commonController.getStock(
      callBackFunction: (statusCode) {
        if (statusCode == 1) {
          totalAmount = commonController.stockModel.value?.data.stockItem.total
                  .toString() ??
              '';
          _totalAmountStream.add(true);
        } else {
          totalAmount = '0';
          _totalAmountStream.add(true);
        }
      },
    );
  }
}

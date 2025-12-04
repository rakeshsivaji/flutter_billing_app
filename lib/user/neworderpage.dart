import 'package:billing_app/Models/Neworderstocklist_model.dart';
import 'package:billing_app/Models/Newstocklist_model.dart';
import 'package:billing_app/Models/orderdelivery_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/user/user_controller/user_order_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class New_order_screen extends StatefulWidget {
  const New_order_screen({super.key});

  @override
  State<New_order_screen> createState() => _New_order_screenState();
}

class _New_order_screenState extends State<New_order_screen> {
  List<String> list = <String>[];
  String routeDropdownValue = '';
  String storeDropdownValue = '';
  String dayDropdownValue = '';
  String stringamount = '0';
  double productAmount = 0;
  double doubleamount = 0.0;
  double finalAmount = 0;
  int quantity = 0;
  int totalquantity = 0;
  String price = '';
  String? categoryId;
  String lineid = '';
  String? storeId;
  int? _selectedValueIndex;
  String totalAmount = '0';
  Map<String, String> day = {'indru': 'today', 'naalai': 'tomorrow'};
  List<String> buttonText = ['All', 'Milk', 'Cool Drinks', 'Chips', 'Others'];
  List<String> days = ['இன்று', 'நாளை'];
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController Amount = TextEditingController();
  final TextEditingController pendingQuantity = TextEditingController();
  final _newOrderController = UserOrderPagerControllerImpl();

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
    // TODO: implement initState
    super.initState();
    lineid = Get.arguments['id'];
  }

  refreshValue() async {
    commonController.getshoworderstocklist(
        withLoader: false,
        search: categoryId,
        storeId: commonController.storeId![storeDropdownValue].toString());
    await commonController.Getorderstocklist(
        commonController.storeId![storeDropdownValue].toString(),
        callBackFunction: (statusCode) {
      if (statusCode == 0) {
        totalAmount = '0';
        _newOrderController.totalAmountStream(true);
      } else {
        totalAmount = commonController
                .orderstocklistmodel.value?.data.orderListItem?.total
                .toString() ??
            '0';
        _newOrderController.totalAmountStream(true);
      }
    }, userLineId: lineid);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await commonController.getuserlinereport(lineid.toString());
        Get.toNamed('/newstock', arguments: {'id': lineid, 'status': true});
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: RefreshIndicator(
          onRefresh: () {
            return refreshValue();
          },
          child: Obx(() {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(120, 89, 207, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20.0,
                          0.0,
                          20.0,
                          20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        await commonController
                                            .getuserlinereport(
                                                lineid.toString());
                                        Get.toNamed('/newstock', arguments: {
                                          'id': lineid,
                                          'status': true
                                        });
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
                                    'ரசீதுகள்',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                250, 250, 250, 1),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: routeDropdownValue.isEmpty
                                                ? null
                                                : routeDropdownValue,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                routeDropdownValue = newValue!;
                                                storeDropdownValue = '';
                                              });
                                              print(commonController
                                                  .pathId![routeDropdownValue]
                                                  .toString());
                                              commonController.getPathStore(
                                                  commonController.pathId![
                                                          routeDropdownValue]
                                                      .toString());
                                            },
                                            hint: const Text(
                                              'பாதையை தேர்வு செய்க',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                            icon: Image.asset(
                                              'assets/images/arrowdown.png',
                                              width: 13,
                                            ),
                                            items: commonController.pathName!
                                                .map((id, name) {
                                                  return MapEntry(
                                                    id,
                                                    DropdownMenuItem<String>(
                                                      value: name,
                                                      child: Text(name),
                                                    ),
                                                  );
                                                })
                                                .values
                                                .toList(),
                                            underline: Container(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                250, 250, 250, 1),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: storeDropdownValue.isEmpty
                                                ? null
                                                : storeDropdownValue,
                                            onChanged:
                                                (String? newValue) async {
                                              // setState(() async {
                                              storeDropdownValue = newValue!;
                                              storeId = commonController
                                                  .storeId![storeDropdownValue]
                                                  .toString();
                                              commonController
                                                  .getshoworderstocklist(
                                                      withLoader: false,
                                                      search: categoryId,
                                                      storeId: commonController
                                                          .storeId![
                                                              storeDropdownValue]
                                                          .toString());
                                              await commonController
                                                  .Getorderstocklist(
                                                      userLineId: lineid,
                                                      commonController.storeId![
                                                              storeDropdownValue]
                                                          .toString());
                                              print(commonController
                                                  .storeId![storeDropdownValue]
                                                  .toString());
                                              // commonController.getOrderList(
                                              //     commonController.storeId![
                                              //             storeDropdownValue]
                                              //         .toString());
                                              if (commonController
                                                      .newstockorderlist ==
                                                  false) {
                                                totalAmount = '0';
                                              } else {
                                                setState(() {
                                                  totalAmount = commonController
                                                          .orderstocklistmodel
                                                          .value
                                                          ?.data
                                                          .orderListItem
                                                          ?.total
                                                          .toString() ??
                                                      '0';
                                                });
                                              }
                                              setState(() {});
                                              // });
                                            },
                                            hint: const Text(
                                              'கடையைத் தேர்ந்தெடுக்கவும்',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                            icon: Image.asset(
                                              'assets/images/arrowdown.png',
                                              width: 13,
                                            ),
                                            items: commonController.storeName!
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
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
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
                                          if (storeDropdownValue
                                              .isNotEmpty) ...[
                                            if (commonController
                                                        .newstocklistmodel
                                                        .value
                                                        ?.data ==
                                                    null ||
                                                commonController
                                                    .newstocklistmodel
                                                    .value!
                                                    .data
                                                    .isEmpty) ...[
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              const Text(
                                                'பொருட்கள் எதுவும் இல்லை',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                            StreamBuilder(
                                                stream: _newOrderController
                                                    .totalAmountStreamController,
                                                builder: (context, snapshot) {
                                                  return Container(
                                                    child: GridView.builder(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio:
                                                            16 / 26,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 15,
                                                      ),
                                                      itemCount: commonController
                                                              .newstocklistmodel
                                                              .value
                                                              ?.data
                                                              .length ??
                                                          0,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return buildProduct(
                                                            commonController
                                                                .newstocklistmodel
                                                                .value!
                                                                .data[index]);
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ] else ...[
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            const Center(
                                                child: Text(
                                              'பாதைகள் மற்றும் கடைகளை தேர்தெடுக்கவும்',
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
                            ]),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: _newOrderController.totalAmountStreamController,
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
                              Text(
                                'மொத்தம் ₹ ' + totalAmount.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              const VerticalDivider(
                                color: Colors.white,
                                thickness: 3.0,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (storeDropdownValue.isEmpty) {
                                      showToast('கடையைத் தேர்ந்தெடுக்கவும்');
                                    } else {
                                      await commonController.Getorderstocklist(
                                          userLineId: lineid,
                                          commonController
                                              .storeId![storeDropdownValue]
                                              .toString());
                                      Get.toNamed('/confirmorderlist',
                                          arguments: {
                                            'id': commonController
                                                .storeId![storeDropdownValue]
                                                .toString(),
                                            'lineid': lineid,
                                            'totalAmount': totalAmount,
                                            'newOrderPageController':
                                                _newOrderController
                                          })?.then(
                                        (value) async {
                                          refreshValue();
                                        },
                                      );
                                      ;
                                    }
                                  },
                                  child: const Text(
                                    'ஆர்டர் பட்டியல்',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget button(int index, Category data) {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        setState(() async {
          _selectedValueIndex = index;
          await commonController.Getorderstocklist(
              commonController.storeId![storeDropdownValue].toString());
          commonController.getshoworderstocklist(
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

  InkWell buildProduct(Datum data) {
    return InkWell(
      onTap: () async {
        setState(() {
          stringamount = data.price.toString() ?? '0';
          productAmount = double.parse(stringamount) ?? 0.0;
          totalquantity = data.quantity; // int.parse(data.quantity);
          // pendingQuantity.text = '0';
          print(totalquantity);
          Amount.clear();
          quantity = 0;
        });

        await _getProductDetails(data);

        _PopupMenu(data.quantity, data.name ?? '', productAmount,
            data.productId.toString() ?? '');

        print(totalquantity);
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height / 3,
        // padding: EdgeInsets.all(0),
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
                  data.name,
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
                  data.image,
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
                  '₹ ' + data.price.toString(),
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
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
                  'Qty ' + data.quantity.toString(),
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

  Column buildItem() {
    return const Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: SelectableText(
                  'Amul Milk',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SelectableText(
                '1',
                style: TextStyle(fontSize: 15),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      '₹ 52',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1.0,
        ),
      ],
    );
  }

  void _PopupMenu(
      int itemQuantity, String name, double amount, String productid) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return StreamBuilder(
                stream: _newOrderController.productDialogStreamController,
                builder: (context, snapshot) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        Container(
                          height: 480,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
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
                                                const Text(
                                                  'விலை',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: SelectableText(
                                                          ' ₹  |',
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          amount.toString(),
                                                          style:
                                                              const TextStyle(
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
                                                const Text(
                                                  'மொத்த விலை',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: SelectableText(
                                                          ' ₹  |',
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          finalAmount
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
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
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'நிலுவை அளவு',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color.fromRGBO(
                                              250, 250, 250, 1),
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Form(
                                          child: TextFormField(
                                            controller: pendingQuantity,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  8),
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'நிலுவை அளவை உள்ளிடவும்',
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
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'அளவு',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color.fromRGBO(
                                              250, 250, 250, 1),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Form(
                                          key: _formKey1,
                                          child: TextFormField(
                                            enabled: itemQuantity == 0
                                                ? false
                                                : true,
                                            controller: Amount,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  8),
                                            ],
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              if ((int.tryParse(Amount.text) ??
                                                      0) <=
                                                  itemQuantity) {
                                                setState(() {
                                                  finalAmount = amount *
                                                      (double.tryParse(
                                                              Amount.text) ??
                                                          0);
                                                  quantity = int.tryParse(
                                                          Amount.text) ??
                                                      0;
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            120, 89, 217, 1),
                                                    textColor: Colors.white,
                                                    msg:
                                                        'நீங்கள் வரம்பு மீறுகிறீர்கள். அளவை சரிபார்க்கவும் $itemQuantity');
                                              }
                                              /*setState(() {
                                              doubleamount = double.parse(value);
                                              if (doubleamount <= totalquantity) {
                                                finalAmount =
                                                    doubleamount * productAmount;
                                                quantity = int.tryParse(value) ?? 0;
                                                finalAmount =
                                                    quantity * productAmount;
                                                print('double $doubleamount');
                                                print('final $finalAmount');
                                              }
                                            });*/
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
                                  height: 15.0,
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
                                            color: const Color.fromRGBO(
                                                250, 250, 250, 1),
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            )),
                                        child: const Center(
                                          child: Icon(
                                            Icons.remove_rounded,
                                            size: 25,
                                            color:
                                                Color.fromRGBO(71, 52, 125, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Container(
                                      height: 40,
                                      constraints:
                                          const BoxConstraints(minWidth: 60),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color.fromRGBO(
                                            120, 89, 207, 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$quantity',
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (quantity < totalquantity) {
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
                                            color: const Color.fromRGBO(
                                                250, 250, 250, 1),
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                            )),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 25,
                                            color:
                                                Color.fromRGBO(71, 52, 125, 1),
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
                                          if ((int.tryParse(Amount.text) ??
                                                  0) <=
                                              itemQuantity) {
                                            if (quantity <= totalquantity &&
                                                quantity > 0) {
                                              submit(productid);
                                            }
                                            if (pendingQuantity.text != '0' &&
                                                pendingQuantity
                                                    .text.isNotEmpty) {
                                              submitPending(productid);
                                            } else if (pendingQuantity
                                                    .text.isEmpty ||
                                                pendingQuantity.text == '' ||
                                                pendingQuantity.text == '0') {
                                              pendingQuantity.text == '';
                                              submitPending(productid);
                                            }
                                            Navigator.pop(context);
                                          } else {
                                            showToast(
                                                'அளவை சரிபார்க்கவும் $itemQuantity');
                                          }
                                        },
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
          },
        );
      },
    );
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
            child: Text(
              ' ₹  |',
              style:
                  TextStyle(fontSize: 22, color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Expanded(
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
        ],
      ),
    );
  }

  Widget dropdownbuild() {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: DropdownButton<String>(
        isExpanded: true,
        value: routeDropdownValue.isEmpty ? null : routeDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            routeDropdownValue = newValue!;
          });
        },
        hint: const Text(
          'பாதையை தேர்வு செய்க',
          style: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black),
        icon: Image.asset(
          'assets/images/arrowdown.png',
          width: 15,
        ),
        items: commonController.pathName!
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
    );
  }

  void submit(String productId) async {
    if (routeDropdownValue.isEmpty) {
      showToast('வழியைத் தேர்ந்தெடுக்கவும்');
    } else if (storeDropdownValue.isEmpty) {
      showToast('கடையைத் தேர்ந்தெடுக்கவும்');
    } else if (productId.isEmpty) {
      return;
    } else {
      if (_formKey1.currentState!.validate()) {
        try {
          Map<String, dynamic> newData = {
            'path_id': commonController.pathId![routeDropdownValue].toString(),
            'store_id':
                commonController.storeId![storeDropdownValue].toString(),
            'product_id': productId,
            'quantity': quantity.toString(),
          };

          dynamic response = await CommonService().orderstockList(newData);

          if (response['status'] == 1) {
            showToast(response['message']);
            await commonController.getshoworderstocklist(
                withLoader: false, search: categoryId, storeId: storeId);
            // Get.toNamed('/neworderscreen');
            setState(() {
              totalAmount = response['total_amount'].toString();
              quantity = 0;
              Amount.text = '0';
              finalAmount = 0;
              // finalAmount += int.parse(totalAmount);
              print(totalAmount);
            });
          } else {
            if (response['message'] == 'உங்கள் அளவை சரிபார்க்கவும்') {
              print('Quantity 0');
            } else {
              showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
            }
          }
        } catch (error) {
          print('Error: $error');
          showToast('பிழை ஏற்பட்டது');
        }
      }
    }
  }

  void submitPending(String productId) async {
    Map<String, dynamic> newData = {
      'path_id': commonController.pathId![routeDropdownValue].toString(),
      'store_id': commonController.storeId![storeDropdownValue].toString(),
      'product_id': productId,
      'pending': pendingQuantity.text.toString(),
      'line_id': lineid,
    };
    try {
      dynamic response = await CommonService().pendingorderstockList(newData);
      if (response['status'] == 1) {
        print('Pending order successfull');
        showToast(response['message']);
        setState(() {
          pendingQuantity.clear();
        });
      }
    } catch (error) {
      print('Error: $error');
      // showToast('பிழை ஏற்பட்டது');
    }
  }

  Future<bool> _getProductDetails(Datum data) async =>
      await commonController.Getorderstocklist(
        commonController.storeId![storeDropdownValue].toString(),
        userLineId: lineid,
        callBackFunction: (statusCode) {
          if (statusCode == 1) {
            _getProductAmountAndQuantity(data);
            _getProductPendingQuantity(data);
          } else {
            pendingQuantity.text = '';
            quantity = 0;
            _newOrderController.productDialogStream(true);
          }
        },
      );

  void _getProductAmountAndQuantity(Datum data) {
    List<OrderStockListModelFinalDatum> orderList = commonController
            .orderstocklistmodel.value?.data.orderListItem?.finalData ??
        [];
    if (orderList.isNotEmpty) {
      for (OrderStockListModelFinalDatum i in orderList) {
        if (int.tryParse(i.productId) == data.productId) {
          quantity = int.tryParse(i.quantity) ?? 0;
          Amount.text = i.quantity ?? '';
          doubleamount = double.parse(Amount.text);
          finalAmount = doubleamount * productAmount;
          quantity = int.tryParse(Amount.text) ?? 0;
          finalAmount = quantity * productAmount;
          _newOrderController.productDialogStream(true);
          break;
        } else {
          quantity = 0;
          Amount.text = '';
          finalAmount = 0;
          _newOrderController.productDialogStream(true);
        }
      }
    } else {
      quantity = 0;
      Amount.text = '';
      finalAmount = 0;
      _newOrderController.productDialogStream(true);
    }
  }

  void _getProductPendingQuantity(Datum data) {
    List<OrderStockListModelFinalDatum>? pendingList = commonController
        .orderstocklistmodel.value?.data.pendingListItem?.finalData;
    if (pendingList?.isNotEmpty == true) {
      for (OrderStockListModelFinalDatum i in pendingList ?? []) {
        if (int.tryParse(i.productId) == data.productId) {
          pendingQuantity.text = i.pending.toString();
          _newOrderController.productDialogStream(true);
          break;
        } else {
          pendingQuantity.text = '';
        }
      }
    } else {
      pendingQuantity.text = '';
    }
    debugPrint('the quantity is ********* ${pendingQuantity.text}');
  }
}

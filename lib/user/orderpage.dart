import 'package:billing_app/Models/orderdelivery_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/user/user_controller/user_order_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Models/orderlist_model.dart';
import '../Models/tomorroworderlist_model.dart';

//const List<String> list = <String>[];

class order_screen extends StatefulWidget {
  const order_screen({super.key});

  @override
  State<order_screen> createState() => _order_screenState();
}

class _order_screenState extends State<order_screen> {
  List<String> list = <String>[];
  String routeDropdownValue = '';
  String storeDropdownValue = '';
  String dayDropdownValue = '';
  String stringamount = '0';
  double productAmount = 0;
  double doubleamount = 0.0;
  double finalAmount = 0;
  int quantity = 0;
  String price = '';
  int? id;
  String? storeId;
  String? categoryId;

  int? _selectedValueIndex;
  String totalAmount = '0';
  Map<String, String> day = {'indru': 'today', 'naalai': 'tomorrow'};
  List<String> buttonText = ['All', 'Milk', 'Cool Drinks', 'Chips', 'Others'];
  List<String> days = ['இன்று', 'நாளை'];
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();

  // final TextEditingController quantity = TextEditingController();
  final TextEditingController Amount = TextEditingController();
  final _userOrderPageController = UserOrderPagerControllerImpl();

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

  Future<void> refreshValue() async {
    Future.delayed(const Duration(milliseconds: 1000));
    _screenUpdate(dayValue: dayDropdownValue);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _screenUpdate(dayValue: dayDropdownValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/home');
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
                                        onTap: () {
                                          Get.toNamed('/home');
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
                                      'ஆர்டர் டெலிவரி',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      // showCursor: true,
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          250, 250, 250, 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dayDropdownValue.isEmpty
                                          ? null
                                          : dayDropdownValue,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dayDropdownValue = newValue!;
                                          _screenUpdate(
                                              dayValue: dayDropdownValue);
                                        });
                                      },
                                      hint: const Text(
                                        'நாள்',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      icon: Image.asset(
                                        'assets/images/arrowdown.png',
                                        width: 13,
                                      ),
                                      items: days.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      // items: day
                                      //     .map((id, name) {
                                      //       return MapEntry(
                                      //           id,
                                      //           DropdownMenuItem<String>(
                                      //             value: name,
                                      //             child: Text(name),
                                      //           ));
                                      //     })
                                      //     .values
                                      //     .toList(),
                                      underline: Container(),
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
                                                  return button(index,
                                                      category[index - 1]);
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
                                    child: Column(
                                      children: [
                                        Container(
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
                                                      ));
                                                })
                                                .values
                                                .toList(),
                                            underline: Container(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
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
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                storeDropdownValue = newValue!;
                                                commonController.getOrderDelivery(
                                                    withLoader: true,
                                                    search: categoryId,
                                                    storeid: commonController
                                                        .storeId![
                                                            storeDropdownValue]
                                                        .toString());
                                                _screenUpdate(
                                                    dayValue: dayDropdownValue);
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
                                        color:
                                            Color.fromRGBO(120, 89, 207, 0.05),
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30)),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            if (storeDropdownValue.isNotEmpty &&
                                                dayDropdownValue
                                                    .isNotEmpty) ...[
                                              Container(
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
                                                  itemBuilder:
                                                      (context, index) {
                                                    return buildProduct(
                                                        commonController
                                                            .orderdeliverymodel
                                                            .value!
                                                            .data
                                                            .product[index]);
                                                  },
                                                ),
                                              ),
                                            ] else ...[
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Center(
                                                  child: Text(
                                                commonController.storeName!
                                                            .isEmpty &&
                                                        routeDropdownValue
                                                            .isNotEmpty
                                                    ? 'பாதையில் கடைகள் எதுவும் இல்லை'
                                                    : 'நாள் , பாதைகள் மற்றும் கடைகளை தேர்தெடுக்கவும்',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  )),
                                ],
                              ]),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                      stream:
                          _userOrderPageController.totalAmountStreamController,
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
                                  'மொத்தம் ₹ ' + totalAmount.toString(),
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
                                      } else if (dayDropdownValue.isEmpty) {
                                        showToast('நாள் தேர்ந்தெடுக்கவும்');
                                      } else {
                                        await commonController.getOrderList(
                                            commonController
                                                .storeId![storeDropdownValue]
                                                .toString());
                                        await commonController
                                            .getTomorrowOrderList(
                                                commonController.storeId![
                                                        storeDropdownValue]
                                                    .toString());
                                        Get.toNamed('/orderlist', arguments: {
                                          'id': commonController
                                              .storeId![storeDropdownValue]
                                              .toString(),
                                          'day': dayDropdownValue
                                        })?.then(
                                          (value) async {
                                            refreshValue();
                                          },
                                        );
                                      }
                                      print(commonController
                                          .storeId![storeDropdownValue]
                                          .toString());
                                      print('object');
                                      print(
                                          commonController.storeId.toString());
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
          )),
    );
  }

  filterShops(
    String id,
  ) async {
    commonController.getPathStore(id);
  }

  Widget button(int index, Category data) {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        setState(() {
          _selectedValueIndex = index;
          categoryId = data.categoryId.toString();
          commonController.getOrderDelivery(
              withLoader: true,
              search: categoryId,
              storeid:
                  commonController.storeId![storeDropdownValue].toString());
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

  InkWell buildProduct(Product product) {
    return InkWell(
      onTap: () async {
        setState(() {
          stringamount = product.amount;
          productAmount = double.parse(stringamount);
          print(productAmount);
        });
        await _getProductDetails(product);
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
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
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

  Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        buildItem(),
                        const SizedBox(
                          height: 30,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 53.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('மொத்தம்'), Text('₹ 399')],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .07,
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
                      const Text(
                        '₹ 399',
                        style: TextStyle(color: Colors.white),
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
                        onTap: () {},
                        child: const Text(
                          'ஸ்டாக் உறுதி',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  void _PopupMenu(String name, double amount, String pruductId) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return StreamBuilder(
                stream: _userOrderPageController.productDialogStreamController,
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
                                        color: const Color.fromRGBO(
                                            250, 250, 250, 1),
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
                                              finalAmount =
                                                  doubleamount * productAmount;
                                              quantity =
                                                  int.tryParse(value) ?? 0;
                                              finalAmount =
                                                  quantity * productAmount;
                                              print('double $doubleamount');
                                              print('final $finalAmount');
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
                                          color: const Color.fromRGBO(
                                              250, 250, 250, 1),
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
                                    constraints:
                                        const BoxConstraints(minWidth: 60),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
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
                                  ),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color.fromRGBO(
                                              250, 250, 250, 1),
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
                                        submit(pruductId);
                                        // print(pruductId);
                                        Navigator.pop(context);
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
    if (dayDropdownValue.isEmpty) {
      showToast('தயவுசெய்து நாளைத் தேர்ந்தெடுக்கவும்');
    } else if (routeDropdownValue.isEmpty) {
      showToast('வழியைத் தேர்ந்தெடுக்கவும்');
    } else if (storeDropdownValue.isEmpty) {
      showToast('கடையைத் தேர்ந்தெடுக்கவும்');
    } else {
      if (_formKey1.currentState!.validate()) {
        try {
          Map<String, dynamic> newData = {
            'path_id': commonController.pathId![routeDropdownValue].toString(),
            'store_id':
                commonController.storeId![storeDropdownValue].toString(),
            'product_id': productId,
            'quantity': quantity.toString(),
            'day': dayDropdownValue,
          };
          dynamic response = await CommonService().createOrderList(newData);
          if (response['status'] == 1) {
            showToast(response['message']);
            // await commonController.getOrderDelivery(withLoader: true);
            // Get.toNamed('/orderscreen');
            setState(() {
              _screenUpdate(dayValue: dayDropdownValue);
              quantity = 0;
              Amount.text = '0';
              finalAmount = 0;
              // finalAmount += int.parse(totalAmount);
              print(totalAmount);
            });
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

  Future<void> _screenUpdate({String? dayValue}) async {
    print('the day value is $dayValue');
    if (dayValue == 'இன்று') {
      await commonController.getOrderList(
              commonController.storeId![storeDropdownValue].toString())
          ? totalAmount = commonController
              .orderListModel.value!.data.orderListItem.total
              .toString()
          : totalAmount = '0';
      _userOrderPageController.totalAmountStream(true);
    } else {
      await commonController.getTomorrowOrderList(
              commonController.storeId![storeDropdownValue].toString())
          ? totalAmount = commonController
              .tomorrowOrderListModel.value!.data.orderListItem.total
              .toString()
          : totalAmount = '0';
      _userOrderPageController.totalAmountStream(true);
    }
  }

  Future<void> _getProductDetails(Product product) async {
    if (dayDropdownValue == 'இன்று') {
      await commonController.getOrderList(
        commonController.storeId![storeDropdownValue].toString(),
        callBackFunction: (statusCode) {
          _getTheQuantityAndAmountFromResponse(statusCode, product,
              isTodayModel: true);
        },
      );
    } else {
      debugPrint('inside the tom');
      await commonController.getTomorrowOrderList(
        commonController.storeId![storeDropdownValue].toString(),
        callBackFunction: (statusCode) {
          _getTheQuantityAndAmountFromResponse(statusCode, product,
              isTodayModel: false);
        },
      );
    }
  }

  void _getTheQuantityAndAmountFromResponse(int statusCode, Product product,
      {bool? isTodayModel = false}) {
    List<FinalDatum>? orderListItemModel =
        commonController.orderListModel.value?.data.orderListItem.finalData;

    List<TomorrowFinalDatum>? tomorrowFinalData = commonController
        .tomorrowOrderListModel.value?.data.orderListItem.tomorrowFinalData;

    if (statusCode == 1) {
      List<dynamic> listToIterate = isTodayModel == true
          ? (orderListItemModel ?? [])
          : (tomorrowFinalData ?? []);
      for (var i in listToIterate) {
        if (int.tryParse(i.productId) == product.productId) {
          quantity = int.tryParse(i.quantity) ?? 0;
          Amount.text = i.quantity ?? '';
          doubleamount = double.parse(Amount.text);
          finalAmount = doubleamount * productAmount;
          quantity = int.tryParse(Amount.text) ?? 0;
          finalAmount = quantity * productAmount;
          _userOrderPageController.productDialogStream(true);
          debugPrint('the quantity is ********** $quantity');
          break;
        } else {
          quantity = 0;
          Amount.text = '';
          finalAmount = 0;
          _userOrderPageController.productDialogStream(true);
          debugPrint('inside the for else ******** ');
        }
      }
    } else {
      quantity = 0;
      Amount.text = '';
      finalAmount = 0;
      _userOrderPageController.productDialogStream(true);
    }
  }
}

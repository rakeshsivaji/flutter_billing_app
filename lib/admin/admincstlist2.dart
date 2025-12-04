import 'package:billing_app/Models/orderdelivery_model.dart';
import 'package:billing_app/Models/stock_model.dart';
import 'package:billing_app/admin/controller/admin_cs_list_2_controller.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminCstList2 extends StatefulWidget {
  const AdminCstList2({super.key});

  @override
  State<AdminCstList2> createState() => _AdminCstList2State();
}

/*   CustomAppBar(
                    text: 'ஸ்டாக் பங்கு பட்டியல்', path: 'admincstlist'),*/
class _AdminCstList2State extends State<AdminCstList2>
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
  int? _selectedValueIndex;
  var commonController = Get.put(CommonController());

  // final TextEditingController amount = TextEditingController();
  final TextEditingController Amount = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  bool clicked = false;
  List<String> buttonText = [
    'அனைத்து',
    'பால்',
    'குளிர் பானங்கள்',
    'சிப்ஸ்',
    'மற்றவை'
  ];
  final _adminCs2listController = AdminCsList2ControllerImpl();

  @override
  void initState() {
    super.initState();
    if (commonController.stock == true) {
      totalAmount =
          commonController.stockModel.value!.data.stockItem.total.toString();
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
        Navigator.pop(context);
        // Get.toNamed('/admincstlist');
        // await commonController.getStockList();
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
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              /*await commonController.getStockList();
                              Get.toNamed('/admincstlist');*/
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'ஸ்டாக் பங்கு பட்டியல் உருவாக்கவும்',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 13,
                                backgroundColor:
                                    Color.fromRGBO(120, 89, 207, 1),
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
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
                              _buildDropDowns(),
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
                StreamBuilder(
                    stream: _adminCs2listController.totalAmountStreamController,
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
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                const VerticalDivider(
                                  color: Colors.white,
                                  thickness: 3.0,
                                ),
                                InkWell(
                                    onTap: () async {
                                      await commonController.getStock(
                                        callBackFunction: (statusCode) {
                                          if (statusCode == 0) {
                                            showToast(
                                                'ஸ்டாக் பட்டியல் காலியாக உள்ளது');
                                          } else if (statusCode == 1) {
                                            showBottomSheet(context);
                                          }
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'ஸ்டாக் பட்டியல்',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
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

  Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StreamBuilder(
            stream: _adminCs2listController.bottomSheetStreamController,
            builder: (context, snapshot) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Stack(
                      children: [
                        Obx(() {
                          return Column(
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
                                  child: Column(
                                    children: [
                                      if (commonController.stock == false) ...[
                                        const Text('வேறு தகவல்கள் இல்லை'),
                                      ] else ...[
                                        Container(
                                          child: ListView.builder(
                                            itemCount: commonController
                                                .stockModel
                                                .value!
                                                .data
                                                .stockItem
                                                .finalData
                                                .length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 53.0, right: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SelectableText('மொத்தம்',
                                                style: TextStyle(fontSize: 15)),
                                            if (commonController.stock ==
                                                false) ...[
                                              const SelectableText('₹ 0',
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                            ] else ...[
                                              SelectableText(
                                                  '₹ ' +
                                                      commonController
                                                          .stockModel
                                                          .value!
                                                          .data
                                                          .stockItem
                                                          .total
                                                          .toString(),
                                                  style:
                                                      const TextStyle(fontSize: 15))
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        Align(
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
                                const SelectableText(
                                  'மொத்தம்',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                if (commonController.stock == false) ...[
                                  const SelectableText('₹ 0',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                ] else ...[
                                  SelectableText('₹ ' + totalAmount,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white))
                                ],
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
                        ),
                      ],
                    ),
                  ),
                );
              });
            });
      },
    ).then(
      (value) async {
        await commonController.getStock(
          callBackFunction: (statusCode) {
            if (statusCode == 1) {
              totalAmount = commonController
                      .stockModel.value?.data.stockItem.total
                      .toString() ??
                  '';
              _adminCs2listController.totalAmountStream(true);
              _adminCs2listController.bottomSheetStream(true);
            } else if (statusCode == 0) {
              totalAmount = '0';
              _adminCs2listController.totalAmountStream(true);
              _adminCs2listController.bottomSheetStream(true);
            }
          },
        );
      },
    );
  }

  void _PopupMenu(String name, double amount, String productId) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return StreamBuilder(
                stream: _adminCs2listController.productDialogStreamController,
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
                                    // buildformfield(),
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
                                    InkWell(
                                      onTap: () {
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
                                      onTap: _adminCs2listController
                                                      .selectedPath ==
                                                  null ||
                                              _adminCs2listController
                                                      .selectedUser ==
                                                  null
                                          ? () {
                                              showToast(
                                                  'பணியாளரையும் வழியையும் சரிபார்க்கவும்');
                                            }
                                          : () {
                                              debugPrint(
                                                  'the ids are ${_adminCs2listController.selectedUser}');
                                              setState(() {
                                                prdtID = productId;
                                              });
                                              createStocklist(productId);
                                              Navigator.pop(context);
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

  // buildformfield() {
  //   return StatefulBuilder(builder: (context, setState) {
  //     return Container(
  //       height: 40,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         color: Color.fromRGBO(250, 250, 250, 1),
  //         border: Border.all(
  //           color: Colors.grey.withOpacity(0.5),
  //           width: 1.0,
  //         ),
  //       ),
  //       child: TextFormField(
  //         controller: Amount,
  //         keyboardType: TextInputType.number,
  //         onChanged: (value) {
  //           setState(() {
  //             doubleamount = double.parse(value);
  //             finalAmount = doubleamount * productAmount;
  //             quantity = int.tryParse(value) ?? 0;
  //             finalAmount = quantity * productAmount;
  //             print('double $doubleamount');
  //             print('final $finalAmount');
  //           });
  //         },
  //         decoration: InputDecoration(
  //           hintText: 'அளவை உள்ளிடவும்',
  //           hintStyle: const TextStyle(
  //             color: Colors.grey,
  //             fontSize: 14,
  //             fontWeight: FontWeight.normal,
  //           ),
  //           border: OutlineInputBorder(
  //             borderSide: BorderSide.none,
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: BorderSide.none,
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           fillColor: Color.fromRGBO(71, 52, 125, 1),
  //           contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
  //         ),
  //       ),
  //     );
  //   });
  // }

  Container rowMethod(label) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10), right: Radius.circular(10)),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: SelectableText(
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
                    // Navigator.pop(context);
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
                  child: SelectableText(
                    data.name,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                // SizedBox(
                //   width: 20.0,
                // ),
                Container(
                  width: 100,
                  child: Text(
                    data.quantity + ' x ' + data.price,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 2,
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
          // product.amount as double;
          finalAmount = productAmount * quantity;
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
                  _adminCs2listController.productDialogStream(true);
                  break;
                } else {
                  quantity = 0;
                  finalAmount = 0;
                  Amount.text = '';
                  _adminCs2listController.productDialogStream(true);
                }
              }
            } else {
              quantity = 0;
              finalAmount = 0;
              Amount.text = '';
              _adminCs2listController.productDialogStream(true);
            }
          },
        );
        setState(() {
          _PopupMenu(product.name, productAmount, product.productId.toString());
        });
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
                  '₹' + product.amount,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
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

  void createStocklist(String id) async {
    Map? map = {
      'product_id': id,
      'user_id': _adminCs2listController.selectedUser,
      'quantity': quantity.toString(),
    };
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
    Map? map = {
      'line_id': _adminCs2listController.selectedPath,
      'user_id': _adminCs2listController.selectedUser,
    };
    dynamic response = await CommonService().confirmStock(map);
    await commonController.getStock();
    _adminCs2listController.bottomSheetStream(true);
    if (response['status'] == 1) {
      showToast(response['data']);
      setState(() {
        totalAmount = '0';
      });
    } else if (response['status'] == 0) {
      showToast(response['data']);
    } else {
      showToast('பிழை ஏற்பட்டது');
    }
  }

  void deleteStock(String id) async {
    dynamic response = await CommonService().deleteStock(id);
    if (response['status'] == 1) {
      await commonController.getStock(
        callBackFunction: (statusCode) {
          if (statusCode == 1) {
            totalAmount = commonController
                    .stockModel.value?.data.stockItem.total
                    .toString() ??
                '';
            _adminCs2listController.totalAmountStream(true);
            _adminCs2listController.bottomSheetStream(true);
          } else if (statusCode == 0) {
            totalAmount = '0';
          }
        },
      );
      _adminCs2listController.bottomSheetStream(true);
      showToast(response['message']);
    } else {
      showToast('பிழை ஏற்பட்டது');
    }
  }

  Future<void> _refreshValues() async {
    await commonController.getStock(
      callBackFunction: (statusCode) {
        if (statusCode == 1) {
          totalAmount = commonController.stockModel.value?.data.stockItem.total
                  .toString() ??
              '';
          _adminCs2listController.totalAmountStream(true);
        } else {
          totalAmount = '0';
          _adminCs2listController.totalAmountStream(true);
        }
      },
    );
  }

  Widget _buildDropDowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildEmployeeDropdown(), _buildLineDropdown()],
      ),
    );
  }

  Widget _buildEmployeeDropdown() {
    return CustomDropDownButtonFormField(
      inputBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      fillColor: Colors.grey[200],
      width: MediaQuery.of(context).size.width / 2.4,
      height: 50,
      hintText: 'பணியாளரைத் தேர்ந்தெடுக்கவும்',
      onChange: (value) async {
        _adminCs2listController.selectedUser = value ?? '';
        _adminCs2listController.selectedPath = '';
        await commonController.getNoAccessUsersLines(
            userId: _adminCs2listController.selectedUser);
        _adminCs2listController.pathDropdownStream(true);
      },
      dropDownValue: _adminCs2listController.selectedUser,
      key: UniqueKey(),
      items: commonController.getNoAccessUsersAndLine.value?.data?.map((item) {
        return DropdownMenuItem<String?>(
          value: item.userId?.toString() ?? '',
          child: Text(
            item.name ?? '',
            style: GoogleFonts.nunitoSans(color: AppColors().blackColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLineDropdown() {
    return StreamBuilder(
        stream: _adminCs2listController.pathDropdownStreamController,
        builder: (context, snapshot) {
          return CustomDropDownButtonFormField(
            borderRadius: 20,
            inputBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            fillColor: Colors.grey[200],
            width: MediaQuery.of(context).size.width / 2.4,
            height: 50,
            hintText: 'வழியைத் தேர்ந்தெடுக்கவும்',
            onChange: (value) {
              _adminCs2listController.selectedPath = value ?? '';
            },
            key: UniqueKey(),
            dropDownValue: _adminCs2listController.selectedPath?.isEmpty == true
                ? null
                : _adminCs2listController.selectedPath,
            items: commonController.getNoAccessUsersLinesModel.value?.data
                    ?.map((item) {
                  return DropdownMenuItem<String?>(
                    value: item.lineId?.toString(),
                    child: Text(
                      item.name!,
                      style:
                          GoogleFonts.nunitoSans(color: AppColors().blackColor),
                    ),
                  );
                }).toList() ??
                [],
          );
        });
  }
}

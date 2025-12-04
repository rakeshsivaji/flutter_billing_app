import 'package:billing_app/Models/stocklist_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Cstlist extends StatefulWidget {
  const Cstlist({super.key});

  @override
  State<Cstlist> createState() => _CstlistState();
}

class _CstlistState extends State<Cstlist> {
  var commonController = Get.put(CommonController());
  TextEditingController quantityController = TextEditingController();
  String lineid = '';
  bool edit = false;
  String stockId = '';
  String productId = '';
  String totalAmount = '0';
  String stringamount = '0';
  double productAmount = 0;
  double doubleamount = 0.0;
  double finalAmount = 0;
  int quantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lineid = Get.arguments['id'];
    debugPrint(
        'the condtion is ******** ${commonController.adminprofilemodel.value?.data.stockCreate == 'ஆம்'}');
    debugPrint(
        'the condtion is ******** ${commonController.stockListModel.value?.data.isEdit}');
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
          appBar: AppBar(
            leading: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await commonController.getuserlinereport(lineid.toString());
                  Get.toNamed('/newstock',
                      arguments: {'id': lineid, 'status': true});
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: const Text(
              'ஸ்டாக்ஸ்',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: InkWell(
                  onTap: () async {
                    await commonController.getStockHistory(withLoader: false);
                    Get.toNamed('/stlisthistory', arguments: {'id': lineid});
                    //Navigator.pushReplacementNamed(context, '/stlisthistory');
                  },
                  child: const Text(
                    'வரலாறு',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
            titleSpacing: -2.0,
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  // height: 850,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        commonController
                                    .stockListModel.value?.data.isPlusShow ==
                                false
                            ? Container(
                                child: Obx(
                                  () {
                                    final stocklist = commonController
                                        .stockListModel.value?.data;
                                    if (stocklist == null ||
                                        commonController.stockList == false) {
                                      return const Center(
                                          child: Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text('பங்கு பட்டியல் இல்லை'),
                                      ));
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 1,
                                      padding: const EdgeInsets.all(0),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return buildCard(commonController
                                            .stockListModel.value!.data);
                                      },
                                    );
                                  },
                                ),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // floatingActionButtonLocation: edit
          //     ? FloatingActionButtonLocation.centerFloat
          //     : null,
          floatingActionButton: _buildFAB()),
    );
  }

  Widget buildCard(Data data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(120, 89, 217, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'மொத்த ஸ்டாக்குகளின் பட்டியல்',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    data.date,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0.5),
          const SizedBox(height: 10.0),
          Column(
            children: [
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.stockItem.length,
                  itemBuilder: (context, index) {
                    stockId = data.id.toString();
                    var stockData = data.stockItem[index];
                    return buildCardItem(stockData);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const Divider(height: 0.5),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              children: [
                edit
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            await commonController.getOrderDelivery(
                                withLoader: true);
                            Get.toNamed('/createstocklist', arguments: {
                              'id': lineid,
                              'isEdit': true,
                              'stockId': stockId
                            });
                            await commonController.getStock();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(120, 89, 207, 1),
                                borderRadius: BorderRadius.circular(6)),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'மொத்தம்',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          Text(
                            '₹ ${data.amount}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 10,
                ),
                edit
                    ? const SizedBox()
                    :
                    /*IntrinsicWidth(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        edit = !edit;
                      });
                  }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text(
                        'திருத்த',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),),
                )*/

                    commonController
                                .adminprofilemodel.value?.data.stockCreate ==
                            'ஆம்'
                        ? commonController.stockListModel.value!.data.isEdit ==
                                true
                            ? IntrinsicWidth(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      edit = !edit;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            120, 89, 207, 1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'திருத்த',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                        : const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _PopupMenu(StockItem item) {
    // var quantity = item.quantity;
    // var amount = item.amount;
    print('the quantity is ******* ${item.quantity}');
    quantity = int.parse(item.quantity.toString());
    quantityController.text = item.quantity.toString();
    finalAmount =
        double.parse(item.quantity) * double.parse(item.price.toString());
    double amount = double.parse(item.price.toString());
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
                            item.name,
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
                                                  item.price.toString(),
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
                                                  finalAmount.toString(),
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
                                child: TextFormField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(8),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      doubleamount = double.parse(value);
                                      finalAmount = doubleamount * amount;
                                      quantity = int.tryParse(value) ?? 0;
                                      finalAmount = quantity * amount;
                                      value.isEmpty ? quantity = 0 : null;
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
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    fillColor:
                                        const Color.fromRGBO(71, 52, 125, 1),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
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
                                setState(() {
                                  if (quantity > 0) {
                                    quantity--;
                                    finalAmount = quantity * amount;
                                    quantityController.text =
                                        quantity.toString();
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
                            Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromRGBO(120, 89, 207, 1),
                              ),
                              child: Center(
                                child: Text(
                                  quantity.toString(),
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
                                  quantityController.text = quantity.toString();
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    quantity = 0;
                                    quantityController.text = '0';
                                    finalAmount = 0;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 60,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
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
                                onTap: () async {
                                  setState(() {
                                    // prdtID = productId;
                                  });
                                  submit();
                                },
                                child: Container(
                                  width: 60,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        const Color.fromRGBO(120, 89, 207, 1),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'சரி',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
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
                            quantityController.text = '0';
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
        }).then(
      (value) async {
        await commonController.getUserProfile();
        await commonController.getStockListline(lineid);
        setState(() {});
      },
    );
  }

  Widget buildCardItem(StockItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: SelectableText(
                  item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                )),
                Text(
                  '${item.quantity} x ${item.price}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                edit
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              productId = item.productId ?? '';
                              _PopupMenu(item);
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Color.fromRGBO(120, 89, 207, 1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              productId = item.productId ?? '';
                              deleteSubmit();
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    : Text(
                        '₹ ${item.amount}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void deleteSubmit() async {
    dynamic response =
        await CommonService().deleteProductById(stockId, productId);
    ;
    if (response['status'] == 1) {
      showToast(response['data'] ?? '');
      // await commonController.getlineshow();
      await commonController.getStockListline(lineid);
    } else {
      showToast(response?['data'] ?? 'பிழை ஏற்பட்டது');
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

  void submit() async {
    dynamic response = CommonService()
        .userStockProductAdd(productId, stockId, quantityController.text);
    Navigator.pop(context);
    if (response['status'] == 1) {
      showToast(response['data'] ?? 'வெற்றிகரமாக உருவாக்கப்பட்டது!');
      // await commonController.getlineshow();
      await commonController.getStockListline(lineid);
      await commonController.getStock();
    } else {
      showToast(response?['data'] ?? 'பிழை ஏற்பட்டது');
    }
  }

  Widget _buildFAB() {
    return commonController.adminprofilemodel.value?.data.stockCreate == 'ஆம்'
        ? (commonController.stockListModel.value?.data.isPlusShow == true
            ? FloatingActionButton(
                onPressed: () async {
                  await commonController.getOrderDelivery(withLoader: true);
                  Get.toNamed(
                    '/createstocklist',
                    arguments: edit
                        ? {'id': lineid, 'isEdit': true, 'stockId': stockId}
                        : {'id': lineid},
                  );
                  await commonController.getStock();
                },
                backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : const SizedBox.shrink())
        : const SizedBox.shrink();
  }
}

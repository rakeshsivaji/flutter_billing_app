import 'package:billing_app/Models/pendingorder_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NewPendingOrder extends StatefulWidget {
  const NewPendingOrder({super.key});

  @override
  State<NewPendingOrder> createState() => _NewPendingOrderState();
}

class _NewPendingOrderState extends State<NewPendingOrder> {
  bool? isChecked = true;
  List<bool> ischecked = [];
  List<String> selectedProduct = [];
  String selectedId = '';
  String storeId = '';
  var commonController = Get.put(CommonController());

  @override
  void initState() {
    super.initState();
    storeId = Get.arguments['id'].toString();
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
        await commonController.getOrderList(storeId);
        await commonController.getTomorrowOrderList(storeId);
        Get.toNamed('/neworderlist', arguments: {'id': storeId});
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Stack(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
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
                                        .getOrderList(storeId);
                                    await commonController
                                        .getTomorrowOrderList(storeId);
                                    Get.toNamed('/neworderlist',
                                        arguments: {'id': storeId});
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
                                'நிலுவை ஆர்டர் பட்டியல்',
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Obx(() {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 25.0,
                            ),
                            const SelectableText('நிலுவையில் உள்ள பட்டியல்'),
                            const SizedBox(
                              height: 25.0,
                            ),
                            // commonController.pendingList
                            //     ? ListView.builder(
                            //         itemCount: commonController.pendingOrderModel
                            //             .value!.data.pendingItem.finalData.length,
                            //         shrinkWrap: true,
                            //         physics: NeverScrollableScrollPhysics(),
                            //         padding: EdgeInsets.all(0),
                            //         itemBuilder: ((context, index) {
                            //           ischecked.add(false);
                            //           return buildItem1(
                            //               index,
                            //               commonController
                            //                   .pendingOrderModel
                            //                   .value!
                            //                   .data
                            //                   .pendingItem
                            //                   .finalData[index]);
                            //         }))
                            //     : Text('No data Found'),
                            if (commonController.pendingList == true) ...[
                              Container(
                                child: Obx(
                                  () {
                                    final pending = commonController
                                        .pendingOrderModel
                                        .value
                                        ?.data
                                        .pendingItem
                                        .finalData;
                                    if (pending == null || pending.isEmpty) {
                                      return const Text(
                                          'நிலுவையில் உள்ள உத்தரவு இல்லை');
                                    }
                                    return ListView.builder(
                                        itemCount: pending.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: ((context, index) {
                                          ischecked.add(false);
                                          return buildItem1(
                                              index, pending[index]);
                                        }));
                                  },
                                ),
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
                                      child: SelectableText(
                                        'மொத்தம்',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SelectableText(
                                      '₹ ' +
                                          commonController.pendingOrderModel
                                              .value!.data.pendingItem.total
                                              .toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 100.0,
                              ),
                            ] else ...[
                              const Text('வேறு தகவல்கள் இல்லை'),
                            ],
                          ],
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  pendingOrderConfirm();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromRGBO(120, 89, 207, 1),
                  ),
                  child: const Center(
                      child: Text(
                    'நிலுவை உறுதி',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildItem1(int index, FinalDatum data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Row(
            children: [
              Checkbox(
                activeColor: const Color.fromRGBO(120, 89, 207, 1),
                value: ischecked[index],
                onChanged: (value) {
                  setState(() {
                    ischecked[index] = value!;
                    ischecked[index]
                        ? selectedProduct.add(data.productId)
                        : selectedProduct.remove(data.productId);
                    print(selectedProduct);
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
              SelectableText(
                data.quantity,
                style: const TextStyle(fontSize: 15),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SelectableText(
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

  void pendingOrderConfirm() async {
    String finalIds = '';
    finalIds = selectedProduct.map((item) => item.toString()).join(',');
    print(finalIds);
    if (finalIds.isNotEmpty) {
      dynamic response =
          await CommonService().pendingOrderConfirm(storeId, finalIds);
      try {
        if (response['status'] == 1) {
          showToast('ஆர்டர் வெற்றிகரமாக வைக்கப்பட்டது');
          await commonController.getOrderList(storeId);
          Get.toNamed('/neworderlist', arguments: {'id': storeId});
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

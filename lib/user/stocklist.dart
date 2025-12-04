import 'package:billing_app/Models/Newstocklist_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Stocklist extends StatefulWidget {
  const Stocklist({super.key});

  @override
  State<Stocklist> createState() => _StocklistState();
}

class _StocklistState extends State<Stocklist> {
  var commonController = Get.put(CommonController());

  Future<void> refreshvalue() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await commonController.getAdminStockList();
    print('Value');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/home');
        return false;
      },
      child: RefreshIndicator(
        onRefresh: refreshvalue,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          // appBar: AppBar(
          //   leading: GestureDetector(
          //     onTap: () {
          //       Navigator.pushReplacementNamed(context, '/billentries');
          //     },
          //     child: const Icon(
          //       Icons.arrow_back_ios_new_rounded,
          //       size: 18,
          //       color: Colors.white,
          //     ),
          //   ),
          //   title: const Text(
          //     'ஸ்டாக் பட்டியல்',
          //     style: TextStyle(color: Colors.white, fontSize: 15),
          //   ),
          //   backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          //   titleSpacing: -2.0,
          // ),
          body: Obx(() {
            return Column(
              children: [
                CustomAppBar(text: 'ஸ்டாக் பட்டியல்', path: '/home'),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            buildCard(context),
                            commonController.stockList == false
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () async {
                                      await commonController.getOrderDelivery(
                                          withLoader: true);
                                      await commonController.getShops(
                                          withLoader: true);
                                      await commonController
                                          .getAdminStockListShow(
                                              withLoader: true);
                                      Get.toNamed('/stocklist2');
                                    },
                                    child: Container(
                                      width: 180,
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color.fromRGBO(120, 89, 207, 1),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'ரசீது உள்ளீடுகள்',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Container buildCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: SelectableText(
                      'மொத்த ஸ்டாக்குகளின் பட்டியல்',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  if (commonController.stockList == false) ...[
                    const SelectableText(
                      '',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ] else ...[
                    SelectableText(
                      commonController.stockListModel.value!.data.date,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(
            height: 0.5,
          ),
          const SizedBox(
            height: 10.0,
          ),
          if (commonController.stockList == false) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text('வேறு தகவல்கள் இல்லை'),
            ),
          ] else ...[
            ListView.builder(
                itemCount:
                    commonController.newstocklistmodel.value?.data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: ((context, index) {
                  return buildCardItem(
                      commonController.newstocklistmodel.value?.data[index]);
                })),
          ],
          // Container(
          //   child: Obx(
          //     () {
          //       final stocks =
          //           commonController.stockListModel.value!.data.stockItem;
          //       if (stocks == null || stocks.isEmpty) {
          //         return Text("No pending Order");
          //       }
          //       return ListView.builder(
          //           itemCount: stocks.length,
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           padding: EdgeInsets.all(0),
          //           itemBuilder: ((context, index) {
          //             return buildCardItem(stocks[index]);
          //           }));
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 5.0,
          ),
          const Divider(height: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SelectableText(
                  'மொத்தம்',
                  style: TextStyle(fontSize: 15),
                ),
                if (commonController.stockList == false) ...[
                  const Text(
                    '₹ 0',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ] else ...[
                  Text(
                    '₹ ' +
                        (commonController.newstocklistmodel.value?.data
                                .map((e) =>
                                    e.price *
                                    e.quantity)
                                .reduce((sum, element) => sum + element)
                                .toString() ??
                            ''),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCardItem(Datum? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SelectableText(data?.name ?? '')),
                SelectableText((data?.quantity.toString() ?? '') +
                    ' x ' +
                    (data?.price.toString() ?? '')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SelectableText(
                    '₹ ${(data?.price ?? 0) * (data?.quantity ?? 0)}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

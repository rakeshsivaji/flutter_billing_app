import 'dart:io';

import 'package:billing_app/Models/billdetails_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Billdetails2 extends StatefulWidget {
  const Billdetails2({super.key});

  @override
  State<Billdetails2> createState() => _Billdetails2State();
}

class _Billdetails2State extends State<Billdetails2> {
  var commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(120, 89, 207, 1),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
                              Navigator.pop(context);
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
                          'ரசிது விவரங்கள்',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          /*_PopupMenu();
                          _download();*/
                          Get.toNamed('/billDetails2ReceiptAdmin', arguments: {
                            'data':
                                commonController.billdetailsmodel.value?.data
                          });
                        },
                        child: Image.asset(
                          'assets/images/print.png',
                          width: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      )
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        // _PopupMenu();
                      },
                      child: buildCard(),
                      // child: Container(
                      //   child: Obx(() {
                      //     final allbillentry =
                      //         commonController.billdetailsmodel.value?.data;
                      //     if (allbillentry == null || allbillentry.isEmpty) {
                      //       return Text('No Paths are available.');
                      //     }
                      //     return ListView.builder(
                      //       itemCount: allbillentry.length,
                      //       shrinkWrap: true,
                      //       physics: NeverScrollableScrollPhysics(),
                      //       padding: EdgeInsets.all(0),
                      //       itemBuilder: ((context, index) {
                      //         return buildCard(allbillentry[index]);
                      //       }),
                      //     );
                      //   }),
                      // ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(120, 89, 217, 0.05),
        borderRadius: BorderRadius.circular(12),
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
                  SelectableText(
                    commonController
                            .billdetailsmodel.value?.data.order.orderNo ??
                        '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    commonController.billdetailsmodel.value?.data.order.date ??
                        '',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: SelectableText(
                  commonController.billdetailsmodel.value?.data.pathName ?? '',
                  style: const TextStyle(fontSize: 13),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: SelectableText(
                  commonController
                          .billdetailsmodel.value?.data.store.storeName ??
                      '',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: SelectableText(
                  commonController
                          .billdetailsmodel.value?.data.store.storeAddress ??
                      '',
                  style: const TextStyle(fontSize: 13),
                ),
              )),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Divider(
            height: 0.5,
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text('ரசிது விவரங்கள்'),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            child: Obx(() {
              final billdetails =
                  commonController.billdetailsmodel.value?.data.orderItem;
              if (billdetails == null || billdetails.isEmpty) {
                return const Text('பாதைகள் எதுவும் இல்லை.');
              }
              return ListView.builder(
                itemCount: billdetails.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: ((context, index) {
                  return buildCardItem(billdetails[index]);
                }),
              );
            }),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Divider(
            height: 0.5,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'மொத்தம்',
                  style: TextStyle(fontSize: 15),
                ),
                SelectableText(
                  '₹ ' +
                      (commonController.billdetailsmodel.value?.data.totalAmount
                              .toString() ??
                          ''),
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          _buildTotalRow(
              'நிலுவையில் உள்ள தொகை',
              '₹ ${commonController.billdetailsmodel.value?.data.pendingAmount.toString() ?? ''}',
              Colors.red),
          const SizedBox(
            height: 10,
          ),
          _buildTotalRow(
              'மொத்த கட்டணத் தொகை',
              '₹ ${commonController.billdetailsmodel.value?.data.totalPaymentAmount.toString() ?? ''}',
              Colors.green),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Padding buildCardItem(OrderItem data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
              width: 50,
              child: Text(
                data.quantity + ' x ' + data.productAmount,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              )),
          Container(
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                    data.amount.toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _PopupMenu() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 650,
          //width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15.0,
              ),
              // Container(
              //   width: 50,
              //   height: 50,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       border: Border.all(
              //         color: Colors.black.withOpacity(0.5),
              //       )),
              //   child: Center(
              //       child: Image.asset(
              //     'assets/images/billimg.png',
              //     width: 25,
              //   )),
              // ),
              const SizedBox(
                height: 10.0,
              ),
              const SelectableText(
                'Billing App',
                // commonController.billdetailsmodel.value!.data.store.storeName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              // Container(
              //   width: 200,
              //   child: SelectableText(
              //     commonController.billdetailsmodel.value!.data.store.storeName,
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 12),
              //   ),
              // ),
              const SizedBox(
                height: 10.0,
              ),
              // SelectableText(
              //   commonController.billdetailsmodel.value!.data.store.phone,
              //   style: TextStyle(fontSize: 12),
              // ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SelectableText(
                          'ரசிது',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SelectableText(
                          commonController.billdetailsmodel.value?.data.store
                                  .storeName ??
                              '',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SelectableText(
                        commonController
                                .billdetailsmodel.value?.data.order.orderNo
                                .toString() ??
                            '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      SelectableText(
                        commonController
                                .billdetailsmodel.value?.data.order.date ??
                            '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      // Text(
                      //   '10:40 AM',
                      //   style: TextStyle(fontSize: 12),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Row(
                children: [
                  Expanded(
                      child: Text(
                    'பொருளின் பெயர்',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  )),
                  SelectableText(
                    'அளவு',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  SelectableText(
                    'விலை',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SelectableText(
                          'தொகை',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Container(
                child: Obx(() {
                  final billdetails =
                      commonController.billdetailsmodel.value?.data.orderItem;
                  if (billdetails == null || billdetails.isEmpty) {
                    return const Text('பாதைகள் எதுவும் இல்லை.');
                  }
                  return ListView.builder(
                    itemCount: billdetails.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: ((context, index) {
                      return buildCardItem(billdetails[index]);
                    }),
                  );
                }),
              ),
              // billRowItem(),
              // billRowItem(),
              // billRowItem(),
              const Divider(),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'மொத்தம்',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    commonController.billdetailsmodel.value?.data.totalAmount
                            .toString() ??
                        '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'பெற்றது',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    commonController
                            .billdetailsmodel.value?.data.totalPaymentAmount
                            .toString() ??
                        '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'நிலுவையிலுள்ள இருப்பு',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    commonController.billdetailsmodel.value?.data.pendingAmount
                            .toString() ??
                        '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 20.0,
              ),
              // Text(commonController
              //         .billdetailsmodel.value!.data.store.storeName +
              //     ' வில்'),
              const Text(
                'வாங்கியதற்கு நன்றி',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Image.asset(
                'assets/images/barcode.png',
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget billRowItem(Datum data) {
  //   return Row(
  //     children: [
  //       SizedBox(
  //         width: 5.0,
  //       ),
  //       Text(
  //         '2',
  //       ),
  //       SizedBox(
  //         width: 23.0,
  //       ),
  //       Expanded(
  //           child: Row(
  //         children: [
  //           Text('Heritage Milk'),
  //         ],
  //       )),
  //       Text('25.00'),
  //       Expanded(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Text('50.00'),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _download() async {
    var status = await Permission.storage.request();
    // String url =
    //     'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

    String downloadUrl =
        commonController.billdetailsmodel.value?.data.downloadUrl ?? '';
    print(downloadUrl);
    if (!status.isGranted) {
      return;
    }
    Directory? directory;
    directory = Directory('/storage/emulated/0/Download');

    String filePath = '${directory.path}/abc.pdf';
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: directory.path,
      fileName: 'ரசிது1.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void route() {
    if (Get.previousRoute == '/allbills') {
      Get.toNamed('/allbills');
    } else if (Get.previousRoute == 'billhistory') {
      Get.toNamed('/billhistory');
    }
  }

  Widget _buildTotalRow(String label, String price, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: color),
          ),
          Text(
            price,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:billing_app/Models/all_billentry.dart';
import 'package:billing_app/Models/billdetails_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/common_controller.dart';

class BillDetails1 extends StatefulWidget {
  const BillDetails1({super.key});

  @override
  State<BillDetails1> createState() => _BillDetails1State();
}

class _BillDetails1State extends State<BillDetails1> {
  var commonController = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/allbills');
        return true;
      },
      child: Scaffold(
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
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
                                Navigator.popAndPushNamed(context, '/allbills');
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
                            'ரசீது விவரங்கள்',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // _PopupMenu();
                            // _download();
                            downloadPdf();
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
                          _PopupMenu();
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
                            .billdetailsmodel.value!.data.order.orderNo ??
                        '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    commonController.billdetailsmodel.value!.data.order.date ??
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
                  commonController.billdetailsmodel.value!.data.pathName,
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
                          .billdetailsmodel.value!.data.store.storeName ??
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
                          .billdetailsmodel.value!.data.store.storeAddress ??
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
          const Text('பில் விவரங்கள்'),
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
                const SelectableText(
                  'மொத்தம்',
                  style: TextStyle(fontSize: 15),
                ),
                SelectableText(
                  '₹ ' +
                      commonController.billdetailsmodel.value!.data.totalAmount
                          .toString(),
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'மொத்த கட்டணத் தொகை',
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        'நிலுவையில் உள்ள தொகை',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      '₹ ' +
                          commonController
                              .billdetailsmodel.value!.data.totalPaymentAmount
                              .toString(),
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    SelectableText(
                      '₹ ' +
                          commonController
                              .billdetailsmodel.value!.data.pendingAmount
                              .toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  Padding buildCardItem(OrderItem data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(data.name),
                SelectableText(data.quantity),
              ],
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SelectableText(data.amount.toString()),
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
              SelectableText(
                commonController.billdetailsmodel.value!.data.store.storeName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Container(
                width: 200,
                child: SelectableText(
                  commonController.billdetailsmodel.value!.data.store.storeName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              SelectableText(
                commonController.billdetailsmodel.value!.data.store.phone,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ரசிது',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        SelectableText(
                          commonController
                              .billdetailsmodel.value!.data.store.storeName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SelectableText(
                        commonController
                            .billdetailsmodel.value!.data.order.orderNo
                            .toString(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      SelectableText(
                        commonController
                            .billdetailsmodel.value!.data.order.date,
                        style: const TextStyle(fontSize: 12),
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
                  Text('அளவு'),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(child: Text('பொருளின் பெயர்')),
                  Text('விலை'),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('தொகை'),
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
                    style: TextStyle(fontSize: 17),
                  ),
                  SelectableText(
                    commonController.billdetailsmodel.value!.data.totalAmount
                        .toString(),
                    style: const TextStyle(fontSize: 17.0),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('பெற்றது'),
                  SelectableText(
                    commonController
                        .billdetailsmodel.value!.data.totalPaymentAmount
                        .toString(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('நிலுவையிலுள்ள இருப்பு'),
                  SelectableText(
                    commonController.billdetailsmodel.value!.data.pendingAmount
                        .toString(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 20.0,
              ),
              const SelectableText('வாங்கியதற்கு நன்றி'),
              SelectableText(commonController
                  .billdetailsmodel.value!.data.store.storeName),
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

  Widget billRowItem(Datum data) {
    return const Row(
      children: [
        SizedBox(
          width: 5.0,
        ),
        SelectableText(
          '2',
        ),
        SizedBox(
          width: 23.0,
        ),
        Expanded(
            child: Row(
          children: [
            SelectableText('Heritage Milk'),
          ],
        )),
        SelectableText('25.00'),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SelectableText('50.00'),
            ],
          ),
        ),
      ],
    );
  }

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
      fileName: 'bill1.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  Future<void> downloadPdf() async {
    try {
      String downloadUrl =
          commonController.billdetailsmodel.value?.data.downloadUrl ?? '';
      String fileName = 'Bill1';
      // Get the directory to save the file
      Directory directory = await getApplicationDocumentsDirectory();

      // Create the file path
      String filePath = '${directory.path}/$fileName.pdf';

      // Download the file
      Dio dio = Dio();
      var response = await dio.download(downloadUrl, filePath);

      if (response.statusCode == 200) {
        print('File downloaded successfully to $filePath');
      } else {
        print('Failed to download file');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
}

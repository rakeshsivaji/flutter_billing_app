import 'dart:io';

import 'package:billing_app/Models/individualbill_show_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Bill_Details3 extends StatefulWidget {
  const Bill_Details3({super.key});

  @override
  State<Bill_Details3> createState() => _Bill_Details3State();
}

class _Bill_Details3State extends State<Bill_Details3> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  var commonController = Get.put(CommonController());
  String fSdate = '';
  String fEdate = '';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String storeId = '';

  @override
  void initState() {
    super.initState();
    storeId = Get.arguments['id'].toString();
    print(storeId);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        fSdate = formatter.format(_startDate);
        fEdate = formatter.format(_endDate);
        filterbills();
      });
    }
  }

  filterbills() async {
    await commonController.getIndividualbillShow(
      storeId,
      withLoader: false,
      startDate: fSdate,
      endDate: fEdate,
    );
  }

  // Future<void> _fetchBillDetails() async {
  //   final response = await http.get(Uri.parse('YOUR_API_URL_HERE'));
  //   if (response.statusCode == 200) {
  //     final individualBillShowModel =
  //         individualBillShowModelFromJson(response.body);
  //     setState(() {
  //       commonController.individualShow.value = individualBillShowModel;
  //     });
  //   } else {
  //     throw Exception('Failed to load bill details');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          body: Column(
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
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ரசீது விவரங்கள்',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // _download();
                                    /*downloadPdf();
                                    _PopupMenu();*/
                                    Get.toNamed('/billDetailsReceiptAdmin',
                                        arguments: {
                                          'data': commonController
                                              .individualShow.value?.data
                                        });
                                  },
                                  child: Image.asset(
                                    height: 30,
                                    width: 30,
                                    'assets/images/print.png',
                                  ),
                                ),
                              ],
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              _selectDateRange(context);
                            },
                            child: Container(
                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.calendar_month),
                                  Text(
                                    '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
                                  ),
                                  Image.asset(
                                    'assets/images/arrowdown.png',
                                    width: 13,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (commonController.individualBill == true) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectableText(
                                  commonController.individualShow.value?.data
                                          .pathName ??
                                      '',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 10),
                                SelectableText(
                                  commonController.individualShow.value?.data
                                          .storeName ??
                                      '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 10.0),
                                SelectableText(commonController.individualShow
                                        .value?.data.storeAddress ??
                                    ''),
                                const SizedBox(height: 20.0),
                                Container(
                                  child: Obx(() {
                                    final listProducts = commonController
                                        .individualShow
                                        .value
                                        ?.data
                                        .listProducts;
                                    if (listProducts == null ||
                                        listProducts.isEmpty) {
                                      return const Center(
                                          child:
                                              Text('தனிப்பட்ட பில்கள் இல்லை'));
                                    }
                                    return ListView.builder(
                                      itemCount: listProducts.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return buildCard(listProducts[index]);
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ] else ...[
                            const Text('தனிப்பட்ட பில்கள் இல்லை'),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildCard(ListProduct listProduct) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 0.5),
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
                    'ID #${listProduct.orderNumber}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    listProduct.date ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListView.builder(
            itemCount: listProduct.product.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return productlist(listProduct.product[index]);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DottedLine(),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'மொத்தம்',
                ),
                SelectableText(
                  '₹${listProduct.totalAmount}',
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DottedLine(),
          ),
          // Divider(height: 0.5),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'நிலுவை தொகை',
                  style: TextStyle(color: Colors.red),
                ),
                SelectableText(
                  '₹${listProduct.pendingAmount}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          // Divider(height: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'பெறப்பட்ட தொகை',
                  style: TextStyle(color: Colors.green),
                ),
                SelectableText(
                  '₹${listProduct.totalAmountPaid.toString()}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),

          ///motham kattana thogai not in API
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'மொத்த கட்டணத் தொகை   ',
                style: TextStyle(color: Color.fromRGBO(40, 128, 10, 1)),
              ),
              Text(
                '₹ ${listProduct.total}',
                style: TextStyle(color: Color.fromRGBO(40, 128, 10, 1)),
              ),
            ],
          ),*/
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget productlist(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SelectableText(product.name),
            ),
            Text(product.quantity + ' x ' + product.price),
            Container(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                      '₹ ${(double.tryParse(product.price) ?? 0) * (double.tryParse(product.quantity) ?? 0)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _download() async {
    var status = await Permission.storage.request();
    // String url =
    //     'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
    String fileName = commonController.individualShow.value?.data.storeName ??
        '' + '-${_startDate.year}/${_startDate.month}/${_startDate.day}';
    String downloadUrl =
        commonController.individualShow.value?.data.pdfDownloadUrl ?? '';
    print(downloadUrl);
    if (!status.isGranted) {
      return;
    }

    Directory? directory;
    directory = Directory('/storage/emulated/0/Download');

    String filePath = '${directory.path}/$fileName.pdf';
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: directory.path,
      fileName: '$fileName.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void _PopupMenu() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 650,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                const SelectableText(
                  'Billing App',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 25.0,
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    )),
                    SelectableText(
                      'அளவு',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    SelectableText(
                      'விலை',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                    final billdetails = commonController
                        .individualShow.value?.data.listProducts;
                    if (billdetails == null || billdetails.isEmpty) {
                      return const Text('பாதைகள் எதுவும் இல்லை.');
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: billdetails.length,
                      shrinkWrap: true,
                      // padding: EdgeInsets.all(0),
                      itemBuilder: ((context, index) {
                        return buildCardItem(billdetails[index]);
                      }),
                    );
                  }),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardItem(ListProduct listProduct) {
    return ListView.builder(
      itemCount: listProduct.product.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return _buildProductList(listProduct.product[index]);
      },
    );
  }

  Padding _buildProductList(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SelectableText(product.name),
                ],
              ),
            ),
            Text(product.quantity + ' x ' + product.price),
            Container(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                      '₹ ${(int.tryParse(product.price) ?? 0) * (int.tryParse(product.quantity) ?? 0)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadPdf() async {
    try {
      String downloadUrl =
          commonController.billdetailsmodel.value?.data.downloadUrl ?? '';
      String fileName = commonController.individualShow.value?.data.storeName ??
          '' + '-${_startDate.year}/${_startDate.month}/${_startDate.day}';

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

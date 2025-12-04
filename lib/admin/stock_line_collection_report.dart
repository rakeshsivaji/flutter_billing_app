import 'dart:io';

import 'package:billing_app/Models/usercollectionreport_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StockLineCollectionReport extends StatefulWidget {
  const StockLineCollectionReport({super.key});

  @override
  State<StockLineCollectionReport> createState() =>
      _StockLineCollectionReportState();
}

class _StockLineCollectionReportState extends State<StockLineCollectionReport> {
  var commonController = Get.put(CommonController());
  dynamic _sumOfTotalAmount;

  @override
  void initState() {
    super.initState();
    _sumOfTotalAmount = commonController.userCollectionReportModel.value?.data
            .map((e) => e.totalAmount)
            .reduce((value, element) => value + element) ??
        0;
    debugPrint(
        'the stock line list is ******** ${commonController.userCollectionReportModel.value}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
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
                                Get.back();
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
                            'வழி அறிக்கை',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _downloadPdf('வழி அறிக்கை');
                            },
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                            ))
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
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSumOfTotalAmount(),
                      if (commonController
                                  .userCollectionReportModel.value?.data ==
                              null ||
                          commonController.userCollectionReportModel.value!.data
                              .isEmpty) ...[
                        const SizedBox(
                          height: 50,
                        ),
                        const Text('ஆர்டர்கள் பட்டியல் இல்லை'),
                      ] else ...[
                        ListView.builder(
                          itemCount: commonController.userCollectionReportModel
                                  .value?.data.length ??
                              0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return buildCard(commonController
                                .userCollectionReportModel.value!.data[index]);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Datum data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15),
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
                  SelectableText(
                    data.storeName,
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  SelectableText(
                    data.date.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                itemCount: data.amountsByTime.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return buildItems(data.amountsByTime[index]);
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Divider(),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'மொத்த தொகை',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '₹ ' + data.totalAmount.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildItems(AmountsByTime data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 7, child: Text(data.time)),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('₹ ' + data.amount.toString(),
                    style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSumOfTotalAmount() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 18, left: 18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(120, 89, 217, 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            _buildTotalAmount(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'மொத்த வசூல் தொகை',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        Text('₹ $_sumOfTotalAmount',
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white))
      ],
    );
  }

  Future<void> _downloadPdf(String name) async {
    // bool hasPermission = await checkPermissions();
    // if (!hasPermission) return;

    try {
      final response = await http.get(Uri.parse(
          commonController.userCollectionReportModel.value!.downloadUrl ?? ''));
      if (response.statusCode == 200) {
        final dir = await Directory('/storage/emulated/0/Download');
        final filePath = '${dir.path}/certificate.pdf';
        int counter = 1;
        String newFilePath = filePath;
        while (await File(newFilePath).exists()) {
          newFilePath = '${dir.path}/$name ($counter).xlsx';
          counter++;
        }
        final file = File(newFilePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded: $newFilePath');
        Fluttertoast.showToast(
          msg:
              'வழி அறிக்கை பதிவிறக்கம் செய்யப்பட்டது \n /storage/emulated/0/Download',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
}

import 'dart:io';

import 'package:billing_app/Models/linestockreport_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Stock_Line_Report_Show extends StatefulWidget {
  const Stock_Line_Report_Show({super.key});

  @override
  State<Stock_Line_Report_Show> createState() => _Stock_Line_Report_ShowState();
}

class _Stock_Line_Report_ShowState extends State<Stock_Line_Report_Show> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  var commonController = Get.put(CommonController());
  String routename = '';
  String selectedValue = '';
  bool isselect = false;
  // bool isexpand = false;
  List<bool> expand = [];

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
    expand = List.generate(
        commonController.linestockreportmodel.value?.data.length ?? 0,
        (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    child: Column(children: [
                      const SizedBox(
                        height: 15,
                      ),
                      if (commonController.linereport == true) ...[
                        Container(
                          child: Obx(
                            () {
                              final stockreport = commonController
                                  .linestockreportmodel.value!.data;

                              if (stockreport.isEmpty) {
                                return const Text('அறிக்கை  இல்லை');
                              }
                              if (expand.length != stockreport.length) {
                                expand = List.generate(
                                    stockreport.length, (_) => false);
                              }
                              return ListView.builder(
                                itemCount: stockreport.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemBuilder: ((context, index) {
                                  return commonbuild(index, stockreport[index]);
                                }),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        const Text('அறிக்கை இல்லை'),
                      ],
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container commonbuild(int index, Datum data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                  Text(
                    // data.amount,
                    data.name, style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    data.date,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
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
          !expand[index]
              ? Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'மொத்த ஸ்டாக்குகளின் எண்ணிக்கை',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'மீதமுள்ள ஸ்டாக்குகளின் எண்ணிக்கை',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          data.totalStock.toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          data.pendingStock.toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                )
              : expand[index]
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'ஸ்டாக்கள்',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'மொத்த ஸ்டாக்களின் எண்ணிக்கை',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'மீதமுள்ள ஸ்டாக்களின் எண்ணிக்கை',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            itemCount: data.products.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return stockbuild(data.products[index]);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  data.totalStock.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  data.pendingStock.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 5,
                    ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'சேகரிக்கப்பட்ட தொகை',
                style: TextStyle(fontSize: 13),
              ),
              Text(
                '₹ ' + data.collectedAmount.toString(),
                style: const TextStyle(fontSize: 13),
              ),

              ///motham thogai and metham ulla thogai
              /*Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'மொத்த தொகை',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'மீதமுள்ள தொகை',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ ' + data.totalAmount.toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '₹ ' + data.pendingAmount.toString(),
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),*/
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  setState(() {
                    expand[index] = !expand[index];
                  });
                },
                child: !expand[index]
                    ? const Text(
                        'விபரங்களை பார்க்க',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color.fromRGBO(120, 89, 207, 1)),
                      )
                    : const Text(
                        'குறைவாக காட்டு',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color.fromRGBO(120, 89, 207, 1)),
                      )),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Row stockbuild(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              textAlign: TextAlign.start,
              product.name,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.center,
            product.totalQuantity.toString(),
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.center,
            product.pendingQuantity.toString(),
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCard() {
    return InkWell(
      onTap: () async {},
      child: Container(
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
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(120, 89, 217, 1),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectableText(
                          'Employee Name',
                          style: TextStyle(color: Colors.white),
                        ),
                        SelectableText(
                          '06-03-2024 09:35 AM',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
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
                const Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SelectableText(
                                'மொத்த ஸ்டாக்குகளின்\n      எண்ணிக்கை',
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SelectableText(
                                '92',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SelectableText(
                                'மீதமுள்ள ஸ்டாக்குகளின்\n        எண்ணிக்கை',
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SelectableText(
                                '92',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText(
                              'மொத்த தொகை',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            SelectableText(
                              '₹ 95',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText(
                              'மீதமுள்ள தொகை',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            SelectableText(
                              '₹ 120',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: () async {},
                  child: const Text(
                    'விபரங்களை பார்க்க',
                    style: TextStyle(
                        fontSize: 11, color: Color.fromRGBO(120, 89, 207, 1)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPdf(String name) async {
    // bool hasPermission = await checkPermissions();
    // if (!hasPermission) return;

    try {
      final response = await http.get(Uri.parse(
          commonController.linestockreportmodel.value?.downloadUrl ?? ''));
      if (response.statusCode == 200) {
        final dir = await Directory('/storage/emulated/0/Download');
        final filePath = '${dir.path}/certificate.pdf';
        int counter = 1;
        String newFilePath = filePath;
        while (await File(newFilePath).exists()) {
          newFilePath = '${dir.path}/$name ($counter).pdf';
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

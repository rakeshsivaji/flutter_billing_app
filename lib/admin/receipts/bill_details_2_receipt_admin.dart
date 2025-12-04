import 'package:billing_app/Models/billdetails_model.dart';
import 'package:billing_app/admin/receipts/printer_bottom_nav_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get/get.dart';

class BillDetails2ReceiptAdmin extends StatefulWidget {
  const BillDetails2ReceiptAdmin({super.key});

  @override
  State<BillDetails2ReceiptAdmin> createState() =>
      _BillDetails2ReceiptAdminState();
}

class _BillDetails2ReceiptAdminState extends State<BillDetails2ReceiptAdmin> {
  ReceiptController? controller;
  String? address;
  Data? data;
  final double printerContentWidth = 400;
  final double defaultFontSize = 24;

  @override
  void initState() {
    super.initState();
    data = Get.arguments?['data'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        title: const Text('Receipt Page'),
        actions: [
          IconButton(
            onPressed: () async {
              final selected =
                  await FlutterBluetoothPrinter.selectDevice(context);
              if (selected != null) {
                setState(() {
                  address = selected.address;
                });
              }
            },
            icon: const Icon(Icons.bluetooth),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Receipt(
            backgroundColor: Colors.white,
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  width: printerContentWidth,
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          'கொள்முதல் ரசீது',
                          style: TextStyle(
                            fontSize: defaultFontSize + 6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Text(
                          '${data?.store.storeName ?? ' '}',
                          style: TextStyle(
                            fontSize: defaultFontSize + 2,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ஆர்டர் எண்:',
                            style: TextStyle(
                              fontSize: defaultFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${data?.order.orderNo ?? ''}',
                            style: TextStyle(
                              fontSize: defaultFontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'தேதி:',
                            style: TextStyle(
                              fontSize: defaultFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${data?.order.date ?? ''}',
                            style: TextStyle(
                              fontSize: defaultFontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'பொருள்',
                              style: TextStyle(
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'அளவு',
                              style: TextStyle(
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Expanded(
                            flex: 3,
                            child: Text(
                              'தொகை',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(data?.orderItem.length ?? 0, (index) {
                        final item = data!.orderItem[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'x ${item.quantity.toString()}',
                                  style: TextStyle(fontSize: defaultFontSize),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${item.amount?.toString() ?? ''}',
                                  style: TextStyle(fontSize: defaultFontSize),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      const DottedLine(
                        dashColor: Colors.black,
                        lineThickness: 1.5,
                        dashLength: 6,
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'மொத்த தொகை:',
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                  ),
                                ),
                              ),
                              Text(
                                '${data?.totalAmount.toString() ?? ''}',
                                style: TextStyle(
                                  fontSize: defaultFontSize,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'நிலுவை தொகை:',
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                  ),
                                ),
                              ),
                              Text(
                                '${data?.pendingAmount.toString() ?? ''}',
                                style: TextStyle(
                                  fontSize: defaultFontSize,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'மொத்த கட்டணத்.தொ:',
                                  style: TextStyle(
                                    fontSize: defaultFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '₹ ${data?.totalPaymentAmount.toString() ?? ''}',
                                style: TextStyle(
                                  fontSize: defaultFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'நீங்கள் வாங்கியதற்கு நன்றி',
                          style: TextStyle(
                            fontSize: defaultFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
            onInitialized: (controller) {
              setState(() {
                this.controller = controller;
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: PrinterBottomNavBar(
        address: address,
        controller: controller,
      ),
    );
  }
}

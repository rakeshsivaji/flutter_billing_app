import 'package:billing_app/Models/individual_bills_model.dart';
import 'package:billing_app/admin/receipts/printer_bottom_nav_bar.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get/get.dart';

class IndividualBillsReceipt extends StatefulWidget {
  const IndividualBillsReceipt({super.key});

  @override
  State<IndividualBillsReceipt> createState() => _IndividualBillsReceiptState();
}

class _IndividualBillsReceiptState extends State<IndividualBillsReceipt> {
  ReceiptController? controller;
  String? address;
  List<Datum>? data;
  double defaultFontSize = 20;
  final _commonController = CommonController();

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
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InteractiveViewer(
              // boundaryMargin: const EdgeInsets.all(20),
              minScale: 1,
              maxScale: 4.0,
              child: Receipt(
                backgroundColor: Colors.grey.shade200,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 36,
                        ),
                        child: const FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'கொள்முதல் ரசீது',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      for (Datum receiptData in data ?? []) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        _buildText(text: receiptData.date),
                        const SizedBox(
                          height: 6,
                        ),
                        _buildText(text: receiptData.pathName),
                        const SizedBox(
                          height: 6,
                        ),
                        _buildText(text: receiptData.storeName),
                        const SizedBox(
                          height: 6,
                        ),
                        _buildHeaderOfTheTable(),
                        const SizedBox(
                          height: 4,
                        ),
                        _buildProductDetails(receiptData.orders?.orderItems),
                        _buildDottedLine(),
                        _buildRowText(
                            label: 'மொத்த தொகை',
                            price: receiptData.orders?.totalAmount.toString() ??
                                ''),
                        const SizedBox(
                          height: 4,
                        ),
                        _buildRowText(
                            label: 'நிலுவை தொகை',
                            price:
                                receiptData.orders?.pendingAmount.toString() ??
                                    ''),
                        const SizedBox(
                          height: 4,
                        ),
                        _buildRowText(
                            label: 'மொத்த கட்டணத்.தொ',
                            price: receiptData.orders?.totalPaymentAmount
                                    .toString() ??
                                ''),
                        _buildDottedLine(),
                      ],
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'நீங்கள் வாங்கியதற்கு நன்றி!!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
                onInitialized: (controller) {
                  setState(() {
                    this.controller = controller;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          PrinterBottomNavBar(controller: controller, address: address),
    );
  }

  Widget _buildDottedLine() {
    return const Column(
      children: [
        SizedBox(
          height: 12,
        ),
        DottedLine(
          dashColor: Colors.black,
          lineThickness: 3,
          dashLength: 10,
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildRowText({String? label, FontWeight? fontWeight, String? price}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label ?? '',
              style: TextStyle(
                  fontSize: 20, fontWeight: fontWeight ?? FontWeight.normal),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price ?? '',
              style: TextStyle(
                  fontSize: 20, fontWeight: fontWeight ?? FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText({String? text, FontWeight? fontWeight}) {
    return Text(
      text ?? 'sampleText',
      style: TextStyle(
        fontSize: defaultFontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  TableRow _buildRowSizedBox() {
    return const TableRow(
      children: [
        SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Table _buildHeaderOfTheTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(0.5),
        2: FlexColumnWidth(0.5),
      },
      children: [
        TableRow(
          children: [
            Text(
              'பொருள்',
              style: TextStyle(fontSize: defaultFontSize),
            ),
            Text(
              'அளவு',
              style: TextStyle(fontSize: defaultFontSize),
              textAlign: TextAlign.center,
            ),
            Text(
              'விலை',
              style: TextStyle(fontSize: defaultFontSize),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        _buildRowSizedBox(),
      ],
    );
  }

  Table _buildProductDetails(List<OrderItem>? orderItems) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(0.5),
        2: FlexColumnWidth(0.5),
      },
      children: [
        for (OrderItem product in orderItems ?? []) ...[
          TableRow(
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                  height: 1.5,
                  fontSize: defaultFontSize,
                ),
              ),
              Text(
                'x ${product.quantity.toString() ?? ''}',
                style: TextStyle(fontSize: defaultFontSize),
                textAlign: TextAlign.center,
              ),
              Text(
                product.amount.toString() ?? '',
                style: TextStyle(fontSize: defaultFontSize),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          _buildRowSizedBox()
        ]
      ],
    );
  }
}

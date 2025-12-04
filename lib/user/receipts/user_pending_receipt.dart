import 'package:billing_app/Models/shop_pending_model.dart';
import 'package:billing_app/admin/receipts/printer_bottom_nav_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';

class UserPendingReceipt extends StatefulWidget {
  final List<ShopPendingDataModel>? data;

  const UserPendingReceipt({super.key, this.data});

  @override
  State<UserPendingReceipt> createState() => _UserPendingReceiptState();
}

class _UserPendingReceiptState extends State<UserPendingReceipt> {
  ReceiptController? controller;
  String? address;

  // ShopPendingDataModel? data;
  double defaultFontSize = 20;
  double totalAmount = 0;
  double pendingAmount = 0;
  double paidAmount = 0;

  // double defaultFontS

  @override
  void initState() {
    super.initState();
    // data = Get.arguments['data'];
    // totalAmount = Get.arguments['totalAmount'];
    // pendingAmount = Get.arguments['pendingAmount'];
    // paidAmount = Get.arguments['paidAmount'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Page'),
        actions: [
          IconButton(
            onPressed: () {
              // Temporarily disabled for testing
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bluetooth printing not available')),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       final selected =
        //           await FlutterBluetoothPrinter.selectDevice(context);
        //       if (selected != null) {
        //         setState(() {
        //           address = selected.address;
        //         });
        //       }
        //     },
        //     icon: const Icon(Icons.settings),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InteractiveViewer(
              // boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Receipt(
                backgroundColor: Colors.grey.shade200,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 36,
                        ),
                        child: const FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'நிலுவையிலுள்ள ரசீது',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(0.5),
                        },
                        children: [
                          _buildSizedBox(count: 2, height: 12),
                          TableRow(
                            children: [
                              Text(
                                'பொருள்',
                                style: TextStyle(fontSize: defaultFontSize),
                              ),
                              Text(
                                'அளவு',
                                style: TextStyle(
                                  fontSize: defaultFontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          _buildSizedBox(count: 2, height: 12),
                          for (ShopPendingDataModel i in widget.data ?? []) ...[
                            _buildShopName(i),
                            _buildSizedBox(count: 2, height: 12),
                            for (PendingQuantity item in i.pendingQuantity) ...[
                              _buildOrderTime(item),
                              _buildSizedBox(count: 2, height: 12),
                            ]
                          ]
                        ],
                      ),
                      // _buildTotalPendingAmountRow(),
                      const SizedBox(
                        height: 24,
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
      bottomNavigationBar: PrinterBottomNavBar(
        address: address,
        controller: controller,
      ),
    );
  }

  Widget _buildDottedLine({bool? isTopSizedBox}) {
    return Column(
      children: [
        isTopSizedBox == true
            ? const SizedBox(
                height: 12,
              )
            : const SizedBox(),
        const DottedLine(
          dashColor: Colors.black,
          lineThickness: 3,
          dashLength: 10,
        ),
        const SizedBox(
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

  /*Widget _buildTotalPendingAmountRow() {
    return Column(
      children: [
        _buildDottedLine(),
        _buildRowText(
            label: 'மொத்தம்', price: '₹${data?.totalAmount.toString() ?? ''}'),
        const SizedBox(
          height: 12,
        ),
        _buildRowText(
            label: 'நிலுவை தொகை',
            price: '₹${data?.pendingAmount.toString() ?? ''}'),
        _buildDottedLine(isTopSizedBox: true),
        const SizedBox(
          height: 12,
        ),
        _buildRowText(label: 'மொத்தம்', price: '₹$totalAmount'),
        const SizedBox(
          height: 12,
        ),
        _buildRowText(
            label: 'பெறப்பட்ட தொகை',
            price: '₹$paidAmount',
            fontWeight: FontWeight.w700),
        const SizedBox(
          height: 12,
        ),
        _buildRowText(label: 'மொத்த நி.தொ', price: '₹$pendingAmount'),
      ],
    );
  }*/

  TableRow _buildSizedBox({int count = 3, double? height}) {
    return TableRow(
      children: List.generate(
        count,
        (index) => SizedBox(
          height: height,
        ),
      ),
    );
  }

  TableRow _buildOrderTime(PendingQuantity item) {
    return TableRow(
      children: [
        Text(
          item.name,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          'x ${item.quantity}',
          style: TextStyle(fontSize: defaultFontSize),
          textAlign: TextAlign.center,
        ),
        // Item price
      ],
    );
  }

  TableRow _buildShopName(ShopPendingDataModel i) {
    return TableRow(
      children: [
        Text(
          i.storeName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        Text(
          '',
          style: TextStyle(fontSize: defaultFontSize),
          textAlign: TextAlign.center,
        ),
        // Item price
      ],
    );
  }
}

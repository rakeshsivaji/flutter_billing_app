import 'package:billing_app/Models/individualbill_show_model.dart';
import 'package:billing_app/admin/receipts/printer_bottom_nav_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get/get.dart';

class BillDetailsReceiptAdmin extends StatefulWidget {
  const BillDetailsReceiptAdmin({super.key});

  @override
  State<BillDetailsReceiptAdmin> createState() =>
      _BillDetailsReceiptAdminState();
}

class _BillDetailsReceiptAdminState extends State<BillDetailsReceiptAdmin> {
  ReceiptController? controller;
  String? address;
  Data? data;
  double defaultFontSize = 20;

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
                      Text(
                        'கடை பெயர்: ${data?.storeName ?? ' '}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Table(
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
                      ),
                      for (int i = 0;
                          i < (data?.listProducts.length ?? 0);
                          i++) ...[
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data?.listProducts[i].date.toString() ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(0.5),
                            2: FlexColumnWidth(0.5),
                          },
                          children: [
                            for (Product product
                                in data?.listProducts[i].product ?? []) ...[
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
                                    '${(double.tryParse(product.price) ?? 0) * (double.tryParse(product.quantity) ?? 0)}',
                                    style: TextStyle(fontSize: defaultFontSize),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              _buildRowSizedBox(),
                            ]
                          ],
                        ),
                        if (i !=
                            (data?.listProducts.length ?? 1) -
                                1) // Check if it's not the last item
                          const DottedLine(
                            dashColor: Colors.black,
                            lineThickness: 2,
                            dashLength: 2,
                          ),
                      ],
                      _buildDottedLine(),
                      _buildRowText(
                          label: 'மொத்த தொகை',
                          price: '₹${data?.totalAmount.toString()}',
                          fontWeight: FontWeight.w700),
                      const SizedBox(
                        height: 12,
                      ),
                      _buildRowText(
                          label: 'மொத்த பெ.தொ',
                          price: '₹${data?.totalPaidAmount.toString()}'),
                      const SizedBox(
                        height: 12,
                      ),
                      _buildRowText(
                          label: 'நிலுவை தொகை',
                          price: '₹${data?.pendingAmount.toString()}'),
                      _buildDottedLine(),
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
        controller: controller,
        address: address,
      ),
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

  TableRow _buildTotalRow({String? title, String? price}) {
    return TableRow(
      children: [
        Text(
          title ?? '',
          style: TextStyle(
            fontSize: defaultFontSize,
          ),
        ),
        Text(
          '',
          style: TextStyle(fontSize: defaultFontSize),
          textAlign: TextAlign.center,
        ),
        Text(
          price ?? '',
          style: TextStyle(fontSize: defaultFontSize),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

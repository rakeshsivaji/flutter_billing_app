import 'dart:io';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:billing_app/Models/get_user_bill_details_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class BillDetails extends StatefulWidget {
  const BillDetails({super.key});

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  var commonController = Get.put(CommonController());
  bool connected = false;
  void showToast(String message) {
    // You can use any toast method you prefer
    print('Toast: $message');
    // Or use Fluttertoast if you have it imported
    // Fluttertoast.showToast(msg: message);
  }

  Future<void> refreshvalue() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    print('Value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Obx(() {
          return Column(
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
                                  Navigator.popAndPushNamed(
                                      context, '/enteredbills',
                                      arguments: {'isNotification': false});
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
                              Get.toNamed('/billDetailsReceipt', arguments: {
                                'data': commonController
                                    .getUserBillDetailsModel.value?.data
                              });

                              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BillDetailsReceipt(
                                        data: commonController
                                            .getUserBillDetailsModel
                                            .value
                                            ?.data),
                                  ));*/
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
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
          );
        }));
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
                    'Order ID: ${commonController.getUserBillDetailsModel.value?.data?.orderId.toString() ?? ""}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  /*SelectableText(
                    commonController.billdetailsmodel.value!.data.order.date ??
                        "",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),*/
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
                  commonController.getUserBillDetailsModel.value?.data?.pathName
                          .toString() ??
                      '',
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
                          .getUserBillDetailsModel.value?.data?.store?.storeName
                          .toString() ??
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
                  commonController.getUserBillDetailsModel.value?.data?.store
                          ?.storeAddress
                          .toString() ??
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
          const SelectableText('ரசிது விவரங்கள்'),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            child: Obx(() {
              final billdetails = commonController
                  .getUserBillDetailsModel.value?.data?.orderItems;
              if (billdetails == null || billdetails.isEmpty) {
                return const Text('பொருள்கள் எதுவும் இல்லை.');
              }
              return ListView.builder(
                itemCount: billdetails.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'மொத்தம்',
                  style: TextStyle(fontSize: 15),
                ),
                SelectableText(
                  '₹ ' +
                      (commonController
                              .getUserBillDetailsModel.value?.data!.totalAmount
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'மொத்த கட்டணத் தொகை',
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    SelectableText(
                      'நிலுவையிலுள்ள தொகை',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      '₹ ' +
                          (commonController.getUserBillDetailsModel.value?.data
                                  ?.totalPaymentAmount
                                  .toString() ??
                              ''),
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    SelectableText(
                      '₹ ' +
                          (commonController.getUserBillDetailsModel.value?.data
                                  ?.pendingAmount
                                  .toString() ??
                              ''),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data.dateTime ?? '',
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.items?.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItemsCard(data.items?[index]);
              },
            ),
          )
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
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: SingleChildScrollView(
            child: Column(
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
                        .getUserBillDetailsModel.value?.data?.orderItems;
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
                const Divider(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'மொத்தம்',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      commonController
                              .getUserBillDetailsModel.value?.data?.totalAmount
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      commonController.getUserBillDetailsModel.value?.data
                              ?.totalPaymentAmount
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
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      commonController.getUserBillDetailsModel.value?.data
                              ?.pendingAmount
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
      ),
    );
  }

  void _download() async {
    var status = await Permission.storage.request();
    String url =
        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

    String downloadUrl =
        commonController.billdetailsmodel.value?.data.downloadUrl ?? '';
    printBill();
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
      fileName: 'Bill1.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  Future<void> printBill() async {
    // Assuming you have a method to choose between Wi-Fi and Bluetooth printers
    // Example: bool useWiFi = true;
    // bool useWiFi = true;
    await _printViaBluetooth();
    /*if (useWiFi) {
      await _printViaWiFi();
    } else {*/
    // }
  }

  Future<void> _enableBluetooth() async {
    const platform = MethodChannel('samples.flutter.dev/bluetooth');

    try {
      final bool result = await platform.invokeMethod('enableBluetooth');
      if (result) {
        print('Bluetooth is enabled.');
      } else {
        print('Bluetooth is not enabled.');
      }
    } on PlatformException catch (e) {
      print("Failed to enable Bluetooth: '${e.message}'.");
    }
  }

  Future<bool> _checkAndRequestBluetoothPermission() async {
    print('=== CHECKING BLUETOOTH PERMISSIONS ===');

    try {
      // 1. Location Permission (Required for Bluetooth scanning)
      var locationStatus = await Permission.location.status;
      print('Location status: $locationStatus');

      if (!locationStatus.isGranted) {
        print('Requesting location permission...');
        locationStatus = await Permission.location.request();
        print('Location permission result: $locationStatus');

        if (!locationStatus.isGranted) {
          print('Location permission denied');
          return false;
        }
      }

      // 2. Bluetooth Permissions (Android 12+)
      var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      var bluetoothScanStatus = await Permission.bluetoothScan.status;

      print('BluetoothConnect status: $bluetoothConnectStatus');
      print('BluetoothScan status: $bluetoothScanStatus');

      // Request Bluetooth permissions if needed
      if (!bluetoothConnectStatus.isGranted) {
        bluetoothConnectStatus = await Permission.bluetoothConnect.request();
        print('BluetoothConnect result: $bluetoothConnectStatus');
      }

      if (!bluetoothScanStatus.isGranted) {
        bluetoothScanStatus = await Permission.bluetoothScan.request();
        print('BluetoothScan result: $bluetoothScanStatus');
      }

      // Final check
      bool permissionsGranted = locationStatus.isGranted &&
          bluetoothConnectStatus.isGranted &&
          bluetoothScanStatus.isGranted;

      print('=== FINAL PERMISSION RESULT: $permissionsGranted ===');

      if (!permissionsGranted) {
        print('Some permissions denied. Opening app settings...');
        await openAppSettings();
      }

      return permissionsGranted;
    } catch (e) {
      print('Permission check error: $e');
      return false;
    }
  }

  // Future<void> _printViaBluetooth() async {
  //   await _checkAndRequestBluetoothPermission();
  //
  //   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  //   bool isOn = (await bluetooth.isOn) ?? false;
  //
  //   if (!isOn) {
  //     print('Please turn on Bluetooth');
  //     await _enableBluetooth();
  //     isOn = (await bluetooth.isOn) ?? false;
  //
  //     if (!isOn) {
  //       print('Bluetooth is still off. Exiting.');
  //       return;
  //     }
  //   }
  //
  //   List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
  //   if (devices.isEmpty) {
  //     print('No Bluetooth devices found.');
  //     return;
  //   }
  //
  //   BluetoothDevice device = devices.first; // Select the device
  //
  //   await bluetooth.connect(device);
  //   bool isConnected = (await bluetooth.isConnected) ?? false;
  //
  //   if (isConnected) {
  //     _printReceiptBluetooth(bluetooth);
  //     bluetooth.disconnect();
  //   } else {
  //     print('Could not connect to printer.');
  //   }
  // }

  /*void _printReceipt(NetworkPrinter printer) async {
    final billDetails = commonController.billdetailsmodel.value?.data;
    if (billDetails == null) {
      print('No bill details available.');
      return;
    }

    printer.text('Billing App',
        styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2));
    printer.text('ரசிது', styles: PosStyles(align: PosAlign.left));
    printer.text(billDetails.store.storeName,
        styles: PosStyles(align: PosAlign.left));
    printer.text('Order No: ${billDetails.order.orderNo}',
        styles: PosStyles(align: PosAlign.right));
    printer.text('Date: ${billDetails.order.date}',
        styles: PosStyles(align: PosAlign.right));

    printer.hr();

    printer.row([
      PosColumn(
        text: 'பொருளின் பெயர்',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'அளவு',
        width: 2,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'விலை',
        width: 2,
        styles: PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'தொகை',
        width: 2,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);

    printer.hr();

    for (var item in billDetails.orderItem) {
      printer.row([
        PosColumn(
          text: item.name,
          width: 6,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: item.quantity.toString(),
          width: 2,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: item.productAmount.toString(),
          width: 2,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: item.amount.toString(),
          width: 2,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    printer.hr();

    printer.row([
      PosColumn(
        text: 'மொத்தம்',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: billDetails.totalAmount.toString(),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    printer.row([
      PosColumn(
        text: 'பெற்றது',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: billDetails.totalPaymentAmount.toString(),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    printer.row([
      PosColumn(
        text: 'நிலுவையிலுள்ள இருப்பு',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: billDetails.pendingAmount.toString(),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    printer.hr();

    printer.text('வாங்கியதற்கு நன்றி',
        styles: PosStyles(align: PosAlign.center));
    printer.feed(2);
    printer.cut();
  }*/

  Future<void> _printViaBluetooth() async {
    print('🟡 _printViaBluetooth() CALLED'); // Add this
    print('=== STARTING BLUETOOTH PRINT ===');

    // Check permissions first
    bool hasPermissions = await _checkAndRequestBluetoothPermission();

    if (!hasPermissions) {
      print('Bluetooth permissions not granted');
      showToast('Bluetooth permissions required');
      return;
    }

    try {
      // Get paired devices
      List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;
      print('Found ${devices.length} Bluetooth devices');

      if (devices.isEmpty) {
        print('No Bluetooth devices found.');
        showToast('No Bluetooth devices found');
        return;
      }

      // Show devices for debugging
      for (var device in devices) {
        print('Device: ${device.name} - ${device.macAdress}');
      }

      // Select first device
      BluetoothInfo device = devices.first;
      print('Attempting to connect to: ${device.name}');

      // Connect to device
      bool connected = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress);

      if (connected) {
        print('Connected successfully! Printing receipt...');
        showToast('Connected to ${device.name}');

        // Print receipt
        await _printReceiptBluetooth();

        print('Printed successfully!');
        showToast('Receipt printed successfully!');
      } else {
        print('Connection failed');
        showToast('Failed to connect to printer');
      }
    } catch (e) {
      print('Bluetooth error: $e');
      showToast('Bluetooth error: ${e.toString()}');
    }
  }

  Future<void> _printReceiptBluetooth() async {
    final billDetails = commonController.billdetailsmodel.value?.data;
    if (billDetails == null) {
      print('No bill details available.');
      return;
    }

    // ✅ SAME PRINTING LOGIC, just different method names:

    // printCustom('Billing App', 2, 1)
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 2, text: 'Billing App\n'));

    // printCustom('ரசிது', 1, 0)
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 1, text: 'ரசிது\n'));

    // printCustom(storeName, 1, 0)
    await PrintBluetoothThermal.writeString(
        printText:
            PrintTextSize(size: 1, text: '${billDetails.store.storeName}\n'));

    // printCustom('Order No...', 1, 2)
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
            size: 1, text: 'Order No: ${billDetails.order.orderNo}\n'));

    // printCustom('Date...', 1, 2)
    await PrintBluetoothThermal.writeString(
        printText:
            PrintTextSize(size: 1, text: 'Date: ${billDetails.order.date}\n'));

    // printNewLine() + printCustom('---', 1, 1)
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
            size: 1, text: '\n--------------------------------\n'));

    // printLeftRight('பொருளின் பெயர்', 'அளவு', 1)
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 1, text: 'பொருளின் பெயர்    அளவு\n'));

    // printLeftRight('விலை', 'தொகை', 1)
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 1, text: 'விலை      தொகை\n'));

    // Continue with the rest of your printing logic...
    // ... items loop, totals, etc.

    // paperCut() is automatic in thermal printers
  }
  // void _printReceiptBluetooth(BlueThermalPrinter printer) async {
  //   final billDetails = commonController.billdetailsmodel.value?.data;
  //   if (billDetails == null) {
  //     print('No bill details available.');
  //     return;
  //   }
  //
  //   printer.printCustom('Billing App', 2, 1);
  //   printer.printCustom('ரசிது', 1, 0);
  //   printer.printCustom(billDetails.store.storeName, 1, 0);
  //   printer.printCustom('Order No: ${billDetails.order.orderNo}', 1, 2);
  //   printer.printCustom('Date: ${billDetails.order.date}', 1, 2);
  //
  //   printer.printNewLine();
  //   printer.printCustom('--------------------------------', 1, 1);
  //
  //   printer.printLeftRight('பொருளின் பெயர்', 'அளவு', 1);
  //   printer.printLeftRight('விலை', 'தொகை', 1);
  //
  //   printer.printCustom('--------------------------------', 1, 1);
  //
  //   for (var item in billDetails.orderItem) {
  //     printer.printLeftRight(item.name, item.quantity.toString(), 1);
  //     printer.printLeftRight(
  //         item.productAmount.toString(), item.amount.toString(), 1);
  //   }
  //
  //   printer.printCustom('--------------------------------', 1, 1);
  //
  //   printer.printLeftRight('மொத்தம்', billDetails.totalAmount.toString(), 1);
  //   printer.printLeftRight(
  //       'பெற்றது', billDetails.totalPaymentAmount.toString(), 1);
  //   printer.printLeftRight(
  //       'நிலுவையிலுள்ள இருப்பு', billDetails.pendingAmount.toString(), 1);
  //
  //   printer.printCustom('--------------------------------', 1, 1);
  //
  //   printer.printCustom('வாங்கியதற்கு நன்றி', 1, 1);
  //   printer.printNewLine();
  //   printer.paperCut();
  // }

  Widget _buildItemsCard(Item? data) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data?.name ?? '',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Container(
                width: 50,
                child: Text(
                  (data?.quantity.toString() ?? '') +
                      ' x ' +
                      (data?.productAmount ?? ''),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                )),
            Container(
                width: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SelectableText(
                      data?.amount.toString() ?? '',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ))
          ],
        ));
  }
}

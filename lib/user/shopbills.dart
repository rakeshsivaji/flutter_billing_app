import 'package:billing_app/Models/orderdetails_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/printer_dialog.dart';

// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class Shopbills extends StatefulWidget {
  const Shopbills({super.key});

  @override
  State<Shopbills> createState() => _ShopbillsState();
}

class _ShopbillsState extends State<Shopbills> {
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController amount = TextEditingController();
  String route = '';
  String lineid = '';
  bool useWiFi = true;
  String printerIp = '';
  int printerPort = 9100;
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _selectedDevice;

  List<String> _wifiPrinters = [];
  String? _selectedWifiPrinter;
  bool clicked = false;

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

  Future<bool> _checkBluetoothPermissions() async {
    if (Platform.isAndroid) {
      // Request location permission (required for Bluetooth scanning)
      var locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        locationStatus = await Permission.location.request();
        if (!locationStatus.isGranted) {
          showToast('Location permission required for Bluetooth');
          return false;
        }
      }

      // For Android 12+, request Bluetooth permissions
      var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      var bluetoothScanStatus = await Permission.bluetoothScan.status;

      if (!bluetoothConnectStatus.isGranted) {
        bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      }

      if (!bluetoothScanStatus.isGranted) {
        bluetoothScanStatus = await Permission.bluetoothScan.request();
      }

      return bluetoothConnectStatus.isGranted && bluetoothScanStatus.isGranted;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _getBluetoothDevices();
    _discoverWifiPrinters();
    lineid = (Get.arguments?['id']) ?? '';
  }

  // void checkdata() {
  //   setState(() {
  //     if (Get.previousRoute == '/orderlist') {
  //       print('Orderpage');
  //       route = '/orderscreen';
  //     } else if (Get.previousRoute == '/stocklist2') {
  //       print('stocklist');
  //       route = '/stocklist2';
  //     } else if (Get.previousRoute == '/adminorderlist') {
  //       print('adminOrderpage');
  //       route = '/adminorderscreen';
  //     } else if (Get.previousRoute == '/confirmorderlist') {
  //       route = '/neworderscreen';
  //     } else {
  //       print('Bill Entered');
  //       route = '/billentries';
  //     }
  //   });
  // }

  Future<bool> pop() async {
    Navigator.pop(context);
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return pop();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            // CustomAppBar(text: 'கடை ரசிதுகள்', path: route),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(120, 89, 207, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20.0,
                  0.0,
                  20.0,
                  20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: InkWell(
                              onTap: () {
                                // changeroute();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              )),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        const Expanded(
                          child: Text(
                            'கடை ரசிதுகள்',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        useWiFi
                            ? const Text(
                                'WiFi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              )
                            : const Text(
                                'Bt',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Switch(
                          value: useWiFi,
                          activeColor: Colors.deepPurple,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white,
                          onChanged: (bool value) {
                            setState(() {
                              useWiFi = value;
                            });
                          },
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          SelectableText(
                            commonController.orderDetailsModel.value?.data
                                    ?.store?.storeName
                                    .toString() ??
                                '',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SelectableText(
                              commonController.orderDetailsModel.value?.data
                                      ?.store?.storeAddress ??
                                  '',
                              style: const TextStyle(fontSize: 13)),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(120, 89, 207, 0.05),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  buildCard(context),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  _buildTotalAmountRow(
                                      'இன்றைய கட்டணத் தொகை',
                                      (double.tryParse(commonController
                                                      .orderDetailsModel
                                                      .value
                                                      ?.data
                                                      ?.totalAmount
                                                      .toString() ??
                                                  '') ??
                                              0.0)
                                          .toString(),
                                      color: Colors.green),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  _buildTotalAmountRow(
                                      'நிலுவையில் உள்ள தொகை',
                                      commonController.orderDetailsModel.value
                                              ?.data?.pendingAmount
                                              .toString() ??
                                          '',
                                      color: Colors.red),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  _buildTotalAmountRow(
                                      'மொத்த கட்டணத் தொகை',
                                      commonController.orderDetailsModel.value
                                              ?.data?.overallTotalAmount
                                              .toString() ??
                                          '',
                                      color: Colors.green),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 15.0),
                                          child: SelectableText(
                                            ' ₹  |',
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        Expanded(
                                          child: Form(
                                            key: _formKey1,
                                            child: TextFormField(
                                              controller: amount,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'கட்டணம் செலுத்தும் தொகை',
                                                hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                fillColor: const Color.fromRGBO(
                                                    71, 52, 125, 1),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  /*if (useWiFi) ...[
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 250, 250, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                          )),
                                      child: DropdownButton<String>(
                                        hint: Text('Select Wi-Fi Printer'),
                                        value: _selectedWifiPrinter,
                                        isExpanded: true,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedWifiPrinter = value;
                                          });
                                        },
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        icon: Image.asset(
                                          'assets/images/arrowdown.png',
                                          width: 15,
                                        ),
                                        items: _wifiPrinters.map((printer) {
                                          return DropdownMenuItem<String>(
                                            value: printer,
                                            child: Text(printer),
                                          );
                                        }).toList(),
                                        underline: Container(),
                                      ),
                                    ),
                                  ] else ...[
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 250, 250, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
                                          )),
                                      child: DropdownButton<BluetoothDevice>(
                                        hint: Text('Select Bluetooth Device'),
                                        value: _selectedDevice,
                                        isExpanded: true,
                                        onChanged: (BluetoothDevice? value) {
                                          setState(() {
                                            _selectedDevice = value;
                                          });
                                        },
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        icon: Image.asset(
                                          'assets/images/arrowdown.png',
                                          width: 15,
                                        ),
                                        items: _devices.map((device) {
                                          return DropdownMenuItem<
                                              BluetoothDevice>(
                                            value: device,
                                            child: Text(device.name ?? ''),
                                          );
                                        }).toList(),
                                        underline: Container(),
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    height: 20.0,
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0.0, 20.0, 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///print the receipt before enter the bill.
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/shopBillReceipt',
                                                  arguments: {
                                                    'data': commonController
                                                        .orderDetailsModel
                                                        .value!
                                                        .data,
                                                    'totalAmount': double.tryParse(
                                                            commonController
                                                                    .orderDetailsModel
                                                                    .value
                                                                    ?.data
                                                                    ?.overallTotalAmount
                                                                    .toString() ??
                                                                '') ??
                                                        0.0, // Ensure it's never null
                                                    'paidAmount': double
                                                            .tryParse(
                                                                amount.text) ??
                                                        0.0, // Ensure it's never null
                                                    'pendingAmount': ((double.tryParse(commonController
                                                                        .orderDetailsModel
                                                                        .value
                                                                        ?.data
                                                                        ?.overallTotalAmount
                                                                        .toString() ??
                                                                    '') ??
                                                                0.0) -
                                                            (double.tryParse(
                                                                    amount
                                                                        .text) ??
                                                                0.0))
                                                        .clamp(
                                                            0, double.infinity)
                                                  });
                                            },
                                            child: Container(
                                              height: 60,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Color.fromRGBO(
                                                    120, 89, 207, 1),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/print.png',
                                                    width: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                    'அச்சு',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (clicked == false) {
                                                _amtCheck()
                                                    ? showToast(
                                                        'மொத்த கட்டணத் தொகையைச் சரிபார்க்கவும்')
                                                    : submit();
                                              }
                                            },
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color.fromRGBO(
                                                    120, 89, 207, 1),
                                              ),
                                              child: Center(
                                                child: clicked
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    : const Text(
                                                        'ரசிது உறுதி',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                              ),
                                            ),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
                    'ID #${commonController.orderDetailsModel.value?.data?.order?.orderNo.toString() ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  SelectableText(
                    commonController
                            .orderDetailsModel.value?.data?.order?.date ??
                        '',
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
          Container(
            child: Obx(
              () {
                final items =
                    commonController.orderDetailsModel.value?.data?.totalOrders;
                if (items?.isEmpty == true) {
                  return const Text('ஆர்டர் பட்டியல் இல்லை');
                }
                // return Text('Here');
                // else {
                return ListView.builder(
                  itemCount: items?.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemBuilder: ((context, index) {
                    return buildCardItem(items?[index]);
                  }),
                );
              },
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          const Divider(height: 0.5),
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
                      (commonController
                              .orderDetailsModel.value?.data?.totalAmount
                              .toString() ??
                          ''),
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardItem(TotalOrder? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            data?.orderTime.toString() ?? '',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data?.orderItem?.length,
            itemBuilder: (context, index) {
              return _buildCardItemList(data?.orderItem?[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardItemList(OrderItem? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(data?.name ?? ''),
                SelectableText(
                    '${data?.quantity ?? 0} x ${data?.productAmount ?? ''}'),
              ],
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SelectableText('₹ ' + (data?.amount.toString() ?? '')),
            ],
          ))
        ],
      ),
    );
  }

  void submit() async {
    if (amount.text.isEmpty) {
      showToast('தயவுசெய்து தொகையை உள்ளிடவும்');
    } else {
      if (_formKey1.currentState!.validate()) {
        setState(() {
          clicked = true;
        });
        try {
          dynamic response = await CommonService().orderPayment(
              commonController.orderDetailsModel.value?.data?.orderId
                      .toString() ??
                  '',
              amount.text);
          if (response['status'] == 1) {
            showToast('கட்டணம் வெற்றிகரமாக உருவாக்கப்பட்டது');
            await commonController.getPathBillEntries('1');
            await commonController.getNotification();
            pop();
            _openPrintDialog();
          } else {
            showToast(response['data'] ?? 'பிழை ஏற்பட்டது');
            setState(() {
              clicked = false;
            });
          }
        } catch (error) {
          print('Error: $error');
          showToast('பிழை ஏற்பட்டது');
        }
      }
    }
  }

  void changeroute() async {
    if (Get.previousRoute == '/orderlist') {
      print('Orderpage');
      await commonController.getOrderDelivery(withLoader: true);
      Get.toNamed('/orderscreen');
    } else if (Get.previousRoute == '/stocklist2') {
      print('stocklist');
      await commonController.getOrderDelivery(withLoader: true);
      await commonController.getShops(withLoader: true);
      Get.toNamed('/stocklist2');
    } else if (Get.previousRoute == '/adminorderlist') {
      // print('adminOrderpage');
      await commonController.getOrderDelivery(withLoader: true);
      Get.toNamed('/adminorderscreen');
    } else if (Get.previousRoute == '/confirmorderlist') {
      print('Orderpage 1');
      await commonController.getuserlinereport(lineid);
      Get.toNamed('/neworderscreen', arguments: {'id': lineid});
    } else if (Get.previousRoute == '/announce') {
      await commonController.getNotification();
      Get.toNamed('/announce', arguments: {'id': lineid});
    } else if (Get.previousRoute == '/shopBillReceipt') {
      print('/neworderscreen ');
      Get.toNamed('/neworderscreen', arguments: {'id': lineid});
    } else if (Get.previousRoute == '/billDetailsReceipt') {
      print('Bill Entered ****** ');
      Get.toNamed('/billentries');
    } else {
      Get.toNamed('/home');
    }
  }

  Future<void> _getBluetoothDevices() async {
    try {
      // Optional: Check permissions first for better UX
      await _checkBluetoothPermissions();

      // YOUR ORIGINAL CODE - This is correct
      List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      setState(() {
        _devices = devices;
      });

      if (devices.isEmpty) {
        showToast('No Bluetooth printers found');
      }
    } catch (e) {
      print('Error discovering devices: $e');
      showToast('Error discovering Bluetooth devices');
    }
  }

  Future<void> _discoverWifiPrinters() async {
    final MDnsClient client = MDnsClient();
    await client.start();

    // Listen for services matching the type '_printer._tcp'
    await for (PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_printer._tcp'))) {
      await for (SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName))) {
        setState(() {
          _wifiPrinters.add(srv.target);
        });
      }
    }

    client.stop();
  }

  Future<void> printBill() async {
    _printViaBluetooth();
    /*if (useWiFi) {
      await */ /*_printViaWiFi()*/ /*;
    } else {
      await _printViaBluetooth();
    }*/
  }

  // Future<void> printBill() async {
  //   // Assuming you have a method to choose between Wi-Fi and Bluetooth printers
  //   // Example: bool useWiFi = true;
  //   bool useWiFi = false;

  //   if (useWiFi) {
  //     await _printViaWiFi();
  //   } else {
  //     await _printViaBluetooth();
  //   }
  // }

  /*Future<void> _printViaWiFi() async {
    if (_selectedWifiPrinter == null) {
      print('No Wi-Fi printer selected.');
      showToast('No Wi-Fi printer selected.');
      return;
    }

    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm58, profile);

    final res = await printer.connect(_selectedWifiPrinter!, port: printerPort);
    if (res == PosPrintResult.success) {
      _printReceipt(printer);
      printer.disconnect();
    } else {
      print('Could not connect to printer.');
      showToast('Could not connect to printer.');
    }
  }*/

  // Future<void> _printViaBluetooth() async {
  //   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  //   bool isOn = (await bluetooth.isOn) ?? false;
  //   if (!(await isOn)) {
  //     print('Please turn on Bluetooth');
  //     showToast('Please turn on Bluetooth');
  //     return;
  //   }

  //   List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
  //   if (devices.isEmpty) {
  //     print('No Bluetooth devices found.');
  //     showToast('No Bluetooth devices found. ');
  //     return;
  //   }

  //   BluetoothDevice device =
  //       devices.first;

  //   await bluetooth.connect(device);
  //   bool isConnected = (await bluetooth.isConnected) ?? false;
  //   if (await isConnected) {
  //     _printReceiptBluetooth(bluetooth);
  //     bluetooth.disconnect();
  //   } else {
  //     print('Could not connect to printer.');
  //     showToast('Could not connect to printer.');
  //   }
  // }

  Future<void> _printViaBluetooth() async {
    try {
      if (_devices.isEmpty) {
        showToast('No Bluetooth printers available');
        return;
      }

      // SAME WORKFLOW: Select first device (like your old code)
      BluetoothInfo device = _devices.first;

      showToast('Connecting to ${device.name}...');

      // SAME WORKFLOW: Connect to device
      bool connected = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress);

      if (connected) {
        showToast('Connected! Printing receipt...');

        //  SAME WORKFLOW: Print receipt
        await _printReceiptBluetooth();

        showToast('Receipt printed successfully!');
      } else {
        showToast('Failed to connect to printer');
      }
    } catch (e) {
      print('Print error: $e');
      showToast('Print failed: $e');
    }
  }

  //  NEW: Print receipt method (equivalent to your old _printReceiptBluetooth)
  Future<void> _printReceiptBluetooth() async {
    final orderData = commonController.orderDetailsModel.value?.data;
    if (orderData == null) return;

    try {
      // Header
      await PrintBluetoothThermal.writeString(
          printText:
              PrintTextSize(size: 2, text: 'Billing App\n') // Billing App
          );
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 1, text: 'ரசீது\n') // Receipt
          );
      await PrintBluetoothThermal.writeString(
          printText:
              PrintTextSize(size: 1, text: '${orderData.store?.storeName}\n'));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'ஆர்டர்: ${orderData.order?.orderNo}\n') // Order
          );
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'தேதி: ${orderData.order?.date}\n') // Date
          );

      // Separator
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: '--------------------------------\n'));

      // Column headers
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1,
              text: 'பொருளின் பெயர்          அளவு\n') // Item Name, Quantity
          );
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'விலை          தொகை\n') // Price, Amount
          );

      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: '--------------------------------\n'));

      // Items
      for (var totalOrder in orderData.totalOrders ?? []) {
        for (var item in totalOrder.orderItem ?? []) {
          // Item name
          await PrintBluetoothThermal.writeString(
              printText: PrintTextSize(size: 1, text: '${item.name}\n'));
          // Quantity x Price = Amount
          await PrintBluetoothThermal.writeString(
              printText: PrintTextSize(
                  size: 1,
                  text:
                      '${item.quantity} x ${item.productAmount} = ${item.amount}\n'));
        }
      }

      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: '--------------------------------\n'));

      // Totals
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'மொத்தம்: ${orderData.totalAmount}\n') // Total
          );
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'செலுத்தியது: ${amount.text}\n') // Paid
          );

      double totalAmount =
          double.tryParse(orderData.overallTotalAmount?.toString() ?? '') ?? 0;
      double paidAmount = double.tryParse(amount.text) ?? 0;
      double balance = totalAmount - paidAmount;

      await PrintBluetoothThermal.writeString(
          printText:
              PrintTextSize(size: 1, text: 'மீதம்: $balance\n') // Balance
          );

      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: '--------------------------------\n'));

      // Footer
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1,
              text: 'வாங்கியதற்கு நன்றி!\n\n\n') // Thank you for purchase!
          );
    } catch (e) {
      print('Print error: $e');
      showToast('அச்சு பிழை: $e'); // Print error in Tamil
    }
  }

  /*void _printReceipt(NetworkPrinter printer) async {
    final billDetails = commonController.orderDetailsModel.value?.data;
    if (billDetails == null) {
      print('No bill details available.');
      showToast('No Bill details available');
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
          text: item.amount.toString(),
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

  /*void _printReceiptBluetooth(BlueThermalPrinter printer) async {
    final billDetails = commonController.orderDetailsModel.value?.data;
    if (billDetails == null) {
      print('No bill details available.');
      showToast('No bill details available');
      return;
    }

    printer.printCustom('Billing App', 2, 1);
    printer.printCustom('ரசிது', 1, 0);
    printer.printCustom(billDetails.store.storeName, 1, 0);
    printer.printCustom('Order No: ${billDetails.order.orderNo}', 1, 2);
    printer.printCustom('Date: ${billDetails.order.date}', 1, 2);

    printer.printNewLine();
    printer.printCustom('--------------------------------', 1, 1);

    printer.printLeftRight('பொருளின் பெயர்', 'அளவு', 1);
    printer.printLeftRight('விலை', 'தொகை', 1);

    printer.printCustom('--------------------------------', 1, 1);

    for (var item in billDetails.orderItem) {
      printer.printLeftRight(item.name, item.quantity.toString(), 1);
      printer.printLeftRight(item.amount.toString(), item.amount.toString(), 1);
    }

    printer.printCustom('--------------------------------', 1, 1);

    printer.printLeftRight('மொத்தம்', billDetails.totalAmount.toString(), 1);
    printer.printLeftRight(
        'பெற்றது', billDetails.totalPaymentAmount.toString(), 1);
    printer.printLeftRight(
        'நிலுவையிலுள்ள இருப்பு', billDetails.pendingAmount.toString(), 1);

    printer.printCustom('--------------------------------', 1, 1);

    printer.printCustom('வாங்கியதற்கு நன்றி', 1, 1);
    printer.printNewLine();
    printer.paperCut();
  }*/

  bool _amtCheck() {
    double totalAmount = double.tryParse(commonController
                .orderDetailsModel.value?.data?.overallTotalAmount
                .toString() ??
            '') ??
        0;
    double controllerAmt = double.tryParse(amount.text) ?? 0;
    debugPrint('the condition is $totalAmount');
    debugPrint('the condition is $controllerAmt');
    debugPrint('the condition is ${controllerAmt > totalAmount}');
    return controllerAmt > totalAmount;
  }

  Widget _buildTotalAmountRow(String label, String price, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: color),
        ),
        Text(
          '₹ ' + price,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Future _openPrintDialog() {
    return showDialog(
      context: context,
      builder: (context) => PrinterDialog(
        data: commonController.orderDetailsModel.value!.data,
        paidAmount: double.tryParse(amount.text),
        pendingAmount: (double.tryParse(commonController
                        .orderDetailsModel.value?.data?.overallTotalAmount
                        .toString() ??
                    '') ??
                0) -
            (double.tryParse(amount.text) ?? 0),
        totalAmount: double.tryParse(commonController
                .orderDetailsModel.value?.data?.overallTotalAmount
                .toString() ??
            ''),
      ),
    );
  }
}

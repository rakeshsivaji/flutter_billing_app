import 'package:billing_app/Models/orderdetails_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/printer_dialog.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class AdminShowBillDetails extends StatefulWidget {
  const AdminShowBillDetails({super.key});

  @override
  State<AdminShowBillDetails> createState() => _AdminShowBillDetailsState();
}

class _AdminShowBillDetailsState extends State<AdminShowBillDetails> {
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController amount = TextEditingController();
  String route = '';
  String lineid = '';
  String orderId = '';
  bool useWiFi = true;
  String printerIp = '';
  int printerPort = 9100;
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  // FlutterBluePlus bluetooth = FlutterBluePlus.instance;
  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _selectedDevice;
  List<String> _wifiPrinters = [];
  String? _selectedWifiPrinter;
  bool clicked = false;
  bool isLoading = false;

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
    super.initState();
    _getBluetoothDevices();
    _discoverWifiPrinters();
    lineid = (Get.arguments?['id']) ?? '';
    orderId = (Get.arguments?['orderId']) ?? '';
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    await commonController.getOrderDetails(orderId.toString());
    setState(() {
      isLoading = false;
    });
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // changeroute();
                                pop();
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
                            'கடை ரசீதுகள்',
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
            isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: commonController.orderDetailsModel.value?.data ==
                              null
                          ? const Center(
                              child: Text('ரசீது இல்லை'),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      SelectableText(
                                        commonController.orderDetailsModel.value
                                                ?.data?.store?.storeName
                                                .toString() ??
                                            '',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      SelectableText(
                                          commonController
                                                  .orderDetailsModel
                                                  .value
                                                  ?.data
                                                  ?.store
                                                  ?.storeAddress ??
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
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30)),
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
                                                  commonController
                                                          .orderDetailsModel
                                                          .value
                                                          ?.data
                                                          ?.pendingAmount
                                                          .toString() ??
                                                      '',
                                                  color: Colors.red),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              _buildTotalAmountRow(
                                                  'மொத்த கட்டணத் தொகை',
                                                  commonController
                                                          .orderDetailsModel
                                                          .value
                                                          ?.data
                                                          ?.overallTotalAmount
                                                          .toString() ??
                                                      '',
                                                  color: Colors.green),
                                              const SizedBox(
                                                height: 15.0,
                                              ),
                                              Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                      padding: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: SelectableText(
                                                        ' ₹  |',
                                                        style: TextStyle(
                                                            fontSize: 22),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Form(
                                                        key: _formKey1,
                                                        child: TextFormField(
                                                          controller: amount,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'கட்டணம் செலுத்தும் தொகை',
                                                            hintStyle:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            fillColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    71,
                                                                    52,
                                                                    125,
                                                                    1),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 0.0, 20.0, 20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ///print the receipt before enter the bill.
                                                    /*Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/shopBillReceipt',
                                                  arguments: {
                                                    'data': commonController
                                                        .orderDetailsModel
                                                        .value!
                                                        .data
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
                                        ),*/
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (clicked ==
                                                              false) {
                                                            _amtCheck()
                                                                ? showToast(
                                                                    'மொத்த கட்டணத் தொகையைச் சரிபார்க்கவும்')
                                                                : submit();
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: const Color
                                                                .fromRGBO(120,
                                                                89, 207, 1),
                                                          ),
                                                          child: Center(
                                                            child: clicked
                                                                ? const CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : const Text(
                                                                    'ரசீது உறுதி',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w500),
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

  Future<void> _getBluetoothDevices() async {
    try {
      // ✅ SAME: Get paired devices (equivalent to getBondedDevices)
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
  }

  Future<void> _printViaBluetooth() async {
    print('🟡 _printViaBluetooth() CALLED');
    if (_selectedDevice == null) {
      print('No Bluetooth device selected.');
      showToast('Please select a Bluetooth printer first');
      return;
    }

    try {
      showToast('Connecting to ${_selectedDevice!.name}...');

      bool connected = await PrintBluetoothThermal.connect(
          macPrinterAddress: _selectedDevice!.macAdress);

      if (connected) {
        showToast('Connected! Printing receipt...');

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

  Future<void> _printReceiptBluetooth() async {
    final orderData = commonController.orderDetailsModel.value?.data;
    if (orderData == null) return;

    try {
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 2, text: 'Billing App\n') // Billing App in Tamil
          );
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 1, text: 'ரசிது\n'));
      await PrintBluetoothThermal.writeString(
          printText:
              PrintTextSize(size: 1, text: '${orderData.store?.storeName}\n'));
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1,
              text: 'ஆர்டர்: ${orderData.order?.orderNo}\n')); // Order in Tamil
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1,
              text: 'தேதி: ${orderData.order?.date}\n')); // Date in Tamil

      // Separator
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: '--------------------------------\n'));

      // Items
      for (var totalOrder in orderData.totalOrders ?? []) {
        for (var item in totalOrder.orderItem ?? []) {
          await PrintBluetoothThermal.writeString(
              printText: PrintTextSize(size: 1, text: '${item.name}\n'));
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
              size: 1,
              text: 'மொத்தம்: ${orderData.totalAmount}\n')); // Total in Tamil
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'செலுத்தியது: ${amount.text}\n')); // Paid in Tamil
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1,
              text:
                  'மீதம்: ${(double.tryParse(orderData.overallTotalAmount?.toString() ?? '') ?? 0) - (double.tryParse(amount.text) ?? 0)}\n')); // Balance in Tamil

      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: '--------------------------------\n'));

      // Footer
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(
              size: 1, text: 'நன்றி!\n\n\n')); // Thank you in Tamil
      // Paper cut is automatic in thermal printers
    } catch (e) {
      print('Print error: $e');
      showToast('அச்சிடும் பிழை: $e'); // Print error in Tamil
    }
  }

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

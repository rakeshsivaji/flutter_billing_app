import 'package:billing_app/Models/orderdetails_model.dart';
import 'package:billing_app/admin/receipts/printer_bottom_nav_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

class ShopBillsReceipt extends StatefulWidget {
  final Data? data;

  const ShopBillsReceipt({super.key, this.data});

  @override
  State<ShopBillsReceipt> createState() => _ShopBillsReceiptState();
}

class _ShopBillsReceiptState extends State<ShopBillsReceipt> {
  ReceiptController? controller;
  String? address;
  Data? data;
  double fontSize = 24;
  double headerFontSize = 28;
  double totalAmount = 0;
  double pendingAmount = 0;
  double paidAmount = 0;

  // Variables for print_bluetooth_thermal
  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _selectedDevice;
  bool _connected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    data = Get.arguments['data'];
    totalAmount = Get.arguments['totalAmount'];
    pendingAmount = Get.arguments['pendingAmount'];
    paidAmount = Get.arguments['paidAmount'];
    _initializeBluetooth();
  }

  Future<void> _requestBluetoothPermissions() async {
    try {
      var locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        locationStatus = await Permission.location.request();
      }

      var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      if (!bluetoothConnectStatus.isGranted) {
        bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      }

      var bluetoothScanStatus = await Permission.bluetoothScan.status;
      if (!bluetoothScanStatus.isGranted) {
        bluetoothScanStatus = await Permission.bluetoothScan.request();
      }
    } catch (e) {
      print('Permission error: $e');
    }
  }

  Future<void> _initializeBluetooth() async {
    try {
      await _getBluetoothDevices();
    } catch (e) {
      print('Bluetooth init error: $e');
    }
  }

  Future<void> _getBluetoothDevices() async {
    try {
      bool hasPermissions = await _checkBluetoothPermissions();
      if (!hasPermissions) {
        Get.snackbar(
            'Permission Required', 'Please grant Bluetooth permissions');
        return;
      }

      List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      setState(() {
        _devices = devices;
      });

      if (devices.isEmpty) {
        Get.snackbar('Info', 'No Bluetooth printers found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to discover Bluetooth devices: $e');
    }
  }

  Future<bool> _checkBluetoothPermissions() async {
    try {
      var locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        locationStatus = await Permission.location.request();
        if (!locationStatus.isGranted) {
          return false;
        }
      }

      var bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      var bluetoothScanStatus = await Permission.bluetoothScan.status;

      if (!bluetoothConnectStatus.isGranted) {
        bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      }

      if (!bluetoothScanStatus.isGranted) {
        bluetoothScanStatus = await Permission.bluetoothScan.request();
      }

      return locationStatus.isGranted &&
          bluetoothConnectStatus.isGranted &&
          bluetoothScanStatus.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<void> _connectToDevice(BluetoothInfo device) async {
    try {
      setState(() {
        _isLoading = true;
      });

      Get.snackbar('Connecting', 'Connecting to ${device.name}...');

      bool connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress,
      );

      setState(() {
        _connected = connected;
        _selectedDevice = device;
        address =
            device.macAdress; // Maintain compatibility with existing workflow
        _isLoading = false;
      });

      if (connected) {
        Get.snackbar('Success', 'Connected to ${device.name}');
      } else {
        Get.snackbar('Error', 'Failed to connect to ${device.name}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('Error', 'Connection failed: $e');
    }
  }

  // Modified settings icon handler
  Future<void> _showDeviceSelectionDialog() async {
    await _getBluetoothDevices(); // Refresh devices list

    if (_devices.isEmpty) {
      Get.snackbar('No Devices', 'No Bluetooth printers found');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Available Devices(${_devices.length})'),
        content: Container(
          width: double.maxFinite,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return ListTile(
                      leading: Icon(
                        Icons.print,
                        color: _selectedDevice?.macAdress == device.macAdress
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: Text(device.name ?? 'Unknown Device'),
                      subtitle: Text(device.macAdress),
                      trailing: _selectedDevice?.macAdress == device.macAdress
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _connectToDevice(device);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Page'),
        actions: [
          IconButton(
            onPressed: _showDeviceSelectionDialog, // Updated handler
            icon: Icon(
              Icons.settings,
              color: _connected
                  ? Colors.green
                  : null, // Visual connection indicator
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Receipt(
          backgroundColor: Colors.white,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'கொள்முதல் ரசீது',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '${data?.store?.storeName ?? ''}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'தேதி: ${data?.order?.date ?? ''}',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          'பொருள்',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'அளவு',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'விலை',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...buildOrderItems(),
                  const SizedBox(height: 16),
                  const DottedLine(
                    dashColor: Colors.black,
                    lineThickness: 2,
                    dashLength: 8,
                    dashGapLength: 4,
                  ),
                  const SizedBox(height: 16),
                  buildAmountRow(
                      'மொத்தம்', '₹${data?.totalAmount.toString() ?? '0'}'),
                  const SizedBox(height: 8),
                  buildAmountRow('நிலுவை தொகை',
                      '₹${data?.pendingAmount.toString() ?? '0'}'),
                  const SizedBox(height: 16),
                  const DottedLine(
                    dashColor: Colors.black,
                    lineThickness: 2,
                    dashLength: 8,
                    dashGapLength: 4,
                  ),
                  const SizedBox(height: 16),
                  buildAmountRow('மொத்தம்', '₹$totalAmount', bold: true),
                  const SizedBox(height: 8),
                  buildAmountRow('பெறப்பட்ட தொகை', '₹$paidAmount', bold: true),
                  const SizedBox(height: 8),
                  buildAmountRow('மொத்த நி.தொ', '₹$pendingAmount', bold: true),
                  const SizedBox(height: 32),
                  Text(
                    'நீங்கள் வாங்கியதற்கு நன்றி*',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
          onInitialized: (receiptController) {
            setState(() {
              controller = receiptController;
            });
          },
        ),
      ),
      bottomNavigationBar: PrinterBottomNavBar(
        address: address,
        controller: controller,
      ),
    );
  }

  List<Widget> buildOrderItems() {
    List<Widget> orderWidgets = [];

    for (TotalOrder order in data?.totalOrders ?? []) {
      final formattedTime = DateFormat('hh:mm a').format(
          DateFormat('dd-MM-yyyy hh:mm a').parse(order.orderTime ?? ''));

      orderWidgets.add(Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          formattedTime,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));

      for (OrderItem item in order.orderItem ?? []) {
        orderWidgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  item.name ?? '',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'x ${item.quantity.toString()}',
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '₹${item.amount.toString()}',
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ));
      }

      orderWidgets.add(const SizedBox(height: 8));
    }

    return orderWidgets;
  }

  Widget buildAmountRow(String label, String amount, {bool bold = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

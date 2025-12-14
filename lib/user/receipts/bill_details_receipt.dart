import 'package:billing_app/Models/get_user_bill_details_model.dart';
import 'package:billing_app/admin/receipts/printer_bottom_nav_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

class BillDetailsReceipt extends StatefulWidget {
  final Data? data;

  const BillDetailsReceipt({super.key, this.data});

  @override
  State<BillDetailsReceipt> createState() => _BillDetailsReceiptState();
}

class _BillDetailsReceiptState extends State<BillDetailsReceipt> {
  ReceiptController? controller;
  String? address;
  Data? data;
  double defaultFontSize = 24;

  // Variables for print_bluetooth_thermal
  List<BluetoothInfo> _devices = [];
  BluetoothInfo? _selectedDevice;
  bool _connected = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    data = Get.arguments['data'] ?? '';
    _initializeBluetooth();
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
        address = device.macAdress; // Maintain compatibility
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
        child: Column(
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Receipt(
                backgroundColor: Colors.white,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildReceiptHeader(),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1, color: Colors.black),
                      const SizedBox(height: 5),
                      _buildItemsSection(),
                      _buildDottedLine(),
                      _buildTotalPendingAmountRow(),
                      const SizedBox(height: 16),
                      const Text(
                        'நீங்கள் வாங்கியதற்கு நன்றி!!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
                onInitialized: (receiptController) {
                  setState(() {
                    controller = receiptController;
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

  Widget _buildReceiptHeader() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const Text(
            'கொள்முதல் ரசீது',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'கடை பெயர்: ${data?.store?.storeName ?? ''}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            'தேதி: ${data?.order?.date ?? ''}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
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
              Expanded(
                flex: 3,
                child: Text(
                  'விலை',
                  style: TextStyle(
                    fontSize: defaultFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const Divider(thickness: 1),
          for (OrderItem item in data?.orderItems ?? []) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('hh:mm a').format(
                        DateFormat('dd-MM-yyyy hh:mm a')
                            .parse(item.dateTime ?? '')),
                    style: TextStyle(
                      fontSize: defaultFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (Item product in item.items ?? []) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        product.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'x ${product.quantity?.toString() ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${product.amount?.toString() ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: defaultFontSize,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 5),
            const Divider(thickness: 0.5),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalPendingAmountRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          _buildSummaryRow(
            label: 'மொத்த தொகை',
            price: '₹${data?.totalAmount?.toString() ?? ''}',
          ),
          _buildSummaryRow(
            label: 'மொத்த கட்டணத்.தொகை',
            price: '₹${data?.totalPaymentAmount?.toString() ?? ''}',
          ),
          _buildSummaryRow(
            label: 'நிலுவை தொகை',
            price: '₹${data?.pendingAmount?.toString() ?? ''}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      {required String label, required String price, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              label,
              style: TextStyle(
                fontSize: defaultFontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              price,
              style: TextStyle(
                fontSize: defaultFontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return const Column(
      children: [
        SizedBox(height: 8),
        DottedLine(
          dashColor: Colors.black,
          lineThickness: 1.5,
          dashLength: 5,
          dashGapLength: 3,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

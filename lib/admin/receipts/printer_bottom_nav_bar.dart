import 'package:billing_app/widgets/receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

class PrinterBottomNavBar extends StatefulWidget {
  final ReceiptController? controller;
  final String? address;
  PrinterBottomNavBar({super.key, this.address, this.controller});

  @override
  State<PrinterBottomNavBar> createState() => _PrinterBottomNavBarState();
}

class _PrinterBottomNavBarState extends State<PrinterBottomNavBar> {
  bool _isLoading = false;

  Future<void> _showDeviceSelectionDialog(BuildContext context) async {
    try {
      List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;

      if (devices.isEmpty) {
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Available Devices(${devices.length})'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.macAdress),
                  onTap: () {
                    Navigator.pop(context);
                    _printWithSelectedDevice(device.macAdress);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Device selection error: $e');
    }
  }

  Future<void> _printWithSelectedDevice(String macAddress) async {
    if (widget.controller == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use the original printing method but with the selected device address
      PrintingProgressDialog.print(
        context,
        device: macAddress,
        controller: widget.controller!,
      );
    } catch (e) {
      print('Print error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  _isLoading ? Colors.grey : Colors.blue,
                ),
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      if (widget.address != null) {
                        // Print with pre-selected address from settings
                        _printWithSelectedDevice(widget.address!);
                      } else {
                        // Show device selection using print_bluetooth_thermal
                        _showDeviceSelectionDialog(context);
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print,
                          color: Colors.white,
                        ),
                        SizedBox(width: 18),
                        Text(
                          'PRINT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

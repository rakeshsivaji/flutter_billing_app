// import 'package:flutter/material.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

// class PrintBillScreen extends StatefulWidget {
//   @override
//   _PrintBillScreenState createState() => _PrintBillScreenState();
// }

// class _PrintBillScreenState extends State<PrintBillScreen> {
//   bool useWiFi = true; // This can be toggled by the user
//   String printerIp = '';
//   int printerPort = 9100; // Default port, can be changed by user
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;

//   @override
//   void initState() {
//     super.initState();
//     _getBluetoothDevices();
//   }

//   Future<void> _getBluetoothDevices() async {
//     bool isOn = (await bluetooth.isOn) ?? false;
//     if (isOn) {
//       List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
//       setState(() {
//         _devices = devices;
//       });
//     }
//   }

//   Future<void> printBill() async {
//     if (useWiFi) {
//       await _printViaWiFi();
//     } else {
//       await _printViaBluetooth();
//     }
//   }

//   Future<void> _printViaWiFi() async {
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(PaperSize.mm80, profile);

//     final res = await printer.connect(printerIp, port: printerPort);
//     if (res == PosPrintResult.success) {
//       _printReceipt(printer);
//       printer.disconnect();
//     } else {
//       print('Could not connect to printer.');
//     }
//   }

//   Future<void> _printViaBluetooth() async {
//     if (_selectedDevice == null) {
//       print('No Bluetooth device selected.');
//       return;
//     }

//     await bluetooth.connect(_selectedDevice!);
//     bool isConnected = (await bluetooth.isConnected) ?? false;
//     if (isConnected) {
//       _printReceiptBluetooth(bluetooth);
//       bluetooth.disconnect();
//     } else {
//       print('Could not connect to printer.');
//     }
//   }

//   void _printReceipt(NetworkPrinter printer) {
//     // Add your receipt printing logic here
//   }

//   void _printReceiptBluetooth(BlueThermalPrinter bluetooth) {
//     // Add your receipt printing logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Print Bill')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SwitchListTile(
//               title: Text('Use Wi-Fi Printer'),
//               value: useWiFi,
//               onChanged: (bool value) {
//                 setState(() {
//                   useWiFi = value;
//                 });
//               },
//             ),
//             if (useWiFi) ...[
//               TextField(
//                 decoration: InputDecoration(labelText: 'Printer IP Address'),
//                 onChanged: (value) {
//                   printerIp = value;
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Printer Port'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   printerPort = int.tryParse(value) ?? 9100;
//                 },
//               ),
//             ] else ...[
//               DropdownButton<BluetoothDevice>(
//                 hint: Text('Select Bluetooth Device'),
//                 value: _selectedDevice,
//                 onChanged: (BluetoothDevice? value) {
//                   setState(() {
//                     _selectedDevice = value;
//                   });
//                 },
//                 items: _devices.map((device) {
//                   return DropdownMenuItem<BluetoothDevice>(
//                     value: device,
//                     child: Text(device.name ?? ''),
//                   );
//                 }).toList(),
//               ),
//             ],
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: printBill,
//               child: Text('Print Bill'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// How to get wifi connected devices to print not manual entry
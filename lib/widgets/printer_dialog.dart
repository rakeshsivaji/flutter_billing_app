import 'package:billing_app/Models/orderdetails_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class PrinterDialog extends StatefulWidget {
  final Data? data;
  final double? totalAmount;
  final double? paidAmount;
  final double? pendingAmount;

  const PrinterDialog({
    super.key,
    this.data,
    this.totalAmount,
    this.pendingAmount,
    this.paidAmount,
  });

  @override
  State<PrinterDialog> createState() => _PrinterDialogState();
}

class _PrinterDialogState extends State<PrinterDialog> {
  final _commonController = CommonController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Image.asset(
            'assets/images/print.png',
            color: const Color.fromRGBO(120, 89, 207, 1),
          ),
          const SizedBox(
            height: 18,
          ),
          _buildContent(),
          const SizedBox(
            height: 18,
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget _buildContent() {
    return const Text(
      'நீங்கள் ரசீதை அச்சிட விரும்புகிறீர்களா !',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            _noButton(),
            const SizedBox(
              width: 6,
            ),
            _printButton(),
          ],
        )
      ],
    );
  }

  Widget _printButton() {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(120, 89, 207, 1)),
        child: ElevatedButton(
          style: const ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromRGBO(120, 89, 207, 1))),
          onPressed: _buttonOnPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/print.png',
                width: 20,
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Text(
                'அச்சு',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ));
  }

  void _buttonOnPress() {
    Navigator.pop(context);
    Get.toNamed('/shopBillReceipt', arguments: {
      'data': widget.data,
      'totalAmount': widget.totalAmount,
      'pendingAmount': widget.pendingAmount,
      'paidAmount': widget.paidAmount,
    });
  }

  Widget _noButton() {
    return TextButton(
        onPressed: () => Navigator.pop(context), child: const Text('வேண்டாம்'));
  }
}

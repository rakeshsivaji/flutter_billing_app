import 'dart:async';

import 'package:billing_app/Models/get_shops_balance_amount_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShopsBalanceAmount extends StatefulWidget {
  const ShopsBalanceAmount({super.key});

  @override
  State<ShopsBalanceAmount> createState() => _ShopsBalanceAmountState();
}

class _ShopsBalanceAmountState extends State<ShopsBalanceAmount> {
  final _appColors = AppColors();
  var _commonCon = Get.put(CommonController());
  bool _isSort = false;
  String? sortOrderId;
  final _sortStream = StreamController.broadcast();
  final _shopSearchController = TextEditingController();
  String _selectedPathId = '';
  String _selectedShopId = '';
  String _selectedRoute = '';
  String? _selectedPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      flexibleSpace: ClipPath(
        clipper: CurvedEdges(),
        child: Container(
          color: const Color.fromRGBO(120, 89, 207, 1),
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: _appColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'கடையின் மீதமுள்ள தொகை',
                          style: TextStyle(color: _appColors.whiteColor),
                        )
                      ],
                    ),
                    _buildSortSwitchButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortSwitchButton() {
    return StreamBuilder(
        stream: _sortStream.stream,
        builder: (context, snapshot) {
          return Switch(
            value: _isSort,
            onChanged: (value) async {
              _isSort = !_isSort;
              _isSort == true ? sortOrderId = 'desc' : sortOrderId = 'asc';
              await _commonCon.getShopsBalanceAmount(
                  sortOrder: sortOrderId,
                  withLoader: false,
                  search: _shopSearchController.text,
                  filter: _selectedPathId);
              _isSort == true
                  ? showToast('பெரியது முதல் சிறியது')
                  : showToast('சிறியது முதல் பெரியது');
              _sortStream.add(true);
            },
          );
        });
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDropDownButtonFormField(
                  dropDownValue: _selectedRoute,
                  inputBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  onChange: (value) async {
                    _selectedPathId = value.toString();
                    _selectedPath = null;
                    _selectedShopId = '';
                    await _commonCon.getPathStore(_selectedPathId);
                    await _commonCon.getShopsBalanceAmount(
                        withLoader: false,
                        sortOrder: sortOrderId,
                        search: _selectedShopId,
                        filter: _selectedPathId);
                    _sortStream.add(true);
                  },
                  height: 50,
                  width: MediaQuery.sizeOf(context).width / 2.5,
                  hintText: 'பாதையின் பெயரை தேடுக',
                  items: _commonCon.pathmodel.value?.data.map((item) {
                    return DropdownMenuItem<String?>(
                      value: item.pathId.toString() ?? '',
                      child: Text(
                        item.name ?? '',
                        style: GoogleFonts.nunitoSans(
                            color: AppColors().blackColor),
                      ),
                    );
                  }).toList(),
                ),
                StreamBuilder(
                    stream: _sortStream.stream,
                    builder: (context, snapshot) {
                      return CustomDropDownButtonFormField(
                        dropDownValue: _selectedPath,
                        inputBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        onChange: (value) async {
                          _selectedShopId = value.toString();
                          _selectedPath = value;
                          await _commonCon.getShopsBalanceAmount(
                              withLoader: false,
                              sortOrder: sortOrderId,
                              search: _selectedShopId,
                              filter: _selectedPathId);
                          _sortStream.add(true);
                        },
                        height: 50,
                        width: MediaQuery.sizeOf(context).width / 2.5,
                        hintText: 'kadai பெயரை தேடுக',
                        items:
                            _commonCon.pathStoreModel.value?.data.map((item) {
                          return DropdownMenuItem<String?>(
                            value: item.name.toString() ?? '',
                            child: Text(
                              item.name ?? '',
                              style: GoogleFonts.nunitoSans(
                                  color: AppColors().blackColor),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                /*CustomFormField(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width / 2.5,
                    hintText: 'கடையின் பெயரை உள்ளிடவும்',
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    onChanged: (value) async {
                      await _commonCon.getShopsBalanceAmount(
                          withLoader: false,
                          sortOrder: sortOrderId,
                          search: value,
                          filter: _selectedPathId);
                      _sortStream.add(true);
                    },
                    controller: _shopSearchController)*/
              ],
            ),
          ),
          _buildBalanceAmountShopList()
        ],
      ),
    );
  }

  Widget _buildBalanceAmountShopList() {
    return StreamBuilder(
        stream: _sortStream.stream,
        builder: (context, snapshot) {
          return Flexible(
              child: Container(
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    _commonCon.getShopsBalanceAmountModel.value?.data?.length,
                itemBuilder: (context, index) => _buildItemBuilder(
                    _commonCon.getShopsBalanceAmountModel.value?.data?[index])),
          ));
        });
  }

  Widget _buildItemBuilder(BalanceAmountData? data) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _appColors.greyColor.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'பாதையின் பெயர் : ${data?.pathName ?? ' '}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data?.shopName ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                formatInRupee(data?.pendingAmount?.toDouble()),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatInRupee(double? amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
    );
    if (amount == null) {
      return formatter.format(0);
    }
    return formatter.format(amount);
  }

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
}

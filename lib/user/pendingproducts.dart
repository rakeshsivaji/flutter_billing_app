import 'dart:async';

import 'package:billing_app/Models/shop_pending_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/user/receipts/user_pending_receipt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingProducts extends StatefulWidget {
  const PendingProducts({super.key});

  @override
  State<PendingProducts> createState() => _PendingProductsState();
}

class _PendingProductsState extends State<PendingProducts> {
  var commonController = Get.put(CommonController());
  String lineid = '';
  List<bool> pending = [];
  final _shopNameSearchController = TextEditingController();
  final _shopListStream = StreamController.broadcast();
  bool? hasData;
  String _selectedPathName = '';
  String _selectedShopName = '';
  final _pathStream = StreamController.broadcast();
  final _storeStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    lineid = (Get.arguments?['id']) ?? '';
    if (Get.arguments?['statusCode'] == 1) {
      hasData = true;
    } else {
      hasData = false;
    }
    print(lineid);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // await commonController.getuserlinereport(lineid.toString());
        // Get.toNamed('/newstock', arguments: {'id': lineid, 'status': true});
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
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
                              onTap: () async {
                                Navigator.pop(context);
                                // await commonController
                                //     .getuserlinereport(lineid.toString());
                                // Get.toNamed('/newstock',
                                //     arguments: {'id': lineid, 'status': true});
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
                            'நிலுவையில் உள்ள பொருட்கள்',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPendingReceipt(
                                        data: commonController
                                            .shopPendingModel.value?.data),
                                  ));
                            },
                            icon: const Icon(
                              Icons.print,
                              color: Colors.white,
                              size: 28,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: StreamBuilder(
                      stream: _shopListStream.stream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            _buildShopNameAndPathNameFilterDropdown(),
                            AppWidgetUtils.buildSizedBox(custHeight: 20),
                            /*CustomFormField(
                              hintText: 'கடைகளைத் தேடுக',
                              onChanged: (value) async {
                                _shopNameSearchController.text = value;
                                await commonController.getshopPendingreport(
                                  lineid,
                                  search: _shopNameSearchController.text,
                                  callBackFunction: (statusCode) {
                                    if (statusCode == 1) {
                                      hasData = true;
                                    } else {
                                      hasData = false;
                                    }
                                  },
                                );
                                _shopListStream.add(true);
                              },
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              controller: _shopNameSearchController),
                          const SizedBox(
                            height: 20,
                          ),*/

                            /*StreamBuilder(
                            stream: _shopListStream.stream,
                            builder: (context, snapshot) {
                              return commonController.shopPendingModel.value?.data ==
                                  null ||
                                  commonController
                                      .shopPendingModel.value!.data.isEmpty ||
                                  commonController
                                      .shopPendingModel.value!.data ==
                                      []
                                  ? Text('ஆர்டர்கள் பட்டியல் இல்லை')
                                  : Flexible(
                                child: Container(
                                  child: ListView.builder(
                                    itemCount: commonController.shopPendingModel.value?.data.length ?? 0,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      pending.add(false);
                                      return buildCard(
                                        index,
                                        commonController.shopPendingModel.value!.data[index],
                                      );
                                    },
                                  ),
                                ),
                              );
                              // return const SizedBox.shrink();
                            },
                          ),*/

                            if (commonController
                                        .shopPendingModel.value?.data ==
                                    null ||
                                commonController
                                    .shopPendingModel.value!.data.isEmpty ||
                                commonController.shopPendingModel.value!.data ==
                                    []) ...[
                              const Text('ஆர்டர்கள் பட்டியல் இல்லை'),
                            ] else ...[
                              ListView.builder(
                                itemCount: commonController
                                        .shopPendingModel.value?.data.length ??
                                    0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  pending.add(false);
                                  return buildCard(
                                      index,
                                      commonController
                                          .shopPendingModel.value!.data[index]);
                                },
                              )
                            ]
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(int index, ShopPendingDataModel data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
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
                  Expanded(
                    child: SelectableText(
                      data.storeName,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  SelectableText(
                    data.date.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
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
                  data.pathName.toString(),
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
                  data.storeName,
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
                  data.storeAddress,
                  style: const TextStyle(fontSize: 13),
                ),
              )),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      pending[index] = !pending[index];
                    });
                  },
                  child: const Text(
                    'விபரங்களை பார்க்க',
                    style: TextStyle(
                        fontSize: 11, color: Color.fromRGBO(120, 89, 207, 1)),
                  ),
                ),
              ],
            ),
          ),
          pending[index]
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ஆர்டர் விவரங்கள்',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ListView.builder(
                      itemCount: data.pendingQuantity.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return buildItems(data.pendingQuantity[index]);
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    )
                  ],
                )
              : const SizedBox(
                  height: 10.0,
                ),
        ],
      ),
    );
  }

  Padding buildItems(PendingQuantity data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 8, child: SelectableText(data.name)),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText('x ' + data.quantity.toString(),
                      style: const TextStyle(fontSize: 15)),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: _pathStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _selectedPathName,
                'பாதையைத் தேர்ந்தெடுக்கவும்',
                commonController.pathmodel.value?.data.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.pathId.toString(),
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _selectedPathName = onChangeValue.toString();
                  _selectedShopName = '';
                  await commonController.getPathStore(_selectedPathName);
                  await commonController.getshopPendingreport(
                    lineid,
                    pathId: _selectedPathName,
                    callBackFunction: (statusCode) {
                      if (statusCode == 0) {
                        commonController.shopPendingModel.value?.data = [];
                      }
                    },
                  );
                  _shopListStream.add(true);
                  _storeStream.add(true);
                },
              );
            }),
        StreamBuilder(
            stream: _storeStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _selectedShopName,
                'தேர்வு கடை',
                commonController.pathStoreModel.value?.data.map((item) {
                      return DropdownMenuItem<String?>(
                        value: item.id.toString(),
                        child: Text(
                          item.name,
                          style: GoogleFonts.nunitoSans(
                              color: AppColors().blackColor),
                        ),
                      );
                    }).toList() ??
                    [],
                (onChangeValue) async {
                  _selectedShopName = onChangeValue.toString();
                  await commonController.getshopPendingreport(
                    lineid,
                    pathId: _selectedPathName,
                    shopId: _selectedShopName,
                    callBackFunction: (statusCode) {
                      if (statusCode == 0) {
                        commonController.shopPendingModel.value?.data = [];
                      }
                    },
                  );
                  _shopListStream.add(true);
                },
              );
            }),
      ],
    );
  }

  Widget _buildShopNameDropdown(
    String dropDownValue,
    String hintText,
    List<DropdownMenuItem<String?>> menuItems,
    Function(String?)? onChange,
  ) {
    return CustomDropDownButtonFormField(
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)
      ],
      fillColor: Colors.white,
      inputBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      width: MediaQuery.sizeOf(context).width / 2.4,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }
}

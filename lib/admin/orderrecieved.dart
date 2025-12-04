import 'dart:async';

import 'package:billing_app/Models/pending_recieved_order_model.dart';
import 'package:billing_app/Models/received_order_model.dart';
import 'package:billing_app/Models/tomorrow_received_order_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrdersRecieved extends StatefulWidget {
  const OrdersRecieved({super.key});

  @override
  State<OrdersRecieved> createState() => _OrdersRecievedState();
}

class _OrdersRecievedState extends State<OrdersRecieved>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isOrderDetailsExpanded = false;
  DateTime _startDate = DateTime.now();

  var commonController = Get.put(CommonController());
  List<bool> order = [];
  List<bool> tomorrow = [];
  List<bool> pending = [];
  String _orderSelectedPathName = '';
  String _orderSelectedShopName = '';
  final _orderPathStream = StreamController.broadcast();
  final _orderStoreStream = StreamController.broadcast();
  String _previousOrderSelectedPathName = '';
  String _previousOrderSelectedShopName = '';
  final _previousOrderPathStream = StreamController.broadcast();
  final _previousOrderStoreStream = StreamController.broadcast();
  String _niluvaiOrderSelectedPathName = '';
  String _niluvaiOrderSelectedShopName = '';
  final _niluvaiOrderPathStream = StreamController.broadcast();
  final _niluvaiOrderStoreStream = StreamController.broadcast();

  final _previousOrderStream = StreamController.broadcast();
  final _niluvaiOrderStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchPath();
    setState(() {
      selectedDate = DateTime.now();
      selectedDateString = DateFormat('yyyy-MM-dd').format(_startDate);
    });
  }

  Future<void> _fetchPath() async {
    await commonController.getPath(withLoader: true);
    _orderPathStream.add(true);
  }

  tommarowSearch({String? search, String? storeId, String? pathId}) async {
    await commonController.getTomorrowReceivedorder(
        withLoader: false, search: search, pathId: pathId, storeId: storeId);
    _previousOrderStream.add(true);
  }

  pendingSearch({String? search, String? storeId, String? pathId}) async {
    await commonController.getPendingReceivedorder(
        withLoader: false, search: search, pathId: pathId, storeId: storeId);
    _niluvaiOrderStream.add(true);
  }

  final TextEditingController search0 = TextEditingController();
  final TextEditingController search1 = TextEditingController();
  final TextEditingController search2 = TextEditingController();
  String selecteddate = '';

  DateTime selectedDate = DateTime.now();
  String selectedDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      selectedDateString = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  orderSearch({String? search, String? storeId, String? pathId}) async {
    commonController.getReceivedorder(
        withLoader: false,
        search: search,
        date: selectedDateString,
        storeId: storeId,
        pathId: pathId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Obx(() {
          return Column(
            children: [
              CustomAppBar(
                text: 'ஆர்டர்கள் பெறப்பட்டன',
                path: '/adminhome',
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30))),
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25.0,
                        ),
                        TabBar(
                          dividerHeight: 0.0,
                          indicatorColor: const Color.fromRGBO(120, 89, 207, 1),
                          indicator: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          automaticIndicatorColorAdjustment: true,
                          controller: _tabController,
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          unselectedLabelColor: Colors.black,
                          tabs: <Widget>[
                            const Tab(
                              text: '      ஆர்டர்கள்     ',
                            ),
                            const Tab(
                              text:
                                  '      முன்கூட்டிய       \n        ஆர்டர்கள்      ',
                            ),
                            const Tab(
                              text: '    நிலுவையில்        \n         உள்ளது',
                            )
                          ],
                        ),
                        TabBar(
                          dividerHeight: 0.0,
                          indicatorColor: const Color.fromRGBO(120, 89, 207, 1),
                          indicatorPadding:
                              const EdgeInsets.only(bottom: 30, top: 15),
                          indicator: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          automaticIndicatorColorAdjustment: true,
                          controller: _tabController,
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          unselectedLabelColor: Colors.black,
                          tabs: <Widget>[
                            Tab(
                              child: Container(
                                height: 2,
                                width: 100,
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 2,
                                width: 100,
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 2,
                                width: 100,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      buildSearchDateBar(context),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (commonController.orderRecieved ==
                                          false) ...[
                                        const Text('ஆர்டர்கள் பட்டியல் இல்லை'),
                                      ] else ...[
                                        ListView.builder(
                                          itemCount: commonController
                                              .receivedorderModel
                                              .value!
                                              .data
                                              .orderReceived
                                              .length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            order.add(false);
                                            return buildCard(
                                                index,
                                                commonController
                                                    .receivedorderModel
                                                    .value!
                                                    .data
                                                    .orderReceived[index]);
                                          },
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SingleChildScrollView(
                                  child: StreamBuilder(
                                    stream: _previousOrderStream.stream,
                                    builder: (context, snapshot) {
                                      return Column(
                                        children: [
                                          _buildPreviousOrderFilterDropdown(),
                                          // buildSearch(context),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (commonController
                                                  .tomorrowOrderRecieved ==
                                              false) ...[
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            const Text(
                                              ' முன்கூட்டிய ஆர்டர்கள் இல்லை',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ] else ...[
                                            ListView.builder(
                                              itemCount: commonController
                                                  .tomorrowRecievedOrderModel
                                                  .value!
                                                  .data
                                                  .tomorrowOrder
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                tomorrow.add(false);
                                                return buildCard2(
                                                    index,
                                                    commonController
                                                        .tomorrowRecievedOrderModel
                                                        .value!
                                                        .data
                                                        .tomorrowOrder[index]);
                                              },
                                            )
                                          ]
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: SingleChildScrollView(
                                  child: StreamBuilder(
                                    stream: _niluvaiOrderStream.stream,
                                    builder: (context, snapshot) {
                                      return Column(
                                        children: [
                                          // buildSearch1(context),
                                          _buildNiluvaiOrderFilterDropdown(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          if (commonController
                                                  .pendingOrderRecieved ==
                                              false) ...[
                                            const Text(
                                              'நிலுவையிலுள்ள பட்டியல் இல்லை',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ] else ...[
                                            ListView.builder(
                                              itemCount: commonController
                                                  .pendingRecievedOrderModel
                                                  .value
                                                  ?.data
                                                  .pendingOrder
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                pending.add(false);
                                                return buildCard3(
                                                    index,
                                                    commonController
                                                        .pendingRecievedOrderModel
                                                        .value
                                                        ?.data
                                                        .pendingOrder[index]);
                                              },
                                            )
                                          ]
                                        ],
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildCard(int index, OrderReceived data) {
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    data.orderId.toString(),
                    style: const TextStyle(color: Colors.white),
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Text(
                    data.storeAddress,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
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
                      order[index] = !order[index];
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
          order[index]
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'ஆர்டர் விவரங்கள்',
                    //       style: TextStyle(fontSize: 15),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    ListView.builder(
                      itemCount: data.orders.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      reverse: true,
                      itemBuilder: (context, index) {
                        // int finalIndex = index + 1;
                        int finalIndex = data.orders.length - index;
                        return buildTimeWise(finalIndex, data.orders[index]);
                      },
                    ),
                    // SizedBox(
                    //   height: 10.0,
                    // )
                  ],
                )
              : const SizedBox(
                  height: 10.0,
                ),
        ],
      ),
    );
    // } else {
    //   return SizedBox.shrink();
    // }
  }

  Widget buildCard3(int index, DataPendingOrder? data) {
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
      child: Stack(
        children: [
          Column(
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
                        data?.orderId.toString() ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      SelectableText(
                        data?.date.toString() ?? '',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: SelectableText(
                      data?.pathName.toString() ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: SelectableText(
                      data?.storeName ?? '',
                      style:
                          const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      data?.storeAddress ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10.0,
                ),
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
                            fontSize: 11,
                            color: Color.fromRGBO(120, 89, 207, 1)),
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
                          itemCount: data?.pendingOrders.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return buildItems3(data?.pendingOrders[index]);
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 10.0,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard2(int index, DataTomorrowOrder data) {
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
      child: Stack(
        children: [
          Column(
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
                        data.orderId.toString(),
                        style: const TextStyle(color: Colors.white),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: SelectableText(
                      data.storeName,
                      style:
                          const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      data.storeAddress,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
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
                          tomorrow[index] = !tomorrow[index];
                        });
                      },
                      child: const Text(
                        'விபரங்களை பார்க்க',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color.fromRGBO(120, 89, 207, 1)),
                      ),
                    ),
                  ],
                ),
              ),
              tomorrow[index]
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
                          itemCount: data.tomorrowOrders.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return buildItems2(data.tomorrowOrders[index]);
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 10.0,
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildTimeWise(int index, Order data) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ஆர்டர் $index',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
              ),
              Text(
                'நேரம் : ' + data.time,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ListView.builder(
          itemCount: data.listOrders.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return buildItems(data.listOrders[index]);
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Divider(
          height: 0.5,
        ),
      ],
    );
  }

  Padding buildItems(ListOrder data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 6, child: SelectableText(data.name)),
          Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                      '${data.quantity ?? ''} x ${data.amount ?? ''}',
                      style: const TextStyle(fontSize: 15)),
                ],
              )),
        ],
      ),
    );
  }

  Padding buildItems2(TomorrowOrderTomorrowOrder data) {
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
                  SelectableText('${data.quantity} x ${data.amount}',
                      style: const TextStyle(fontSize: 15)),
                ],
              )),
        ],
      ),
    );
  }

  Padding buildItems3(PendingOrderPendingOrder? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SelectableText(data?.name ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SelectableText('${data?.quantity} x ${data?.amount}',
                  style: const TextStyle(fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSearchDateBar(BuildContext context) {
    return Column(
      children: [
        _buildShopNameAndPathNameFilterDropdown(),
        AppWidgetUtils.buildSizedBox(custHeight: 12),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: TextFormField(
                  controller: search0,
                  onChanged: (value) {
                     orderSearch(search: value);
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    hintText: 'தேடு கடை...',
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 13),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            SizedBox(width: 8),*/
            GestureDetector(
              onTap: () => selectDate(context),
              child: Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width / 2,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 17, color: Colors.black87),
                    const SizedBox(width: 4),
                    Text(selectedDateString,
                        style: const TextStyle(color: Colors.black87, fontSize: 15)),
                    const Icon(Icons.arrow_drop_down, color: Colors.black87),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                orderSearch(
                    search: search0.text,
                    pathId: _orderSelectedPathName,
                    storeId: _orderSelectedShopName);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'தேடு',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSearch(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: TextFormField(
                  controller: search1,
                  onChanged: (value) {
                    tommarowSearch(search: value);
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    hintText: 'தேடு கடை...',
                    hintStyle: const TextStyle(color: Colors.black87, fontSize: 13),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearch1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: TextFormField(
                  controller: search2,
                  onChanged: (value) {
                    pendingSearch(search: value);
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    hintText: 'தேடு கடை...',
                    hintStyle: const TextStyle(color: Colors.black87, fontSize: 13),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: _orderPathStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _orderSelectedPathName,
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
                  _orderSelectedPathName = onChangeValue.toString();
                  _orderSelectedShopName = '';
                  await commonController.getPathStore(_orderSelectedPathName);
                  _orderStoreStream.add(true);
                },
              );
            }),
        const SizedBox(height: 10,),
        StreamBuilder(
            stream: _orderStoreStream.stream,
            builder: (context, snapshot) {
              return _buildShopNameDropdown(
                _orderSelectedShopName,
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
                  _orderSelectedShopName = onChangeValue.toString();
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
      width: MediaQuery.sizeOf(context).width ,
      // width: MediaQuery.sizeOf(context).width / 2.4,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }

  Widget _buildPreviousOrderFilterDropdown() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: _previousOrderPathStream.stream,
            builder: (context, snapshot) {
              return _buildPreviousOrderShopNameDropdown(
                _previousOrderSelectedPathName,
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
                  _previousOrderSelectedPathName = onChangeValue.toString();
                  _previousOrderSelectedShopName = '';
                  tommarowSearch(pathId: _previousOrderSelectedPathName);
                  await commonController
                      .getPathStore(_previousOrderSelectedPathName);
                  _previousOrderStoreStream.add(true);
                },
              );
            }),
        const SizedBox(height: 10,),
        StreamBuilder(
            stream: _previousOrderStoreStream.stream,
            builder: (context, snapshot) {
              return _buildPreviousOrderShopNameDropdown(
                _previousOrderSelectedShopName,
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
                  _previousOrderSelectedShopName = onChangeValue.toString();
                  tommarowSearch(
                      pathId: _previousOrderSelectedPathName,
                      storeId: _previousOrderSelectedShopName);
                },
              );
            }),
      ],
    );
  }

  Widget _buildPreviousOrderShopNameDropdown(
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
      // width: MediaQuery.sizeOf(context).width / 2.4,
      width: MediaQuery.sizeOf(context).width,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }

  Widget _buildNiluvaiOrderFilterDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
            stream: _niluvaiOrderPathStream.stream,
            builder: (context, snapshot) {
              return _buildNiluvaiOrderShopNameDropdown(
                _niluvaiOrderSelectedPathName,
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
                  _niluvaiOrderSelectedPathName = onChangeValue.toString();
                  _niluvaiOrderSelectedShopName = '';
                  pendingSearch(pathId: _niluvaiOrderSelectedPathName);
                  await commonController
                      .getPathStore(_niluvaiOrderSelectedPathName);
                  _niluvaiOrderStoreStream.add(true);
                },
              );
            }),
        const SizedBox(height: 10,),
        StreamBuilder(
            stream: _niluvaiOrderStoreStream.stream,
            builder: (context, snapshot) {
              return _buildNiluvaiOrderShopNameDropdown(
                _niluvaiOrderSelectedShopName,
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
                  _niluvaiOrderSelectedShopName = onChangeValue.toString();
                  pendingSearch(
                      pathId: _niluvaiOrderSelectedPathName,
                      storeId: _niluvaiOrderSelectedShopName);
                },
              );
            }),
      ],
    );
  }

  Widget _buildNiluvaiOrderShopNameDropdown(
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
      width: MediaQuery.sizeOf(context).width,
      // width: MediaQuery.sizeOf(context).width / 2.4,
      height: 50,
      onChange: onChange,
      dropDownValue: dropDownValue,
      hintText: hintText,
      key: UniqueKey(),
      items: menuItems,
    );
  }
}

// class SearchAndDateWidget extends StatefulWidget {
//   @override
//   _SearchAndDateWidgetState createState() => _SearchAndDateWidgetState();
// }

// class _SearchAndDateWidgetState extends State<SearchAndDateWidget> {
//   DateTime _startDate = DateTime.now();
//   String selecteddate = '';
//   TextEditingController _searchController = TextEditingController();
//   bool _showThetuContainer = false;

//   @override
//   void initState() {
//     super.initState();
//     _resetState();
//   }

//   void _resetState() {
//     setState(() {
//       _startDate = DateTime.now();
//       selecteddate = DateFormat("yyyy-MM-dd").format(_startDate);
//     });
//   }

// DateTime selectedDate = DateTime.now();
// String selectedDateString = DateFormat('dd-MM-yyyy').format(DateTime.now());

// Future<void> selectDate(BuildContext context) async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: selectedDate,
//     firstDate: DateTime(2000),
//     lastDate: DateTime(2101),
//   );
//   if (picked != null && picked != selectedDate) {
//     selectedDate = picked;
//     selectedDateString = DateFormat('dd-MM-yyyy').format(picked);
//     // You'll need to call setState() here if using StatefulWidget
//   }
// }

//   void _searchThetu() {
//     // Implement your search logic here
//     // For this example, we'll just toggle the visibility of the Thetu container
//     setState(() {
//       _showThetuContainer = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               labelText: 'Search',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: _searchThetu,
//               ),
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () => _selectDate(context),
//           child: Text('Select date: $selecteddate'),
//         ),
//         SizedBox(height: 20),
//         if (_showThetuContainer)
//           Container(
//             padding: EdgeInsets.all(16),
//             color: Colors.purple,
//             child: Text(
//               'Thetu Container',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//       ],
//     );
//   }
// }

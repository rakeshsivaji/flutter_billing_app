import 'package:billing_app/Models/stock_history_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Stlisthistory extends StatefulWidget {
  const Stlisthistory({super.key});

  @override
  State<Stlisthistory> createState() => _StlisthistoryState();
}

class _StlisthistoryState extends State<Stlisthistory> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String fSdate = '';
  String fEdate = '';
  String lineid = '';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  var commonController = Get.put(CommonController());

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
      useRootNavigator: false, // Show as dialog
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        fSdate = formatter.format(_startDate);
        fEdate = formatter.format(_endDate);
        filterStocks();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lineid = Get.arguments['id'];
  }

  // DateTime _selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/cstlist', arguments: {'id': lineid});
        return false;
      },
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          body: Obx(() {
            return Column(
              children: [
                // CustomAppBar(text: 'ஸ்டாக் பட்டியல் வரலாறு', path: '/cstlist'),
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
                                    Get.toNamed('/cstlist', arguments: {
                                      'id': lineid,
                                    });
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
                                'ஸ்டாக் பட்டியல் வரலாறு',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
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
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                _selectDateRange(context);
                              },
                              child: Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    Text(
                                      '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
                                    ),
                                    Image.asset(
                                      'assets/images/arrowdown.png',
                                      width: 13,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            if (commonController.stockHistory == false) ...[
                              const Text('வேறு தகவல்கள் இல்லை'),
                            ] else ...[
                              Container(
                                child: ListView.builder(
                                  itemCount: commonController
                                      .stockHistoryModel.value!.data.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                    return buildCard(commonController
                                        .stockHistoryModel.value!.data[index]);
                                  }),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }

  filterStocks() async {
    await commonController.getStockHistory(
      withLoader: false,
      startDate: fSdate,
      endDate: fEdate,
    );
  }

  Container buildCard(Datum data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 15),
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
                  const Expanded(
                    child: Text(
                      'மொத்த ஸ்டாக்குகளின் பட்டியல்',
                      //'ID #123456789',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SelectableText(
                    data.date,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
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
          ...[
            Container(
              child: ListView.builder(
                itemCount: data.stockItem.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return buildCardItem(data.stockItem[index]);
                }),
              ),
            ),
          ],
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
                  '₹ ' + data.amount,
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCardItem(StockItem data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(data.name),
                SelectableText(data.quantity + ' x ' + data.price),
              ],
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SelectableText('₹ ' + data.amount),
            ],
          ))
        ],
      ),
    );
  }
}

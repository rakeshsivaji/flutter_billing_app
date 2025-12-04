import 'dart:async';

import 'package:billing_app/Models/totalbills_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BillHistory extends StatefulWidget {
  const BillHistory({super.key});

  @override
  State<BillHistory> createState() => _BillHistoryState();
}

class _BillHistoryState extends State<BillHistory> {
  String dropdownValue = '';
  bool isClientsOption = false;
  var commonController = Get.put(CommonController());
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String fSdate = '';
  String fEdate = '';
  List<Datum> totalsbills = [];
  final _listStream = StreamController.broadcast();
  Timer? _debounce;
  final _shopSearchController = TextEditingController();
  String _selectedPathName = '';
  String _selectedShopName = '';
  final _pathStream = StreamController.broadcast();
  final _storeStream = StreamController.broadcast();
  final _storeListStream = StreamController.broadcast();

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
      useRootNavigator: false,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        fSdate = formatter.format(_startDate);
        fEdate = formatter.format(_endDate);
      });
      filterJobs();
    }
  }

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  String formatDates(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  void initState() {
    totalsbills = commonController.totalbillsModel.value?.data ?? [];
    fSdate = formatter.format(_startDate);
    fEdate = formatter.format(_endDate);
    super.initState();
    _pathStream.add(true);

    // ADD THIS - Make initial bill history API call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterJobs(); // This will call getbillhistory with today's date
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/allbills');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'ரசிது வரலாறு',
              path: '/allbills',
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25.0,
                      ),
                      GestureDetector(
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
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(
                                '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
                              ),
                              const Icon(Icons
                                  .arrow_drop_down), // Removed individual GestureDetector
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      // _buildShopNameFilter(),
                      _buildShopNameAndPathNameFilterDropdown(),
                      const SizedBox(
                        height: 25.0,
                      ),
                      StreamBuilder(
                          stream: _listStream.stream,
                          builder: (context, snapshot) {
                            totalsbills =
                                commonController.totalbillsModel.value?.data ??
                                    [];
                            if (commonController.totalbillsModel.value ==
                                null) {
                              return const Center(
                                  child: Text('ரசிதுகள் இல்லை'));
                            }
                            return ListView.builder(
                              itemCount: totalsbills.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                return buildCard(totalsbills[index]);
                              }),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  filterJobs() async {
    commonController.getbillhistory(
      startDate: fSdate,
      endDate: fEdate,
      shopName: _shopSearchController.text,
      functionCallBack: (statusCode) {
        if (statusCode == 1) {
          totalsbills = commonController.totalbillsModel.value?.data ?? [];
          _listStream.add(true);
        } else {
          totalsbills = [];
          _listStream.add(true);
        }
      },
    );
  }

  Widget buildCard(Datum data) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await commonController.getBillDetails(data.billId.toString());
            Get.toNamed('/billdetails2', arguments: {'id': data.billId});
          },
          child: Container(
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectableText(
                              'ID #${data.orderNo}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            SelectableText(
                              data.date,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
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
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: SelectableText(
                            data.path,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: SelectableText(
                            data.storeAddress,
                            style: const TextStyle(fontSize: 13),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                Positioned(
                    bottom: 5,
                    right: 10,
                    child: InkWell(
                        onTap: () async {
                          // Get.toNamed('/billdetails2');
                          await commonController
                              .getBillDetails(data.billId.toString());
                          Get.toNamed('/billdetails2',
                              arguments: {'id': data.billId});
                          // Navigator.pushReplacementNamed(
                          //     context, '/billdetails2');
                        },
                        child: const Text(
                          'விபரங்களை பார்க்க',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color.fromRGBO(120, 89, 207, 1)),
                        )))
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildShopNameFilter() {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: _shopSearchController,
        onChanged: (value) {
          /* if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {*/
          filterJobs();
          // });
        },
        decoration: InputDecoration(
          hintText: 'தேடு ரசிது',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          suffixIcon: IconButton(
            onPressed: () {
              // filterBills(searchText: '');
            },
            icon: Image.asset(
              'assets/images/search.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
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
                  await commonController.getbillhistory(
                      startDate: fSdate,
                      endDate: fEdate,
                      pathId: _selectedPathName);
                  _listStream.add(true);
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
                  await commonController.getbillhistory(
                      startDate: fSdate,
                      endDate: fEdate,
                      pathId: _selectedPathName,
                      storeId: _selectedShopName);
                  _listStream.add(true);
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

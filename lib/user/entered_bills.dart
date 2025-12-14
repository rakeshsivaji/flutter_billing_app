import 'dart:async';

import 'package:billing_app/Models/get_all_user_bill_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EnteredBills extends StatefulWidget {
  const EnteredBills({super.key});

  @override
  State<EnteredBills> createState() => _EnteredBillsState();
}

class _EnteredBillsState extends State<EnteredBills> {
  var commonController = Get.put(CommonController());
  List<String> list = <String>['total_bill', 'order_received', 'pending_order'];
  late List<String?> storeList = commonController.getAllStoresModel.value?.data
          ?.map(
            (e) => e.name ?? '',
          )
          .toList() ??
      [];
  String dropdownValue = '';
  String selectedStoreName = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String fSdate = '';
  String fEdate = '';
  final _searchController = TextEditingController();
  String _selectedPathName = '';
  String _selectedShopName = '';
  final _pathStream = StreamController.broadcast();
  final _storeStream = StreamController.broadcast();
  final _listStream = StreamController.broadcast();

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
        filterJobs();
      });
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

  @override
  void initState() {
    super.initState();
    _pathStream.add(true);
    setState(() {
      // filterJobs();
      _endDate = DateTime.now();
      _startDate = _endDate;
      fSdate = formatDates(_startDate);
      fEdate = formatDates(_endDate);

      _pathStream.add(true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        filterJobs();
      }
    });
  }

  Future<void> refreshvalue() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await commonController.getAllBillEntries();
    await commonController.getAllBillStores();
    await commonController.getAllUserBillEntries();
    print('Value');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshvalue,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(120, 89, 207, 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
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
                                Navigator.popAndPushNamed(
                                    context, '/billentries');
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
                            'ரசிதுகளை உள்ளிட்டது',
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    InkWell(
                      onTap: () {
                        print('inside the date on tap');
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.calendar_month),
                            Text(
                              '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectDateRange(context);
                              },
                              child: Image.asset(
                                'assets/images/arrowdown.png',
                                width: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    // _buildSelectStoreDropdown(),
                    /*_buildSearchField(),
                    SizedBox(
                      height: 30,
                    ),*/
                    _buildShopNameAndPathNameFilterDropdown(),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: _listStream.stream,
                          builder: (context, snapshot) {
                            return Obx(() {
                              final allbillentry = commonController
                                  .getAllUserBillModel.value?.data;
                              if (allbillentry == null ||
                                  allbillentry.isEmpty ||
                                  commonController.getExistingBills ==
                                      false) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 50.0),
                                    child: Text('ரசீதுகள் எதுவும் இல்லை.'),
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: allbillentry.length,
                                padding: const EdgeInsets.only(bottom: 60),
                                itemBuilder: ((context, index) {
                                  return buildCard(allbillentry[index]);
                                }),
                              );
                            });
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard(Datum data) {
    return InkWell(
      onTap: () async {
        String ids = data.orders
                ?.map(
                  (e) => e.billId,
                )
                .join(',')
                .toString() ??
            '';
        await commonController.getUserBillDetails(ids: ids);
        // await commonController.getBillDetails(data.date.toString());
        Get.toNamed('/billdetails');
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          data.date.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 0.5,
                ),
                _buildBillDetailsList(data),
                const SizedBox(
                  height: 32.0,
                ),
              ],
            ),
            const Positioned(
                bottom: 5,
                right: 10,
                child: InkWell(
                    child: Text(
                  'விபரங்களை பார்க்க',
                  style: TextStyle(
                      fontSize: 11, color: Color.fromRGBO(120, 89, 207, 1)),
                )))
          ],
        ),
      ),
    );
  }

  filterJobs() async {
    await commonController.getAllUserBillEntries(
        startDate: fSdate,
        endDate: fEdate,
        shopName: _searchController.text,
        pathId: _selectedPathName,
        storeId: selectedStoreName);
    /*commonController.getallbuildentry(
        type: dropdownValue,
        startDate: fSdate,
        endDate: fEdate,
        filter: selectedStoreName);*/
  }

  Widget _buildSelectStoreDropdown() {
    if (!storeList.contains('All')) {
      storeList.insert(0, 'All');
    }
    if (selectedStoreName.isEmpty) {
      selectedStoreName = 'All';
    }
    return Container(
      width: 250,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedStoreName.isEmpty ? null : selectedStoreName,
        onChanged: (String? newValue) {
          setState(() {
            selectedStoreName = newValue!;
            filterJobs();
          });
        },
        hint: const Text('கடையைத் தேர்ந்தெடுக்கவும்'),
        style: const TextStyle(
            fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
        icon: Image.asset(
          'assets/images/arrowdown.png',
          width: 13,
        ),
        items: storeList.map<DropdownMenuItem<String>>((String? value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value ?? ''),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  Widget _buildBillDetailsList(Datum data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Text(
            'Store Name: ${data.storeName ?? ' '}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Address: ${data.storeAddress ?? ' '}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Path Name: ${data.pathName ?? ' '}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),

          ///This Commented section is OrderNUmber, Time & Path
          /*Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Order Number'),
              ),
              Expanded(
                flex: 1,
                child: Text('Time'),
              ),
              Expanded(
                flex: 1,
                child: Text('Path'),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.orders?.length,
            itemBuilder: (context, index) {
              Order? dataDetails = data.orders?[index];
              return _buildDetailsCard(dataDetails);
            },
          ),*/
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Order? dataDetails) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(dataDetails?.orderNo ?? ''),
              ),
              Expanded(
                flex: 1,
                child: Text(dataDetails?.time ?? ''),
              ),
              Expanded(
                flex: 1,
                child: Text(dataDetails?.path ?? ''),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          filterJobs();
        },
        decoration: InputDecoration(
          hintText: 'கடையை தேடு',
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
                  commonController.getAllUserBillEntries(
                    pathId: _selectedPathName,
                    startDate: fSdate,
                    endDate: fEdate,
                  );
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
                  commonController.getAllUserBillEntries(
                    storeId: _selectedShopName,
                    pathId: _selectedPathName,
                    startDate: fSdate,
                    endDate: fEdate,
                  );
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

import 'dart:async';

import 'package:billing_app/components/app_widget_utils.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Stock_Line_Report extends StatefulWidget {
  const Stock_Line_Report({super.key});

  @override
  State<Stock_Line_Report> createState() => _Stock_Line_ReportState();
}

class _Stock_Line_ReportState extends State<Stock_Line_Report> {
  bool isClientsOption = false;
  var commonController = Get.put(CommonController());
  String lineDropdownValue = '';
  String empDropdownvalue = '';
  String typeDropDownvalue = '';
  String collectuservalue = '';
  DateTime _startDate = DateTime.now();
  List<String> type = <String>['டெலிவரி செய்பவர்', 'சேகரிக்கும் நபர்'];

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void dispose() {
    _resetState();
    super.dispose();
  }

  void _resetState() {
    setState(() {
      _startDate = DateTime.now();
      selecteddate = DateFormat('yyyy-MM-dd').format(_startDate);
    });
  }

  DateTime selectedDate = DateTime.now();
  String selecteddate = '';
  String _selectedFromTime = '';
  String _selectedToTime = '';
  final _timeFieldsStream = StreamController.broadcast();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(DateTime.now().year + 2));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selecteddate = DateFormat('yyyy-MM-dd').format(picked);
        lineDropdownValue = '';
        empDropdownvalue = '';
        typeDropDownvalue = '';
        collectuservalue = '';
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context, String fromValue) async {
    final TimeOfDay? picked = await showTimePicker(
      barrierLabel: fromValue,
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    if (fromValue == 'fromTime') {
      if (_selectedToTime != '') {
        final selectedTo = _parseTimeOfDay(_selectedToTime);
        if (!_isBefore(picked, selectedTo)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'தொடக்க நேரம் முடிவு நேரத்திற்கு முந்தியதாக இருக்க வேண்டும்.')),
          );
          return;
        }
      }
      _selectedFromTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    } else {
      if (_selectedFromTime != '') {
        final selectedFrom = _parseTimeOfDay(_selectedFromTime);
        if (!_isBefore(selectedFrom, picked)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'முடிவு நேரம் தொடக்க நேரத்திற்குப் பிறகு இருக்க வேண்டும்.')),
          );
          return;
        }
      }
      _selectedToTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }

    _timeFieldsStream.add(true);
  }

  bool _isBefore(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute < t2.minute);
  }

  TimeOfDay _parseTimeOfDay(String timeStr) {
    final parts = timeStr.split(':').map((e) => e.trim()).toList();
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/lines');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  CustomAppBar(text: 'வழி அறிக்கை', path: '/lines'),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              // ElevatedButton(onPressed: (){
                              //   print(commonController.linename);
                              // }, child: Text('')),

                              GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  width: 200,
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
                                        selecteddate,
                                        style: const TextStyle(fontSize: 16.0),
                                        // '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
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
                                height: 20.0,
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border:
                                      Border.all(color: Colors.grey, width: .5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: typeDropDownvalue.isEmpty
                                      ? null
                                      : typeDropDownvalue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      typeDropDownvalue = newValue!;
                                    });
                                  },
                                  hint: const Text(
                                    'வகையைத் தேர்ந்தெடுக்கவும்',
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  icon: Image.asset(
                                    'assets/images/arrowdown.png',
                                    width: 13,
                                  ),
                                  items: type.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  underline: Container(),
                                ),
                              ),
                              typeDropDownvalue == 'சேகரிக்கும் நபர்'
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 45, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        border: Border.all(
                                            color: Colors.grey, width: .5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: collectuservalue.isEmpty
                                            ? null
                                            : collectuservalue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            collectuservalue = newValue!;
                                          });
                                          // commonController.getUserlines(
                                          //     date: selecteddate,
                                          //     userId: commonController
                                          //         .employeeId![empDropdownvalue]
                                          //         .toString());
                                        },
                                        hint: const Text(
                                          'பணியாளரைத் தேர்ந்தெடுக்கவும்',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        icon: Image.asset(
                                          'assets/images/arrowdown.png',
                                          width: 13,
                                        ),
                                        items:
                                            commonController.collectionUserName!
                                                .map((id, name) {
                                                  return MapEntry(
                                                      id,
                                                      DropdownMenuItem<String>(
                                                        value: name,
                                                        child: Text(name),
                                                      ));
                                                })
                                                .values
                                                .toList(),
                                        underline: Container(),
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 45, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        border: Border.all(
                                            color: Colors.grey, width: .5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: empDropdownvalue.isEmpty
                                            ? null
                                            : empDropdownvalue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            empDropdownvalue = newValue!;
                                            lineDropdownValue = '';
                                            commonController.getUserlines(
                                                date: selecteddate,
                                                userId: commonController
                                                    .employeeId![
                                                        empDropdownvalue]
                                                    .toString());
                                          });
                                        },
                                        hint: const Text(
                                          'பணியாளரைத் தேர்ந்தெடுக்கவும்',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        icon: Image.asset(
                                          'assets/images/arrowdown.png',
                                          width: 13,
                                        ),
                                        items: commonController.employeeName!
                                            .map((id, name) {
                                              if (commonController
                                                  .employeeName!.isEmpty) {
                                                showToast(
                                                    'பாதைகள் கிடைக்க வில்லை');
                                              }
                                              return MapEntry(
                                                  id,
                                                  DropdownMenuItem<String>(
                                                    value: name,
                                                    child: Text(name),
                                                  ));
                                            })
                                            .values
                                            .toList(),
                                        underline: Container(),
                                      ),
                                    ),
                              typeDropDownvalue == 'டெலிவரி செய்பவர்'
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 45, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        border: Border.all(
                                            color: Colors.grey, width: .5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: lineDropdownValue.isEmpty
                                            ? null
                                            : lineDropdownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            lineDropdownValue = newValue!;
                                          });
                                        },
                                        hint: const Text(
                                          'பாதையைத் தேர்ந்தெடுக்கவும்',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        icon: Image.asset(
                                          'assets/images/arrowdown.png',
                                          width: 13,
                                        ),
                                        items: commonController.linename!
                                            .map((id, name) {
                                              return MapEntry(
                                                  id,
                                                  DropdownMenuItem<String>(
                                                    value: name,
                                                    child: Text(name),
                                                  ));
                                            })
                                            .values
                                            .toList(),
                                        underline: Container(),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 18,
                              ),
                              _buildFromAndToTimePicker(),
                              AppWidgetUtils.buildSizedBox(custHeight: 35),
                              InkWell(
                                onTap: () async {
                                  print(commonController
                                      .employeeId![empDropdownvalue]
                                      .toString());
                                  if (typeDropDownvalue == 'சேகரிக்கும் நபர்') {
                                    await commonController
                                        .getCollectionUserReport(
                                      startTime: _selectedFromTime,
                                      endTime: _selectedToTime,
                                      userId: commonController
                                          .employeeId![collectuservalue]
                                          .toString(),
                                      startDate: selecteddate,
                                      onSuccessCallBack: (status) {
                                        if (status == 1) {
                                          Get.toNamed(
                                              'stocklinecollectionreport');
                                        } else {
                                          showToast(
                                              'பில் உள்ளீடு தரவு கிடைக்கவில்லை');
                                        }
                                      },
                                    );
                                  } else if (typeDropDownvalue ==
                                      'டெலிவரி செய்பவர்') {
                                    if (lineDropdownValue.isEmpty) {
                                      showToast('பாதையைத் தேர்ந்தெடுக்கவும்');
                                    } else {
                                      await commonController.linestockreport(
                                          commonController
                                              .lineId![lineDropdownValue]
                                              .toString(),
                                          startDate: selecteddate,
                                          userId: commonController
                                              .employeeId![empDropdownvalue]
                                              .toString());
                                      Get.toNamed('/showstocklinereport');
                                    }
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(120, 89, 207, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'அறிக்கை கிடைக்கும்',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    await commonController.getlinePendingreport();
                    Get.toNamed('pendingproductslines');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    height: 50,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(120, 89, 207, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'நிலுவையில் உள்ள பொருட்கள்',
                        style: TextStyle(color: Colors.white),
                      ),
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

  Widget _buildFromAndToTimePicker() {
    return StreamBuilder(
        stream: _timeFieldsStream.stream,
        builder: (context, snapshot) {
          return Visibility(
            visible: typeDropDownvalue != 'டெலிவரி செய்பவர்',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimePickerField(_selectedFromTime, 'fromTime'),
                _buildTimePickerField(_selectedToTime, 'toTime'),
              ],
            ),
          );
        });
  }

  Widget _buildTimePickerField(String timeValue, String fromValue) {
    return GestureDetector(
      onTap: () {
        _showTimePicker(context, fromValue);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.sizeOf(context).width / 2.5,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timeValue,
              style: const TextStyle(fontSize: 16.0),
            ),
            const Icon(Icons.timer),
          ],
        ),
      ),
    );
  }

// Widget containerBuild() {
//   return Container(
//     width: double.infinity,
//     child: Column(
//       children: [
//         Container(
//           height: 40,
//           padding: EdgeInsets.symmetric(horizontal: 20.0),
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(120, 89, 207, 1),
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(12),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'தேதி',
//                 style: TextStyle(color: Colors.white),
//               ),
//               SizedBox(
//                 width: 70.0,
//               ),
//               Expanded(
//                 child: Text(
//                   'கடை',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               Text(
//                 'தொகை',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.grey,
//               width: .5,
//             ),
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(12),
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Container(
//               child: Obx(() {
//                 final report = commonController.reportModel.value?.data;
//                 if (report == null || report.isEmpty) {
//                   return Center(
//                       child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 20.0),
//                     child: SelectableText('அறிக்கைகள் இல்லை'),
//                   ));
//                 }
//                 return ListView.builder(
//                   itemCount: report.length ?? 0,
//                   shrinkWrap: true,
//                   padding: EdgeInsets.all(0),
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: ((context, index) {
//                     return buildRow(report[index]);
//                   }),
//                 );
//               }),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 80,
//         )
//       ],
//     ),
//   );
// }

// buildRow(Datum data) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SelectableText(
//           data.date,
//           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(
//           width: 35.0,
//         ),
//         Expanded(
//           child: SelectableText(
//             data.storeName,
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//           ),
//         ),
//         SelectableText(
//           data.amount,
//           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(
//           width: 5,
//         ),
//       ],
//     ),
//   );
// }
}

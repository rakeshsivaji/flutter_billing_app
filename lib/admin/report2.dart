import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Report2_Page extends StatefulWidget {
  const Report2_Page({super.key});

  @override
  State<Report2_Page> createState() => _Report2_PageState();
}

class _Report2_PageState extends State<Report2_Page> {
  List<String> list = <String>[];
  String dropdownValue = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/report');
        return true;
      },      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(text: 'அறிக்கை',path: '/report',),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  border:
                                      Border.all(color: Colors.grey, width: .5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValue.isEmpty
                                      ? null
                                      : dropdownValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  hint: const Text('அறிக்கையைத் தேர்ந்தெடுக்கவும்'),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  icon: const Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.black,
                                  ),
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  underline: Container(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
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
                                  SelectableText(
                                    '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
      
                                    // '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        _selectDateRange(context);
                                      },
                                      child: const Icon(Icons.arrow_drop_down)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                width: 250,
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
                              height: 400,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Positioned(
                                bottom: 10,
                                child: Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(120, 89, 207, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                          height: 25,
                                          width: 25,
                                          'assets/images/download.png'),
                                      const Center(
                                        child: Text(
                                          'அறிக்கை கிடைக்கும்',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

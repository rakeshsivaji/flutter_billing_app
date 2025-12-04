import 'dart:io';

import 'package:billing_app/Models/report_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:printing/printing.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
//import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class Report_Page extends StatefulWidget {
  const Report_Page({super.key});

  @override
  State<Report_Page> createState() => _Report_PageState();
}

class _Report_PageState extends State<Report_Page> {
  bool isClientsOption = false;
  var commonController = Get.put(CommonController());

  List<String> list = <String>[
    'மொத்த ரசீது',
    'பெறப்பட்ட ஆர்டர்',
    'நிலுவையில் உள்ள ஆர்டர்'
  ];
  String dropdownValue = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String fSdate = '';
  String fEdate = '';
  int _counter = 0;
  bool hasData = true;

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  filterJobs() async {
    commonController.getReport(
      type: dropdownValue,
      startDate: fSdate,
      endDate: fEdate,
    );
  }

  void _resetState() async {
    final permissionStatus = await Permission.storage.status;
    /*if (permissionStatus.isDenied) {
      await Permission.storage.request();
      if (permissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      // _requestStoragePermission();
    }*/
    setState(() {
      dropdownValue = '';
      _startDate = DateTime.now();
      _endDate = DateTime.now();
      commonController.reportModel.value =
          ReportModel(status: 0, data: [], downloadUrl: '');
    });
  }

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
      });
    }
  }

  // formatDate(DateTime date) {
  //   return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  // }
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(text: 'அறிக்கைகள்', path: '/adminhome'),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildDropdown(),
                            buildDateRangePicker(),
                            const SizedBox(height: 25),
                            buildGenerateReportButton(),
                            const SizedBox(height: 20),
                            containerBuild(),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            buildDownloadButton(),
          ],
        ),
      ),
    );
  }

  Container containerBuild() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(120, 89, 207, 1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'தேதி',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 70.0,
                ),
                Expanded(
                  child: Text(
                    'கடை',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  'தொகை',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: .5,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                child: Obx(() {
                  final report = commonController.reportModel.value?.data;
                  if (report == null || report.isEmpty || hasData) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: SelectableText('அறிக்கைகள் இல்லை'),
                    ));
                  }
                  return ListView.builder(
                    itemCount: report.length ?? 0,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return buildRow(report[index]);
                    }),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  Padding buildRow(Datum data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectableText(
            data.date,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 35.0,
          ),
          Expanded(
            child: SelectableText(
              data.storeName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          SelectableText(
            data.amount,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Widget buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey, width: .5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue.isEmpty ? null : dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          hint: const Text(
            'அறிக்கையைத் தேர்ந்தெடுக்கவும்',
            style: TextStyle(fontSize: 12.0),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black),
          icon: Image.asset(
            'assets/images/arrowdown.png',
            width: 13,
          ),
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: Container(),
        ),
      ),
    );
  }

  Widget buildDateRangePicker() {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.calendar_month),
          GestureDetector(
            onTap: () => _selectDateRange(context),
            child: Text(
              '${_startDate.year}-${_startDate.month}-${_startDate.day} to ${_endDate.year}-${_endDate.month}-${_endDate.day}',
            ),
          ),
          GestureDetector(
            onTap: () => _selectDateRange(context),
            child: Image.asset('assets/images/arrowdown.png', width: 13),
          ),
        ],
      ),
    );
  }

  Widget buildGenerateReportButton() {
    return InkWell(
      onTap: () async {
        if (dropdownValue.isEmpty) {
          showToast('அறிக்கையைத் தேர்ந்தெடுக்கவும்');
        } else {
          fSdate = formatter.format(_startDate);
          fEdate = formatter.format(_endDate);
          filterJobs();
          await commonController.getReport(
            type: dropdownValue,
            startDate: fSdate,
            endDate: fEdate,
            onCallBackFunction: (status) {
              setState(() {
                if (status != 1) {
                  hasData = true;
                  showToast('தரவு கிடைக்கவில்லை');
                } else {
                  hasData = false;
                }
              });
            },
          );
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
    );
  }

  Widget buildDownloadButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: commonController.reportModel.value?.downloadUrl != null
            ? downloadFile
            : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: 50,
          width: 180,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(120, 89, 207, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                height: 25,
                width: 25,
                'assets/images/download.png',
              ),
              const Center(
                child: Text(
                  'பதிவிறக்கம்',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*void _download() async {
    // await _requestStoragePermission();
    var status = await Permission.storage.request();

    if (!status.isGranted) {
      Fluttertoast.showToast(msg: 'சேமிப்பக அனுமதி மறுக்கப்பட்டது');
      return;
    }

    String downloadUrl = commonController.reportModel.value?.downloadUrl ?? "";
    print(downloadUrl);

    if (downloadUrl.isEmpty) {
      Fluttertoast.showToast(
          msg: 'பதிவிறக்க URL காலியாக உள்ளது',
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          textColor: Colors.white);
      return;
    }

    Directory? directory;
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      Fluttertoast.showToast(
          msg: 'சேமிப்பக கோப்பகத்தை அணுக முடியவில்லை',
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          textColor: Colors.white);
      return;
    }

    String filePath = '${directory.path}/அறிக்கை.pdf';
    final taskId = await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: directory.path,
      fileName: "அறிக்கை.pdf",
      showNotification: true,
      openFileFromNotification: true,
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (taskId == id) {
        if (status == DownloadTaskStatus.complete) {
          Fluttertoast.showToast(
            msg: 'கோப்பு பதிவிறக்கம் செய்யப்பட்டது: $filePath',
            backgroundColor: Color.fromRGBO(120, 89, 207, 1),
            textColor: Colors.white,
          );
          print('File downloaded successfully: $filePath');
        } else if (status == DownloadTaskStatus.failed) {
          Fluttertoast.showToast(
            msg: 'கோப்பு பதிவிறக்கம் தோல்வியடைந்தது: $filePath',
            backgroundColor: Color.fromRGBO(120, 89, 207, 1),
            textColor: Colors.white,
          );
          print('Failed to download file');
        }
      }
    });
  }*/

  String generateFileName() {
    _counter++;
    return 'bill-report -${_counter.toString().padLeft(2)}';
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission denied');
      // Optionally, redirect to settings
      openAppSettings();
    }
  }

  Future<bool> checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> downloadFile() async {
    // bool hasPermission = await checkPermissions();
    // if (!hasPermission) return;

    try {
      final response = await http.get(
          Uri.parse(commonController.reportModel.value?.downloadUrl ?? ''));
      if (response.statusCode == 200) {
        final dir = await Directory('/storage/emulated/0/Download');
        final filePath = '${dir.path}/bill-report.pdf';
        int counter = 1;
        String newFilePath = filePath;
        while (await File(newFilePath).exists()) {
          newFilePath = '${dir.path}/bill-report ($counter).pdf';
          counter++;
        }
        final file = File(newFilePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded: $newFilePath');
        showToast('வெற்றிகரமாக பதிவிறக்கம் செய்யப்பட்டது');
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
}

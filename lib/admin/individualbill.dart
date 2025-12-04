import 'dart:async';
import 'dart:io';

import 'package:billing_app/Models/individualbill_model.dart';
import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/custom_dropdown_button_form_field.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';

class Individual_bill extends StatefulWidget {
  const Individual_bill({super.key});

  @override
  State<Individual_bill> createState() => _Individual_billState();
}

class _Individual_billState extends State<Individual_bill> {
  var commonController = Get.put(CommonController());
  final TextEditingController search = TextEditingController();
  final String pdfUrl = 'https://example.com/yourfile.pdf';
  String _selectedPathName = '';
  String _selectedShopName = '';
  final _pathStream = StreamController.broadcast();
  final _storeStream = StreamController.broadcast();
  final _storeListStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _pathStream.add(true);
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed('/adminhome');
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
                          width: 10.0,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'தனிப்பட்ட ரசிது',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await commonController
                                      .getIndividualBillsReceipt(
                                    functionCallBack: (statusCode) {
                                      if (statusCode == 1) {
                                        Get.toNamed('/individualBillsReceipt',
                                            arguments: {
                                              'data': commonController
                                                  .individualBillsModel
                                                  .value
                                                  ?.data
                                            });
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           const IndividualBillsReceipt(),
                                        //     ));
                                      } else if (statusCode == 0) {
                                        showToast(
                                            'பில் பட்டியல் காலியாக உள்ளது');
                                      }
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                        height: 20,
                                        width: 20,
                                        'assets/images/print.png'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'அனைத்தையும்\nஅச்சிடுங்கள்',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 9),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        /*Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromRGBO(250, 250, 250, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: search,
                            onChanged: (value) {
                              filterJobs(search: value);
                            },
                            decoration: InputDecoration(
                              hintText: 'தேடு கடை',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/images/search.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppWidgetUtils.buildSizedBox(custHeight: 12),*/
                        _buildShopNameAndPathNameFilterDropdown(),
                        const SizedBox(
                          height: 12,
                        ),
                        StreamBuilder(
                            stream: _storeListStream.stream,
                            builder: (context, snapshot) {
                              return Container(
                                child: Obx(() {
                                  final bills = commonController
                                      .individualBillModel.value?.data;
                                  if (bills == null || bills.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50.0),
                                      child: Center(
                                          child:
                                              Text('தனிப்பட்ட ரசிதுகள் இல்லை')),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: bills.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: ((context, index) {
                                      return buildCard1(bills[index]);
                                    }),
                                  );
                                }),
                              );
                            }),
                        const SizedBox(
                          height: 80.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await commonController.getAllPath();
            Get.toNamed('/createindividualbill');
          },
          backgroundColor: const Color.fromRGBO(120, 89, 217, 1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  filterJobs({
    String? search,
  }) async {
    commonController.getIndBill(
      withLoader: false,
      search: search,
    );
  }

  InkWell buildCard1(Datum data) {
    return InkWell(
      onTap: () async {
        await commonController.getIndividualbillShow(data.storeId.toString(),
            withLoader: true);
        print(data.storeId.toString());
        Get.toNamed('/individualbilldetails',
            arguments: {'id': data.storeId.toString()});
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(120, 89, 207, 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(19, 19, 19, 0.1),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/shopicon.png',
                    width: 18,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          data.pathName,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SelectableText(
                          data.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SelectableText(data.address),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 60.0, top: 15.0, bottom: 15.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(data.ownerName)),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SelectableText(data.phone),
                ],
              ),
            )
          ],
        ),
      ),
    );
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

  void _download() async {
    var status = await Permission.storage.request();
    // String url =
    //     'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

    String downloadUrl =
        commonController.individualBillModel.value?.downloadUrl ?? '';
    print(downloadUrl);
    if (!status.isGranted) {
      return;
    }
    Directory? directory;
    directory = Directory('/storage/emulated/0/Download');

    String filePath = '${directory.path}/abc.pdf';
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: directory.path,
      fileName: 'allIndividualbills.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );

    // FlutterDownloader.registerCallback((id, status, progress) {
    //   if (taskId == id) {
    //     if (status == DownloadTaskStatus.complete) {
    //       Fluttertoast.showToast(
    //           msg: 'File downloaded successfully: $filePath');
    //       print('File downloaded successfully: $filePath');
    //     } else if (status == DownloadTaskStatus.failed) {
    //       Fluttertoast.showToast(msg: 'File download failed: $filePath');
    //       print('Failed to download file');
    //     }
    //   }
    // });
  }

  Widget _buildShopNameAndPathNameFilterDropdown() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  await commonController.getIndBill(
                      withLoader: true, pathId: _selectedPathName);
                  _storeListStream.add(true);
                  _storeStream.add(true);
                },
              );
            }),
        SizedBox(
          height: 10,
        ),
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
                  await commonController.getIndBill(
                      withLoader: true,
                      shopId: _selectedPathName,
                      pathId: _selectedShopName);
                  _storeListStream.add(true);
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

// Future<void> fetchAndPrintPdf() async {
//   try {
//     // Fetch the PDF from the URL
//     String downloadUrl =
//       commonController.individualBillModel.value?.downloadUrl ?? "";
//     final response = await http.get(Uri.parse(downloadUrl));
//     if (response.statusCode == 200) {
//       // Print the fetched PDF
//       await Printing.layoutPdf(
//         usePrinterSettings: true,
//         onLayout: (PdfPageFormat format) async => response.bodyBytes,
//       );
//     } else {
//       print('Failed to load PDF');
//     }
//   } catch (e) {
//     print('Error fetching or printing PDF: $e');
//   }
// }

/*void _downloadBill() async {
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    Fluttertoast.showToast(msg: 'Storage permission is required to download files.');
    return;
  }

  String downloadUrl = commonController.individualBillModel.value?.downloadUrl ?? "";
  if (downloadUrl.isEmpty) {
    Fluttertoast.showToast(msg: 'Download URL is invalid.');
    return;
  }
  print(downloadUrl);

  Directory directory = Directory('/storage/emulated/0/Download');
  if (!await directory.exists()) {
    Fluttertoast.showToast(msg: 'Download directory does not exist.');
    return;
  }

  // Define the file path
  String filePath = '${directory.path}/allIndividualbills.pdf';

  try {
    final taskId = await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: directory.path,
      fileName: "allIndividualbills.pdf",
      showNotification: true,
      openFileFromNotification: true,
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (taskId == id) {
        if (status == DownloadTaskStatus.complete) {
          Fluttertoast.showToast(msg: 'File downloaded successfully: $filePath');
          print('File downloaded successfully: $filePath');
        } else if (status == DownloadTaskStatus.failed) {
          Fluttertoast.showToast(msg: 'File download failed: $filePath');
          print('Failed to download file');
        }
      }
    });

  } catch (e) {
    Fluttertoast.showToast(msg: 'Error occurred during download: $e');
    print('Error occurred during download: $e');
  }
} */
}

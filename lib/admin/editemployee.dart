import 'package:billing_app/Models/allcollectionpath_model.dart';
import 'package:billing_app/Models/employeedetails_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditEmployee extends StatefulWidget {
  EditEmployee({super.key});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  Map<String, dynamic> newData = {};

  PlatformFile? selectedImage;
  String routeDropdownValue = '';
  String billDropdownValue = '';
  String selectedValue = '';
  String? img;
  String name = '';

  String image = '';
  String address = '';
  String phone = '';
  String aadharErrorText = '';
  String route = '';
  String email = '';
  bool obscureTextPassword = true;
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController empName = TextEditingController();
  final TextEditingController employeePassword = TextEditingController();
  final TextEditingController empPhone = TextEditingController();
  final TextEditingController empEmail = TextEditingController();
  final TextEditingController empAddress = TextEditingController();
  final TextEditingController empAadharNoController = TextEditingController();
  EmployeeDetailsModel? employeeDetailsModel;
  AllCollectionPathModel? allCollectionPathModel;
  Map<int, String> resultMap = {};
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic response = await CommonService()
        .getEmployeeDetails(Get.arguments['id'].toString());
    if (response['status'] == 1) {
      setState(() {
        employeeDetailsModel = EmployeeDetailsModel.fromJson(response);
        empName.text = employeeDetailsModel?.data.name ?? '';
        empAddress.text = employeeDetailsModel!.data.address;
        empPhone.text = employeeDetailsModel!.data.phone;
        empEmail.text = employeeDetailsModel?.data.email ?? '';
        empAadharNoController.text =
            employeeDetailsModel?.data.aadharNumber ?? '';
        selectedValue = employeeDetailsModel!.data.stockCreate;
        print('the stock value is ******888 $selectedValue');
        img = employeeDetailsModel!.data.image;
        // billDropdownValue =
        //     employeeDetailsModel!.data.collectionPathId;
        billDropdownValue = commonController.allPath?[int.parse(
                    employeeDetailsModel?.data.collectionPathId ?? '')] ==
                null
            ? ''
            : commonController.allPath?[
                int.parse(employeeDetailsModel?.data.collectionPathId ?? '')];
      });
    }
  }

  void openFiles() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      setState(() {
        selectedImage = resultFile.files.first;
      });
    } else {
      print('Error occurred');
    }
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

  void submit() async {
    if (_formKey1.currentState!.validate()) {
      if (empName.text.isEmpty ||
          empAddress.text.isEmpty ||
          empPhone.text.isEmpty) {
        return;
      }
      if (empPhone.text.length < 10) {
        return;
      }
      if (empAadharNoController.text.length < 12) {
        return;
      }
      setState(() {
        clicked = true;
      });
      try {
        if (empEmail.text.isNotEmpty) {
          newData = {
            'name': empName.text,
            'email': empEmail.text,
            'address': empAddress.text,
            'phone': empPhone.text,
            'collection_path_id': billDropdownValue == 'Not Selected'
                ? 'null'
                : commonController.allPathId![billDropdownValue].toString(),
            'stock_create': selectedValue,
            'aadhar_no': empAadharNoController.text,
          };
        } else {
          newData = {
            'name': empName.text,
            // 'email': empEmail.text,
            'address': empAddress.text,
            'phone': empPhone.text,
            'collection_path_id': billDropdownValue == 'Not Selected'
                ? 'null'
                : commonController.allPathId![billDropdownValue].toString(),
            'stock_create': selectedValue,
            'aadhar_no': empAadharNoController.text,
          };
        }

        Map<String, dynamic> file = {
          'image': selectedImage,
        };

        dynamic response = await CommonService().updateEmployee(
            newData, file, employeeDetailsModel!.data.userId.toString());

        if (response['status'] == 1) {
          showToast(response['message']);
          await commonController.getEmployee(withLoader: true);
          Get.toNamed('/employees');
        } else {
          showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
          setState(() {
            clicked = false;
          });
        }
      } catch (error) {
        print('Error: $error');
        showToast('பிழை ஏற்பட்டது');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/employees');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'பணியாளரை திருத்தவும்',
              path: '/employees',
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
                        horizontal: 25.0, vertical: 10.0),
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        children: [
                          const SizedBox(height: 25.0),
                          buildFormField('பணியாளர் பெயரை உள்ளிடவும்', empName,
                              (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                name = 'பணியாளர் பெயரை உள்ளிடவும்';
                              } else {
                                name = '';
                              }
                            });
                            return null;
                          }),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          chooseImage(),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                image,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          buildAddressField(
                              'பணியாளர் முகவரியை உள்ளிடவும்', empAddress,
                              (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                address = 'பணியாளர் முகவரியை உள்ளிடவும்';
                              } else {
                                address = '';
                              }
                            });
                            return null;
                          }),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                address,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          buildFormField(
                              'பணியாளர் தொலைபேசி எண்ணை உள்ளிடவும்', empPhone,
                              (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                phone = 'பணியாளர் தொலைபேசி எண்ணை உள்ளிடவும்';
                              } else if (value.length < 10) {
                                phone = '10 எண்களை உள்ளிடவும்';
                              } else if (value.length > 10) {
                                phone = 'எண்களை சரி செய்யவும்';
                              } else {
                                phone = '';
                              }
                            });
                            return null;
                          }),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                phone,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            margin: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(250, 250, 250, 1),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: TextFormField(
                              controller: empEmail,
                              decoration: const InputDecoration(
                                hintText: 'பணியாளர் மின்னஞ்சலை உள்ளிடவும்',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
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
                              ),
                              // validator: (value) {
                              //   final emailRegex = RegExp(
                              //       r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
                              //   if (value == null || value.isEmpty) {
                              //     email = 'பணியாளர் மின்னஞ்சலை உள்ளிடவும்';
                              //   } else if (!emailRegex.hasMatch(value)) {
                              //     email = 'சரியான மின்னஞ்சலை உள்ளிடவும்';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildEmployeeAadharCardNo(),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                aadharErrorText,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          // buildFormField(
                          //     'பணியாளர் மின்னஞ்சலை உள்ளிடவும்', empEmail,
                          //     (value) {
                          //   setState(() {
                          //     if (value == null || value.isEmpty) {
                          //       email = 'பணியாளர் மின்னஞ்சலை உள்ளிடவும்';
                          //     } else if (!value.contains('@')) {
                          //       email =
                          //           '@ சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';
                          //     } else {
                          //       email = '';
                          //     }
                          //   });
                          // }),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                email,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          buildSelectField(),
                          const SizedBox(
                            height: 25,
                          ),
                          buildStockCreateSettings(),
                          const SizedBox(height: 40.0),
                          InkWell(
                            onTap: () {
                              if (clicked == false) {
                                submit();
                              }
                            },
                            child: Container(
                              width: 120,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(120, 89, 217, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: clicked
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'மேம்படுத்தல்',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildFormField(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
              color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: validator,
      ),
    );
  }

  Container buildAddressField(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: empAddress,
        maxLines: 20,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
              color: Colors.grey, fontSize: 15, fontWeight: FontWeight.normal),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: validator,
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'முகவரியை உள்ளிடவும்';
        //   }
        //   return null;
        // },
      ),
    );
  }

  Container buildSelectField() {
    // Set a default value if billDropdownValue is empty
    if (billDropdownValue.isEmpty &&
        commonController.allPath != null &&
        commonController.allPath!.isNotEmpty) {
      billDropdownValue = commonController.allPath!.keys.first.toString();
    }

    return Container(
      width: double.infinity,
      height: 45,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: billDropdownValue.isEmpty || billDropdownValue == 'null'
            ? null
            : billDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            billDropdownValue = newValue!;
          });
        },
        hint: const Text(
          'சேகரிப்பு பாதையை தேர்வு செய்க',
          style: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 13, color: Colors.black),
        icon: Image.asset('assets/images/arrowdown.png', width: 15),
        items: [
          const DropdownMenuItem<String>(
            value: 'Not Selected',
            child: Text('Not Selected'),
          ),
          ...commonController.allPath!.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.value ?? ''),
            );
          }).toList(),
        ],
        underline: Container(),
      ),
    );
  }

  Column buildStockCreateSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'பங்கு உருவாக்க அமைப்புகள்',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10.0),
        FormField<String>(
          initialValue: selectedValue,
          validator: (value) {
            debugPrint('the select value is ****** $selectedValue');
            debugPrint('the select value is ****** ${selectedValue.isEmpty}');
            debugPrint(
                'the select value is ****** ${selectedValue.isNotEmpty}');
            if (selectedValue.isEmpty) {
              return 'ஒரு விருப்பத்தைத் தேர்ந்தெடுக்கவும்';
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.hasError)
                  Text(
                    state.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 11),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      child: RadioListTile<String>(
                        value: 'ஆம்',
                        activeColor: const Color.fromRGBO(120, 89, 217, 1),
                        groupValue: selectedValue,
                        onChanged: (value) {
                          state.didChange(value);
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text('ஆம்'),
                    const SizedBox(width: 30.0),
                    Container(
                      width: 30,
                      child: RadioListTile<String>(
                        value: 'இல்லை',
                        groupValue: selectedValue,
                        activeColor: const Color.fromRGBO(120, 89, 217, 1),
                        onChanged: (value) {
                          state.didChange(value);
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Text('இல்லை'),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Container chooseImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: selectedImage == null
                ? const SelectableText(
                    'பணியாளர் படம் ',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.normal),
                  )
                : SelectableText(
                    selectedImage?.name ?? '',
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
          ),
          GestureDetector(
            onTap: openFiles,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(120, 89, 217, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'தேர்வு',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeAadharCardNo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            aadharErrorText = 'ஆதார் எண் உள்ளிடவும்';
          } else if (value.length < 12) {
            aadharErrorText = '12 ஆதார் எண் உள்ளிடவும்';
          }
          return;
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          // Restrict input to digits
          LengthLimitingTextInputFormatter(12),
          // Restrict length to 12 characters
        ],
        controller: empAadharNoController,
        decoration: const InputDecoration(
          hintText: 'பணியாளர் ஆதார் எண் உள்ளிடவும்',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        ),
        // validator: (value) {
        //   final emailRegex = RegExp(
        //       r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
        //   if (value == null || value.isEmpty) {
        //     email = 'பணியாளர் மின்னஞ்சலை உள்ளிடவும்';
        //   } else if (!emailRegex.hasMatch(value)) {
        //     email = 'சரியான மின்னஞ்சலை உள்ளிடவும்';
        //   }
        //   return null;
        // },
      ),
    );
  }
}

import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({super.key});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  List<String> billList = <String>[
    'Tirunelveli - Tenkasi',
    'Tenkasi - Tirunelveli',
    'Bill 3'
  ];
  PlatformFile? selectedImage;
  String billDropdownValue = '';
  String selectedValue = '';
  String name = '';
  String password = '';
  String image = '';
  String address = '';
  String phone = '';
  String email = '';
  String route = '';
  String aadharErrorText = '';
  bool clicked = false;
  Map<String, dynamic> newData = {};
  bool obscureTextPassword = true;
  var commonController = Get.put(CommonController());
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController empName = TextEditingController();
  final TextEditingController employeePassword = TextEditingController();
  final TextEditingController empPhone = TextEditingController();
  final TextEditingController empEmail = TextEditingController();
  final TextEditingController empAadharNoController = TextEditingController();
  final TextEditingController empAddress = TextEditingController();

  void openFiles() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      setState(() {
        selectedImage = resultFile.files.first;
      });
      print(selectedImage!.name);
      print(selectedImage!.bytes);
      print(selectedImage!.extension);
      print(selectedImage!.path);
    } else {
      print('Error accured');
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
              text: 'பணியாளரை உருவாக்கவும்',
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
                          const SizedBox(
                            height: 15.0,
                          ),
                          buildFormField('பணியாளர் பெயரை உள்ளிடவும்', empName,
                              (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                name = 'பணியாளர் பெயரை உள்ளிடவும்';
                              } else {
                                name = '';
                              }
                              // if (selectedImage == null) {
                              //   image = 'பணியாளர் படம் உள்ளிடவும்';
                              // } else {
                              //   image = '';
                              // }
                              // if (billDropdownValue.isEmpty) {
                              //   route = 'சேகரிப்பு பாதையை உள்ளிடவும்';
                              // } else {
                              //   route = '';
                              // }
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
                          buildPasswordField('பணியாளர் கடவுச்சொல்லை உள்ளிடவும்',
                              employeePassword, (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                password = 'பணியாளர் கடவுச்சொல்லை உள்ளிடவும்';
                              } else if (value.length < 6) {
                                password =
                                    'கடவுச்சொல் 6 எழுத்துக்கள் இருக்க வேண்டும்';
                              } else {
                                password = '';
                              }
                              // if (selectedImage != null) {
                              //   image = 'assets/images/deprofile.jpg';
                              // } else {
                              //   image = '';
                              // }
                              // if (billDropdownValue.isEmpty) {
                              //   route = 'சேகரிப்பு பாதையை உள்ளிடவும்';
                              // } else {
                              //   route = '';
                              // }
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
                                password,
                                textAlign: TextAlign.left,
                                style:
                                    const TextStyle(color: Colors.red, fontSize: 11),
                              ),
                            ],
                          ),
                          chooseImage(),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       image,
                          //       textAlign: TextAlign.left,
                          //       style:
                          //           TextStyle(color: Colors.red, fontSize: 11),
                          //     ),
                          //   ],
                          // ),
                          addressFeild(
                              'பணியாளர் முகவரியை உள்ளிடவும்', empAddress,
                              (value) {
                            setState(() {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == '') {
                                address = 'பணியாளர் முகவரியை உள்ளிடவும்';
                              } else {
                                address = '';
                              }
                              // if (selectedImage != null) {
                              //   image = 'பணியாளர் படம் உள்ளிடவும்';
                              // } else {
                              //   image = '';
                              // }
                              // if (billDropdownValue.isEmpty) {
                              //   route = 'சேகரிப்பு பாதையை உள்ளிடவும்';
                              // } else {
                              //   route = '';
                              // }
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
                          buildFormField2(
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
                              // if (selectedImage != null) {
                              //   image = 'பணியாளர் படம் உள்ளிடவும்';
                              // } else {
                              //   image = '';
                              // }
                              // if (billDropdownValue.isEmpty) {
                              //   route = 'சேகரிப்பு பாதையை உள்ளிடவும்';
                              // } else {
                              //   route = '';
                              // }
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
                          //   'பணியாளர் மின்னஞ்சலை உள்ளிடவும்', empEmail,
                          //   (value) => EmailValidator.validate(value!)
                          //       ? null
                          //       : "பணியாளர் மின்னஞ்சலை உள்ளிடவும்",
                          //   // setState(() {
                          //   //   if (value == null || value.isEmpty) {
                          //   //     email = 'பணியாளர் மின்னஞ்சலை உள்ளிடவும்';
                          //   //   }

                          //   // final emailRegex = RegExp(
                          //   //     r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
                          //   // if (!emailRegex.hasMatch(value)) {
                          //   //   email =
                          //   //       'மின்னஞ்சல் சிறிய எழுத்தில் இருக்க வேண்டும்';
                          //   //   return ;
                          //   // }
                          //   // return null;
                          //   //  else if (!value.contains('@')) {
                          //   //   email =
                          //   //       '@ சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';
                          //   // }
                          //   //  else if (!value.contains('@')) {
                          //   //   email =
                          //   //       '@ சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';
                          //   // } else if (!value.toLowerCase().contains(value)) {
                          //   //   email =
                          //   //       'மின்னஞ்சல் சிறிய எழுத்தில் இருக்க வேண்டும்';
                          //   // }

                          //   //  else {
                          //   //   email = '';
                          //   // }
                          //   // if (selectedImage != null) {
                          //   //   image = 'பணியாளர் படம் உள்ளிடவும்';
                          //   // } else {
                          //   //   image = '';
                          //   // }
                          //   // if (billDropdownValue.isEmpty) {
                          //   //   route = 'சேகரிப்பு பாதையை உள்ளிடவும்';
                          //   // } else {
                          //   //   route = '';
                          //   //   // }
                          //   // }
                          //   // );
                          // ),
                          commonController.allPath == null
                              ? InkWell(
                                  onTap: () async {
                                    await commonController.getAllPath();
                                    Get.toNamed('/createsavedcollection');
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 17.0),
                                    margin: const EdgeInsets.only(top: 15),
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(250, 250, 250, 1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                        )),
                                    child: const Center(
                                      child: Text(
                                        'சேகரிப்பு பாதையை உருவாக்கவும்',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                )
                              : buildSelectfield(),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       route,
                          //       textAlign: TextAlign.left,
                          //       style:
                          //           TextStyle(color: Colors.red, fontSize: 11),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'பங்கு உருவாக்க அமைப்புகள்',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          FormField<String>(
                            initialValue: selectedValue,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 11),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 30,
                                        child: RadioListTile<String>(
                                          value: 'ஆம்',
                                          activeColor:
                                              const Color.fromRGBO(120, 89, 217, 1),
                                          groupValue: state.value,
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
                                          groupValue: state.value,
                                          activeColor:
                                              const Color.fromRGBO(120, 89, 217, 1),
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
                          const SizedBox(
                            height: 40.0,
                          ),
                          GestureDetector(
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
                                        'சேமி',
                                        style: TextStyle(color: Colors.white),
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
            ),
          ],
        ),
      ),
    );
  }

  Container addressFeild(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(250, 250, 250, 1),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: TextFormField(
        maxLines: 20,
        controller: empAddress,
        decoration: InputDecoration(
          hintText: label,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: validator,
      ),
    );
  }

  Container buildSelectfield() {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: DropdownButton<String>(
        isExpanded: true,
        value: billDropdownValue.isEmpty ? null : billDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            billDropdownValue = newValue!;
          });
        },
        hint: const Text(
          'சேகரிப்பு பாதையை தேர்வு செய்க',
          style: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black),
        icon: Image.asset(
          'assets/images/arrowdown.png',
          width: 15,
        ),
        items: commonController.allPath!
            .map((id, name) {
              return MapEntry(
                  id,
                  DropdownMenuItem<String>(
                    value: name == '' ? null : name,
                    child: Text(name ?? ''),
                  ));
            })
            .values
            .toList(),
        underline: Container(),
      ),
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
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: selectedImage == null
                ? const SelectableText(
                    'பணியாளர் படம்',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : SelectableText(
                    selectedImage?.name ?? '',
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              openFiles();
            },
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

  Container buildFormField(String label, TextEditingController controller,
      String? Function(String?)? validator) {
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
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: validator,
      ),
    );
  }

  Container buildFormField2(String label, TextEditingController controller,
      String? Function(String?)? validator) {
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
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        validator: validator,
      ),
    );
  }

  Container buildPasswordField(String label, TextEditingController controller,
      String? Function(String?)? validator) {
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
        controller: employeePassword,
        obscureText: obscureTextPassword,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureTextPassword = !obscureTextPassword;
              });
            },
            icon: obscureTextPassword
                ? const Icon(
                    Icons.visibility_off,
                    color: Color.fromRGBO(120, 89, 217, 1),
                  )
                : const Icon(
                    Icons.visibility,
                    color: Color.fromRGBO(120, 89, 217, 1),
                  ),
          ),
        ),
        validator: validator,
      ),
    );
  }

  void submit() async {
    if (_formKey1.currentState!.validate()) {
      // if (selectedImage == null) {
      //   setState(() {
      //     image = 'பணியாளர் படம் உள்ளிடவும்';
      //   });
      //   return;
      // } else {
      //   setState(() {
      //     image = '';
      //   });
      // }
      if (employeePassword.text.length < 6) {
        return;
      }
      if (empPhone.text.length < 10) {
        return;
      }if(empAadharNoController.text.length < 12){
      return;
      }
      setState(() {
        clicked = true;
      });
      try {
        if (empEmail.text.isNotEmpty) {
          newData = {
            'name': empName.text,
            'password': employeePassword.text,
            'email': empEmail.text,
            'address': empAddress.text,
            'phone': empPhone.text,
            'collection_path_id':
                commonController.allPathId![billDropdownValue].toString(),
            'stock_create': selectedValue,
            'aadhar_no': empAadharNoController.text,
          };
        } else {
          newData = {
            'name': empName.text,
            'password': employeePassword.text,
            'address': empAddress.text,
            'phone': empPhone.text,
            'collection_path_id':
                commonController.allPathId![billDropdownValue].toString(),
            'stock_create': selectedValue,
            'aadhar_no': empAadharNoController.text,
          };
        }

        Map<String, dynamic> file = {
          'image': selectedImage,
        };

        dynamic response = await CommonService().createEmployee(newData, file);

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
      // }
      // else{

      // }
    }
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
      ),
    );
  }
}
// selectedImage != null ||
// billDropdownValue.isNotEmpty

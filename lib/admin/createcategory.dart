import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  PlatformFile? selectedImage;
  String selectedValue = '';
  final _formKey = GlobalKey<FormState>();
  // final _categoryNameController = TextEditingController();
  // final _categoryImageController = TextEditingController();
  final TextEditingController name = TextEditingController();
  bool isselect = false;
  String nameError = '';
  String image = '';
  String isEnable = '';
  String status = '';
  bool clicked = false;
  var commonController = Get.put(CommonController());
  String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        nameError = 'வகை பெயரை உள்ளிடவும்';
      });
    } else {
      nameError = '';
    }
    if (selectedImage == null) {
      setState(() {
        image = 'வகை பெயரை உள்ளிடவும்';
      });
    } else {
      setState(() {
        image = '';
      });
    }
    return null;
  }

  // String? validateCategoryImage(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please choose correct file from your device ';
  //   }
  //   return null;
  // }

  String? validateStatus() {
    if (selectedValue.isEmpty) {
      return 'ஒரு நிலையைத் தேர்ந்தெடுக்கவும்';
    }
    return null;
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

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/categories');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'வகையை உருவாக்கவும்',
              path: '/categories',
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
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(250, 250, 250, 1),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: TextFormField(
                                controller: name,
                                decoration: const InputDecoration(
                                  hintText: 'வகை பெயரை உள்ளிடவும்',
                                  hintStyle: TextStyle(
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
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      nameError = 'வகை பெயரை உள்ளிடவும்';
                                    });
                                  } else {
                                    setState(() {
                                      nameError = '';
                                    });
                                  }
                                  return null;
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                nameError,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          // chooseImage(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            padding: const EdgeInsets.only(left: 15.0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(250, 250, 250, 1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: selectedImage == null
                                      ? const Text(
                                          ' வகை படம் ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : Text(
                                          selectedImage?.name ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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
                          ),

                          /*SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                image,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.0),
                              ),
                            ],
                          ),*/
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'நிலை',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          (selectedValue.isEmpty && isselect)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    isEnable,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                child: RadioListTile<String>(
                                  value: 'Active',
                                  activeColor: const Color.fromRGBO(120, 89, 217, 1),
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text('செயலில்'),
                              const SizedBox(
                                width: 30.0,
                              ),
                              Container(
                                width: 30,
                                child: RadioListTile<String>(
                                  value: 'Inactive',
                                  groupValue: selectedValue,
                                  activeColor: const Color.fromRGBO(120, 89, 217, 1),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text('செயலற்ற'),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
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

  Container chooseImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: selectedImage == null
                ? Text(
                    selectedImage?.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : const Text(
                    '     வகை படம் ',
                    style: TextStyle(
                      color: Colors.grey,
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

  void submit() async {
    if (_formKey.currentState!.validate()) {
      if(selectedValue.isEmpty){
        setState(() {
          isselect = true;
          isEnable = 'நிலையைத் தேர்ந்தெடுக்கவும்';
        });
      }else{
        isEnable = '';
      }

      setState(() {
        image = '';
      });
      try {
        Map<String, dynamic> newData = {
          'name': name.text.toString(),
          'status': selectedValue,
        };
        Map<String, dynamic> file = {
          'image': selectedImage,
        };
        setState(() {
          clicked = true;
        });
        dynamic response =
        await CommonService().createCategory(newData, file);
        if (response['status'] == 1) {
          showToast(response['message']);
          await commonController.getCategories(withLoader: true);
          Get.toNamed('/categories');
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


      /*if (selectedImage == null) {
        setState(() {
          image = 'வகை படத்தை உள்ளிடவும்';
        });
        return;
      } else {
      /// IF IMG NEED TO SET THE REQ CUT AND PASTE THE ABOVE TRY CATCH CODE
      }*/
    }
  }
}

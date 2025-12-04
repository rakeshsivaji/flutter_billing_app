import 'package:billing_app/Models/category_edit_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  PlatformFile? selectedImage;
  String selectedValue = '';
  bool isselect = false;
  bool clicked = false;

  final _formKey = GlobalKey<FormState>();
  // final _categoryNameController = TextEditingController();
  // final _categoryImageController = TextEditingController();
  final TextEditingController name = TextEditingController();
  var commonController = Get.put(CommonController());
  EditCategoryModel? editCategoryModel;
  String nameErrror = '';
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic response =
        await CommonService().getCategoryEdit(Get.arguments['id'].toString());
    if (response['status'] == 1) {
      setState(() {
        editCategoryModel = EditCategoryModel.fromJson(response);
        name.text = editCategoryModel!.data.name;
        selectedValue = editCategoryModel!.data.status.toString();
      });
    }
    print(response);
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
              text: 'வகையை திருத்தவும்',
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
                            margin: const EdgeInsets.only(bottom: 5),
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
                                    nameErrror = 'வகை பெயரை உள்ளிடவும்';
                                  });
                                } else {
                                  setState(() {
                                    nameErrror = '';
                                  });
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(nameErrror,
                                  style: const TextStyle(color: Colors.red))
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
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
                          const SizedBox(
                            height: 30.0,
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
                              ? const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'நிலையைத் தேர்ந்தெடுக்கவும்',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
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

  void submit() async {
    if (_formKey.currentState!.validate()) {
      if (name.text.isEmpty) {
        setState(() {
          nameErrror = 'வகை பெயரை உள்ளிடவும்';
        });
      } else {
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
          dynamic response = await CommonService().updateCategory(
              newData, file, editCategoryModel!.data.categoryId.toString());
          if (response != null && response['status'] == 1) {
            showToast(response['message']);
            await commonController.getCategories(withLoader: true);
            Get.toNamed('/categories');
          } else {
            showToast(response?['message'] ?? 'பிழை ஏற்பட்டது');
          }
        } catch (error) {
          print('Error: $error');
          showToast('பிழை ஏற்பட்டது');
        }
      }
    }
  }
}

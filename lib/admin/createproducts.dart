import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateProducts extends StatefulWidget {
  const CreateProducts({super.key});

  @override
  State<CreateProducts> createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  var commonController = Get.put(CommonController());
  final _formKey = GlobalKey<FormState>();
  bool isvalid = false;
  bool isselect = false;
  String Name = '';
  String Amount = '';
  String image = '';
  String selectvalue = '';
  String dropvalue = '';
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController();
  bool iscreate = true;
  PlatformFile? selectedImage;
  bool clicked = false;

  // String selectedValue = '';
  // String? validateProductName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'பெயரை உள்ளிடவும்';
  //   }
  //   return null;
  // }

  // String? validateProductImage(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'உங்கள் சாதனத்திலிருந்து சரியான கோப்பைத் தேர்ந்தெடுக்கவும்';
  //   }
  //   return null;
  // }

  // String? validateProductAmount(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'தயவுசெய்து தொகையை உள்ளிடவும்';
  //   }
  //   return null;
  // }

  List<String> list = <String>['Milk', 'Juice', 'Other'];
  String dropdownValue = '';

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/products');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'பொருட்களை உருவாக்கவும்',
              path: '/products',
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
                        child: Obx(() {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              vagaiyaithervuBuild(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    dropvalue,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              peiyarBuild(
                                  context, 'பொருள் பெயரை உள்ளிடவும்', name,
                                  (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    Name = 'பொருள் பெயரை உள்ளிடவும்';
                                  } else {
                                    Name = '';
                                  }
                                  if (selectedImage == null) {
                                    image = 'பொருள் படத்தை தேர்ந்தெடுக்கவும்';
                                  } else {
                                    image = '';
                                  }
                                  if (dropdownValue.isEmpty) {
                                    dropvalue = 'வகையை தேர்வு செய்க';
                                  } else {
                                    dropvalue = '';
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
                                    Name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              imageBuild(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    image,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              amountBuild(
                                  'தயவுசெய்து தொகையை உள்ளிடவும்', amount,
                                  (value) {
                                if (value == null || value.isEmpty) {
                                  Amount = 'தயவுசெய்து தொகையை உள்ளிடவும்';
                                } else {
                                  Amount = '';
                                }
                                return null;
                              }),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Amount,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 11),
                                  ),
                                ],
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              FormField<String>(
                                initialValue: selectvalue,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ஒரு விருப்பத்தைத் தேர்ந்தெடுக்கவும்';
                                  }
                                  return null;
                                },
                                builder: (FormFieldState<String> state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (state.hasError)
                                        Text(
                                          state.errorText!,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 11),
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 30,
                                            child: RadioListTile<String>(
                                              value: 'Active',
                                              activeColor: const Color.fromRGBO(
                                                  120, 89, 217, 1),
                                              groupValue: selectvalue,
                                              onChanged: (value) {
                                                state.didChange(value);
                                                setState(() {
                                                  selectvalue = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          const Text('செயலில்'),
                                          const SizedBox(width: 30.0),
                                          Container(
                                            width: 30,
                                            child: RadioListTile<String>(
                                              value: 'Inactive',
                                              groupValue: selectvalue,
                                              activeColor: const Color.fromRGBO(
                                                  120, 89, 217, 1),
                                              onChanged: (value) {
                                                state.didChange(value);
                                                setState(() {
                                                  selectvalue = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          const Text('செயலற்ற'),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),

                              // (selectedValue.isEmpty && isvalid)
                              //     ? Align(
                              //         alignment: Alignment.centerLeft,
                              //         child: Text(
                              //           "நிலையைத் தேர்ந்தெடுக்கவும்",
                              //           textAlign: TextAlign.left,
                              //           style: TextStyle(
                              //               color: Colors.red, fontSize: 12),
                              //         ),
                              //       )
                              //     : SizedBox(),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //       width: 30,
                              //       child: RadioListTile<String>(
                              //         value: 'Active',
                              //         activeColor: Color.fromRGBO(120, 89, 217, 1),
                              //         groupValue: selectedValue,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             selectedValue = value!;
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 10.0,
                              //     ),
                              //     Text('செயலில்'),
                              //     SizedBox(
                              //       width: 30.0,
                              //     ),
                              //     Container(
                              //       width: 30,
                              //       child: RadioListTile<String>(
                              //         value: 'Inactive',
                              //         groupValue: selectedValue,
                              //         activeColor: Color.fromRGBO(120, 89, 217, 1),
                              //         onChanged: (value) {
                              //           setState(() {
                              //             selectedValue = value!;
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 10.0,
                              //     ),
                              //     Text('செயலற்ற'),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (clicked == false) {
                                    submit(
                                      context,
                                    );
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          );
                        })),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container vagaiyaithervuBuild() {
    return Container(
      width: double.infinity,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          )),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue.isEmpty ? null : dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        hint: const Text(
          '  வகையை தேர்வு செய்க',
          style: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
        icon: Image.asset(
          'assets/images/arrowdown.png',
          width: 15,
        ),
        items: commonController.categoryName!
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
    );
  }

  Container amountBuild(String hint, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: SelectableText(
              ' ₹  |',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'பொருள் கட்டணம் தொகை',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                fillColor: const Color.fromRGBO(71, 52, 125, 1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Container imageBuild() {
    return Container(
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
                    ' பொருள் படம் ',
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
    );
  }

  Container peiyarBuild(BuildContext context, String hint,
      TextEditingController controller, String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.only(top: 5),
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
          hintText: 'பொருள் பெயரை உள்ளிடவும்',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
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
        validator: validator,
      ),
    );
  }

  void submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (name.text.isEmpty || amount.text.isEmpty || dropdownValue.isEmpty) {
        return;
      }
      if (selectedImage == null) {
        setState(() {
          isselect = true;
          image = 'பொருள் படத்தை தேர்ந்தெடுக்கவும்';
        });
        return;
      }

      // showToast('பொருள் படம் தேர்ந்தெடுக்கவும்');
      // return;
      // if (selectedValue.isEmpty) {
      //   setState(() {
      //     isvalid = true;
      //   });
      // }

      try {
        Map? map = {
          'category_id': commonController.categoryId![dropdownValue].toString(),
          'name': name.text.toString(),
          'amount': amount.text.toString(),
          'status': selectvalue.toString(),
        };
        Map<String, dynamic> file = {
          'image': selectedImage,
        };
        setState(() {
          clicked = true;
        });
        dynamic response = await CommonService().CreateProduct(map, file);
        if (response != null && response['status'] == 1) {
          setState(() {
            iscreate = false;
          });
          showToast(response['message']);
          Future.delayed(const Duration(milliseconds: 1), () {
            Get.toNamed('/products');
          });
          await commonController.getallProduct(withLoader: true);
        } else {
          showToast(response?['message'] ?? 'பிழை ஏற்பட்டது');
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
}

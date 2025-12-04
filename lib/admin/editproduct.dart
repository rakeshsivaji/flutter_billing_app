import 'package:billing_app/Models/product_edit_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var commonController = Get.put(CommonController());
  final _formKey = GlobalKey<FormState>();
  PlatformFile? selectedImage;
  String selectedValue = '';
  bool isupdate = true;
  String? productid;
  bool isvalid = false;
  bool isselect = false;
  bool isTrue = false;
  bool clicked = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController remove = TextEditingController();
  ProductEditModel? editProductModel;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic response =
        await CommonService().getProductEdit(Get.arguments['id'].toString());
    if (response['status'] == 1) {
      setState(() {
        editProductModel = ProductEditModel.fromJson(response);
        name.text = editProductModel!.data.name;
        amount.text = editProductModel!.data.amount;
        productid = editProductModel!.data.productId.toString();
        selectedValue = editProductModel!.data.status.toString();
        dropdownValue = commonController
            .categoryName![int.parse(editProductModel!.data.categoryId)];
      });
    }
    print(response);
  }

  @override
  void dispose() {
    name.clear();
    amount.clear();
    remove.dispose();
    selectedValue = '';
    dropdownValue = '';
    selectedImage = null;
    super.dispose();
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

  List<String> list = <String>['பால்', 'சாறு', 'மற்றவை'];
  String dropdownValue = '';

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
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.toNamed('/products');
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'பொருட்களை திருத்தவும்',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
          titleSpacing: -2.0,
        ),
        body: Column(
          children: [
            // CustomAppBar(
            //   text: 'பொருட்களை திருத்தவும்',
            //   path: '/products',
            // ),
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
                            height: 20.0,
                          ),
                          Container(
                            width: double.infinity,
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(250, 250, 250, 1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                )),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value:
                                  dropdownValue.isEmpty ? null : dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue ?? '';
                                });
                              },
                              hint: const Text(
                                'வகையை தேர்வு செய்க',
                                style: TextStyle(color: Colors.grey),
                              ),
                              style:
                                  const TextStyle(fontSize: 15, color: Colors.black),
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
                          ),
                          const SizedBox(
                            height: 20.0,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    isupdate = true;
                                  });
                                }
                                if (selectedValue.isEmpty) {
                                  setState(() {
                                    isvalid = true;
                                  });
                                  return;
                                }
                                if (amount.text.isEmpty) {
                                  setState(() {
                                    isTrue = true;
                                  });
                                  return;
                                }
                                return null;
                              },
                            ),
                          ),
                          (name.text.isEmpty && isselect)
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'பொருள் பெயரை உள்ளிடவும்',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ],
                                )
                              : const Text(''),
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
                                          ' பொருள் படம் ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : Text(
                                          selectedImage?.name ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
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
                            height: 20.0,
                          ),
                          Container(
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
                                  child: Text(
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      fillColor: const Color.fromRGBO(71, 52, 125, 1),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                    ),
                                    // validator: validateProductAmount,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (amount.text.isEmpty && isTrue)
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'பொருள் கட்டணம் உள்ளிடவும்',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ],
                                )
                              : const Text(''),
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
                          (selectedValue.isEmpty && isvalid)
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
                            height: 50.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _PopupMenu(productid.toString());
                                },
                                child: Container(
                                  width: 120,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(120, 89, 217, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        'அழி',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (clicked == false) {
                                    submit(context);
                                  }
                                },
                                child: Container(
                                  width: 130,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
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

  void _PopupMenu(String id) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'பொருட்களை நிச்சயமாக நீக்க விரும்புகிறீர்களா?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'ரத்து செய்',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: isupdate
                            ? () {
                                delete(context, id);
                                Navigator.pop(context);
                              }
                            : null,
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: isupdate
                                ? const Color.fromRGBO(120, 89, 207, 1)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'அழி',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              height: 30,
              width: 30,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/closeicon.png')),
            ),
          ],
        ),
      ),
    );
  }

  void delete(BuildContext context, String id) async {
    dynamic response = await CommonService().deleteProduct(id);
    try {
      if (response['status'] == 1) {
        setState(() {
          isupdate = false;
        });
        showToast(response['message']);
        await commonController.getallProduct(withLoader: true);
        Get.toNamed('/products');
      } else {
        setState(() {
          isupdate = true;
        });
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  //deleteProduct()

  void submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (name.text.isEmpty) {
        setState(() {
          isselect = true;
        });
        return;
      }
      if (selectedValue.isEmpty) {
        setState(() {
          isvalid = true;
        });
        return;
      }
      if (amount.text.isEmpty) {
        setState(() {
          isTrue = true;
        });
        return;
      }
      try {
        Map? file = {
          'image': selectedImage,
        };
        Map? map = {
          'name': name.text.toString(),
          'amount': amount.text.toString(),
          'status': selectedValue.toString(),
          'category_id': commonController.categoryId![dropdownValue].toString(),
        };
        setState(() {
          clicked = true;
        });
        dynamic response = await CommonService().updateProduct(
            editProductModel!.data.productId.toString(), map, file);

        if (response != null && response['status'] == 1) {
          setState(() {
            isupdate = false;
          });
          showToast(response['message']);
          await commonController.getallProduct(withLoader: true);
          Get.toNamed('/products');
        } else {
          showToast(response?['message'] ?? 'பிழை ஏற்பட்டது');
          clicked = false;
        }
      } catch (error) {
        print('Error: $error');
        showToast('பிழை ஏற்பட்டது');
      }
    }
  }
}

import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateStockLine extends StatefulWidget {
  const CreateStockLine({super.key});

  @override
  State<CreateStockLine> createState() => _CreateStockLineState();
}

class _CreateStockLineState extends State<CreateStockLine> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  var commonController = Get.put(CommonController());
  String routename = '';
  String selectedValue = '';
  bool isselect = false;
  bool clicked = false;
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

  String? validateStatus() {
    if (selectedValue.isEmpty) {
      return 'ஒரு நிலையைத் தேர்ந்தெடுக்கவும்';
    }
    return null;
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
        Get.toNamed('/lines');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'வழியை உருவாக்கவும்',
              path: '/lines',
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25.0,
                        ),
                        pathName('வழி பெயரை உள்ளிடவும்', name, (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              routename = 'வழி பெயரை உள்ளிடவும்';
                            } else {
                              routename = '';
                            }
                            if (selectedValue.isEmpty) {
                              isselect = true;
                            } else {
                              isselect = false;
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
                              routename,
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.red, fontSize: 11),
                            ),
                          ],
                        ),
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
          ],
        ),
      ),
    );
  }

  Widget pathName(String label, TextEditingController controller,
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
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: name,
          decoration: const InputDecoration(
            hintText: 'வழி பெயரை உள்ளிடவும்',
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
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          ),
          validator: validator,
        ),
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      if (name.text.isEmpty) {
        setState(() {
          routename = 'வழி பெயரை உள்ளிடவும்';
        });
        return;
      }
      if (selectedValue.isEmpty) {
        return;
      }
      setState(() {
        clicked = true;
      });
      try {
        Map<String, dynamic> newdata = {
          'name': name.text.toString(),
          'status': selectedValue,
        };
        dynamic response = await CommonService().createline(newdata);
        if (response['status'] == 1) {
          showToast(response['message']);
          await commonController.getlineshow();
          Get.toNamed('/lines');
        } else {
          showToast(response?['message'] ?? 'பிழை ஏற்பட்டது');
          setState(() {
            clicked = false;
          });
        }
      } catch (error) {
        print('Error:$error');
        showToast('பிழை ஏற்பட்டது');
      }
    }
  }
}

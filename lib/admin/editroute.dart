import 'package:billing_app/Models/editpath_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditRoute extends StatefulWidget {
  const EditRoute({super.key});

  @override
  State<EditRoute> createState() => _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  EditPathModel? editPathModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  var commonController = Get.put(CommonController());
  String routename = '';
  bool clicked = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    dynamic response =
        await CommonService().getPathEdit(Get.arguments['id'].toString());
    if (response['status'] == 1) {
      setState(() {
        editPathModel = EditPathModel.fromJson(response);
        name.text = editPathModel!.data.name;
      });
    }
    print(response);
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
        Get.toNamed('/routes');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'பாதையை திருத்தவும்',
              path: '/routes',
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
                        pathName('பாதை பெயரை உள்ளிடவும்', name, (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              routename = 'பாதை பெயரை உள்ளிடவும்';
                            } else {
                              routename = '';
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
                          height: 25.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (clicked == false) {
                              submit(context);
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

  Container pathName(String label, TextEditingController controller,
      String? Function(String?)? validator) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      margin: const EdgeInsets.only(bottom: 15),
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
            hintText: '',
            hintStyle: TextStyle(
              color: Colors.black,
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
      ),
    );
  }

  void submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (name.text.isEmpty) {
        return;
      }
      try {
        Map? map = {
          'name': name.text.toString(),
        };
        setState(() {
          clicked = true;
        });
        dynamic response = await CommonService().updatePath(
            map, commonController.editPathModel.value!.data.pathId.toString());
        if (response['status'] == 1) {
          showToast(response['message']);
          await commonController.getPath(withLoader: true);
          Get.toNamed('/routes');
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
}

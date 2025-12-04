import 'package:billing_app/Models/category_model.dart';
import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/services/common_service.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var commonController = Get.put(CommonController());

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

  bool isEditMode = false;
  bool isprofile = false;
  TextEditingController name = TextEditingController();
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    search.text = '';
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  // void saveChanges() async {
  //   Map<String, dynamic> updatedData = {
  //     'name': name.text,
  //   };

  // void getData() async {
  //   dynamic response = await CommonService().getAccountDetails();
  //   if (response['status'] == 1) {
  //     setState(() {
  //       profileModel = ProfileModel.fromJson(response);
  //       profileImage = profileModel?.data.image ?? "";
  //       isprofile = profileModel?.data.isJobProfile ?? false;
  //     });
  //   }
  // }

  //   try {
  //     var response = await CommonService().updateProfile(updatedData, file);
  //     if (response['status'] == 1) {
  //       Fluttertoast.showToast(msg: 'Profile updated successfully');
  //     } else {
  //       Fluttertoast.showToast(msg: 'Failed to update profile');
  //     }
  //   } catch (error) {
  //     print('Error updating profile: $error');
  //     Fluttertoast.showToast(msg: 'Error updating profile');
  //   }

  //   toggleEditMode();
  //   getData();
  // }

  @override
  Widget build(BuildContext context) {
    var commonController = Get.put(CommonController());
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(text: 'வகைகள்', path: '/adminhome'),
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
                          height: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromRGBO(250, 250, 250, 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: search,
                            onChanged: (value) {
                              filterJobs(search: value);
                            },
                            decoration: InputDecoration(
                              hintText: 'தேடு வகை',
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
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
                        const SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromRGBO(19, 19, 19, 0.1),
                              width: 2.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Obx(
                                  () {
                                    final allcategories = commonController
                                        .categorymodel.value?.data;
                                    if (allcategories == null ||
                                        allcategories.isEmpty) {
                                      return const Text('வகைகள் இல்லை');
                                    }
                                    return ListView.builder(
                                      itemCount: allcategories.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: ((context, index) {
                                        return buildCardItem(
                                            allcategories[index]);
                                      }),
                                    );
                                  },
                                ),
                              ),
                              // buildCardItem(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/createcategory');
            Get.toNamed('/createcategory');
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
    commonController.getCategories(
      withLoader: false,
      search: search,
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
                    'வகையை நிச்சயமாக நீக்க விரும்புகிறீர்களா ?',
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
                        onTap: () {
                          delete(context, id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(120, 89, 207, 1),
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
    dynamic response = await CommonService().deleteCategory(id);
    try {
      if (response['status'] == 1) {
        await commonController.getCategories(withLoader: true);
        showToast(response['message']);
        Get.toNamed('/categories');
      } else {
        showToast(response['message'] ?? 'பிழை ஏற்பட்டது');
      }
    } catch (error) {
      print('Error: $error');
      showToast('பிழை ஏற்பட்டது');
    }
  }

  Container buildCardItem(Datum data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(data.image), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: SelectableText(
                data.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            InkWell(
              onTap: () async {
                setState(() async {
                  await commonController
                      .getCategoriesEdit(data.categoryId.toString());
                  Get.toNamed('/editcategory',
                      arguments: {'id': data.categoryId.toString()});
                });
              },
              child: Image.asset(
                'assets/images/edit.png',
                width: 17,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            InkWell(
              onTap: () {
                _PopupMenu(data.categoryId.toString());
              },
              child: const Icon(
                Icons.delete,
                size: 25,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

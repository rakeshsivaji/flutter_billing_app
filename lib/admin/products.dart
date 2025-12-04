import 'package:billing_app/controllers/common_controller.dart';
import 'package:billing_app/widgets/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/product_model.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var commonController = Get.put(CommonController());
  final TextEditingController search = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollPosition = _scrollController.position.pixels;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (commonController.scrollPosition != null) {
        _scrollController.jumpTo(commonController.scrollPosition!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed('/adminhome');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 89, 207, 1),
        body: Column(
          children: [
            CustomAppBar(
              text: 'பொருள்கள்',
              path: '/adminhome',
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
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
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: search,
                            onChanged: (value) {
                              filterJobs(search: value);
                            },
                            decoration: InputDecoration(
                              hintText: 'தேடு பொருள்',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                          height: 20,
                        ),
                        Container(
                          child: Obx(
                            () {
                              if (commonController.productmodel.value?.data ==
                                  null) {
                                return const Text('தயாரிப்புகள் இல்லை');
                              }
                              return GridView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 15 / 20,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                itemCount: commonController
                                    .productmodel.value?.data.length,
                                itemBuilder: (context, index) {
                                  return gridMethod(commonController
                                      .productmodel.value!.data[index]);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        )
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
            commonController.scrollPosition = _scrollPosition;
            await commonController.getallCategories(withLoader: true);
            Get.toNamed('/createproducts');
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
    commonController.getallProduct(
      withLoader: false,
      search: search,
    );
  }

  InkWell gridMethod(Datum data) {
    return InkWell(
      onTap: () async {
        commonController.scrollPosition = _scrollPosition;
        await commonController.getallProductEdit(data.productId.toString());
        await commonController.getCategories(withLoader: true);
        Get.toNamed('/editproducts',
            arguments: {'id': data.productId.toString()});
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(2, 0), // Right shadow
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(-2, 0), // Left shadow
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(0, 2), // Bottom shadow
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 1,
              offset: const Offset(0, -2), // Top shadow
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                color: Color.fromRGBO(120, 89, 207, 0.2),
              ),
              child: Center(
                child: SelectableText(
                  data.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Expanded(
              child: Container(
                child: Image.network(data.image,
                fit: BoxFit.fill,),
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(19, 19, 19, 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  '₹' + data.amount,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}
